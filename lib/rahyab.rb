# coding: utf-8
require "rahyab/version"
require "builder"

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
      identity = "#{Time.now.to_i}#{rand(1000000..9999999)}"
      batchID = @company + identity
      msgClass = params["flash"] ? "0" : "1"
      dcs = text =~ /\p{Arabic}/ ? "8" : "0"
      builder = Builder::XmlMarkup.new(:indent=>2)
      builder.instruct! :xml, version: "1.0", encoding: "UTF-8"
      builder.smsBatch(company: @company, batchID: batchID) do |b|
        b.sms(msgClass: msgClass, binary: "True", dcs: dcs) do |t|
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


    def recieve()
    end


  end
end
