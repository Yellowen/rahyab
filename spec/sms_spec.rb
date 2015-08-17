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
    @batchID = ENV['RAHYAB_BATCH_ID']
  end

  it "Sends sms and returns id" do
    sms = @sms.send_sms(@sender, @numbers, @text)
    expect(sms.class).to be(nil)
  end

  it "Sends batch sms and returns ids" do
    sms = @sms.send_batch(@sender, @numbers, @text)
  end

  it "Checks sms derivered" do
    @sms.get_delivery(@batchID)
  end

  it "Checks sms delivery by number" do
    @sms.get_number_delivery(sender, sms_id, number)
  end

  it "Checks user credit" do
    balance = @sms.get_balance
  end

end
