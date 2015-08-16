# coding: utf-8
require_relative '../lib/rahyab'

describe Rahyab::SMS do
  before :all do
    @url = "http://193.104.22.14:2055/CPSMSService/Access"
    @user = ENV['RAHYAB_USER']
    @password = ENV['RAHYAB_PASS']
    @company = ENV['RAHYAB_COMPANY']
    @sender = ENV['RAHYAB_SENDER']
    @numbers = ['+989125601735']
    @sms = Rahyab::SMS.new(@url, @user, @password, @company)
    @text = "Hello World"
  end

  it "Sends sms and returns id" do
    x = @sms.send(@sender, @numbers, @text)

  end

  it "Sends batch sms and returns ids" do
    @sms.send_batch(sender, numbers, text)
  end

  it "Checks sms derivered" do
    @sms.get_delivery(sender, sms_id)
  end

  it "Checks sms delivery by number" do
    @sms.get_number_delivery(sender, sms_id, number)
  end

  it "Checks user credit" do
    @sms.get_balance
  end

end
