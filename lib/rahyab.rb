# coding: utf-8
require "rahyab/version"
require "builder"
require 'net/http'
require 'xml'
require 'libxml_to_hash'

module Rahyab
  require 'rahyab/string'

  class SMS
    # Return Errors
    attr_reader :errors

    # Constructor of Rahyab SMS Gateway
    def initialize(url, user, password, company, logger = nil)
      @url      = url
      @user     = user
      @password = password
      @company  = company
      @logger   = logger
    end

    # Will send one or more sms to specified numbers
    def send_sms(sender, numbers, text, **params)
      # Create the send XMLmarkup
      estimate_cost = estimate_cost(numbers, text)
      return -1 if estimate_cost == -1

      if estimate_cost < get_balance
        identity         = "#{Time.now.to_i}#{rand(1000000000..9999999999)}"
        batchID          = @company + "+" + identity
        is_persian_text  = is_persian(text)
        msgClass         = params["flash"] ? "0" : "1"
        dcs              = is_persian_text ? "8" : "0"
        binary           = is_persian_text ? "true" : "false"
        text             = text.to_h if is_persian_text

        builder          = Builder::XmlMarkup.new()
        builder.instruct! :xml, version: "1.0", encoding: "UTF-8"
        builder.declare! :DOCTYPE, :smsBatch, :PUBLIC, "-//PERVASIVE//DTD CPAS 1.0//EN", "http://www.ubicomp.ir/dtd/Cpas.dtd"
        builder.smsBatch(company: @company, batchID: batchID) do |b|
          b.sms(msgClass: msgClass, binary: binary, dcs: dcs) do |t|
            numbers.each do |number|
              t.destAddr() do |f|
                f.declare! "[CDATA[%s]]" % number
              end
            end
            t.origAddr() do |f|
              f.declare! "[CDATA[%s]]" % sender
            end
            t.message() do |f|
              f.declare! "[CDATA[#{text}]]"
            end
          end
        end

        out_xml = builder.target!

        result = send_xml(out_xml)

        source = XML::Parser.string(result)
        content = source.parse

        if content.find_first('ok')
          if  content.find_first('ok').content.include? 'CHECK_OK'
            @errors = nil
            batchID
          else
            @errors = "Something going wrong"
            nil
          end
        else
          @errors = content.find_first('message').content.strip
          nil
        end
      else
        @errors = 'Not enough balance'
        nil
      end
    end


    def send_batch(sender, numbers, text)
    end

    # Check delivery status of several sms
    def get_delivery(batchID)
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct! :xml, version: "1.0"
      builder.declare! :DOCTYPE, :smsStatusPoll, :PUBLIC, "-//PERVASIVE//DTD CPAS 1.0//EN", "http://www.ubicomp.ir/dtd/Cpas.dtd"
      builder.smsStatusPoll(company: @company) do |b|
        b.batch(batchID: batchID)
      end
      out_xml = builder.target!
      result = send_xml(out_xml)
      Hash.from_libxml(result)
    end

    # Check the credit that how many sms can be send
    def get_balance
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct! :xml, version: "1.0"
      builder.getUserBalance(company: @company)

      result = send_xml(builder.target!)

      source = XML::Parser.string(result)
      content = source.parse
      log("Content: #{content}")

      if error = content.find_first('message')
        @errors = error.content.strip
        0
      else
        # TODO: Check for other possible results in here
        return content.find_first('/userBalance').content.strip.to_f
      end
    end


    private

    def log(msg, level = :debug)
      unless @logger.nil?
        @logger.tagged('Rahyab') do
            @logger.send(level, msg)
          end
        end
      end

      # Check does the input contents Farsi Character
      def is_persian(str)
        str =~ /\p{Arabic}/
      end

      # Send XMLmarkup to Web Service
      def send_xml(out_xml)
        uri = URI.parse(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)

        @logger.error "#$%$ #{@user}"
        request.basic_auth @user, @password
        request.body = out_xml

        log("Sending request: #{request.inspect}")
        response = http.request(request)

        log("Response: #{response}")
        return response.body
      end

      # Cost estimates
      def estimate_cost(numbers, text)
        cost = 0
        if is_persian(text)
          sms_length = (text.length / 67.0).ceil
        else
          sms_length = (text.length / 157.0).ceil
        end
        numbers.each do |number|
          if is_persian(text)
            cost = cost + sms_length * 1.5
          else
            cost = cost + sms_length
          end
        end
        cost
      end
  end
end
