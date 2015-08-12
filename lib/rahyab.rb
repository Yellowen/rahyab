require "rahyab/version"
require "builder"

module Rahyab
  class SMS

    # Constructor of Rahyab SMS Gateway
    def initialize(url, user, password)
      @url = url
      @user = user
      @password = password
      @company = "Rahyab"
      @batchID = "test"
    end

    # Will send one or more sms to specified numbers
    def send(sender, numbers, text)
      builder = Builder::XmlMarkup.new
      builder.instruct! :xml, version: "1.0", encoding: "UTF-8"
      builder.smsBatch(company: @company, batchID: @batchID)
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
