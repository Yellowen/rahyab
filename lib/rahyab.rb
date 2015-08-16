# coding: utf-8
require "rahyab/version"
require "builder"
require 'net/http'
require 'xml'

module Rahyab
  class SMS

    # Constructor of Rahyab SMS Gateway
    def initialize(url, user, password, company)
      @url = url
      @user = user
      @password = password
      @company = company
    end

    # Will send one or more sms to specified numbers
    def send(sender, numbers, text, **params)
      # Create the send XMLmarkup
      identity         = "#{Time.now.to_i}#{rand(1000000..9999999)}"
      batchID          = @company + identity
      msgClass         = params["flash"] ? "0" : "1"
      dcs              = is_persian(text) ? "8" : "0"
      binary           = is_persian(text) ? "true" : "false"
      builder          = Builder::XmlMarkup.new(:indent=>2)
      builder.instruct! :xml, version: "1.0", encoding: "UTF-8"
      builder.smsBatch(company: @company, batchID: batchID) do |b|
        b.sms(msgClass: msgClass, binary: binary, dcs: dcs) do |t|
          numbers.each do |number|
            t.destAddr() do |f|
              f.declare! "[CDATA[%s]]" % number
            end
          end
          t.originAddr() do |f|
            f.declare! "[CDATA[%s]]" % sender
          end
          t.message() do |f|
            f.declare! "[CDATA[#{text}]]"
          end
        end
      end
      out_xml = builder.target!
      # Send XMLmarkup to Web Service
      uri = URI.parse(@url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth @user, @password
      request.body = out_xml
      response = http.request(request)
      return parse_result(response.body)
    end

    def send_batch(sender, numbers, text)

    end

    # Check delivery status of several sms
    def get_delivery(sender, sms_id)

    end

    # Check delivery status of specified phone numer
    def get_number_delivery(sender, sms_id, number)

    end

    # Check the credit that how many sms can be send
    def get_cache

    end


    private

    # Check does the input contents Farsi Character
    def is_persian(str)
      str =~ /\p{Arabic}/
    end

    # Parse XML and return the message from result
    def parse_result(result)
      source = XML::Parser.string(result)
      content = source.parse
      return content.find_first('message').content
    end
  end
end
