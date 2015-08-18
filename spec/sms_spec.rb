# coding: utf-8
require_relative '../lib/rahyab'

describe Rahyab::SMS do
  before :all do
    @url = "http://193.104.22.14:2055/CPSMSService/Access"
    @user = ENV['RAHYAB_USER']
    @password = ENV['RAHYAB_PASS']
    @company = ENV['RAHYAB_COMPANY']
    @sender = ENV['RAHYAB_SENDER']
    @numbers = ['+989358180918']
    @sms = Rahyab::SMS.new(@url, @user, @password, @company)
    @text = "بفرمائید میل کنید"
    @batchID = ENV['RAHYAB_BATCH_ID']
  end

  it "Sends sms and returns id" do
    sms = @sms.send_sms(@sender, @numbers, @text)
    expect(sms.class).to be(String)
  end

  it "Sends batch sms and returns ids" do
    sms = @sms.send_batch(@sender, @numbers, @text)
  end

  it "Checks sms derivered" do
    delivery = @sms.get_delivery(@batchID)
    expect(delivery.class).to be(Hash)
  end

  it "Checks user credit" do
    balance = @sms.get_balance
    expect(balance.class).to be(Float)
  end

  it "Estimate cost of sms" do
    cost = @sms.send(:estimate_cost, @numbers, @text)
    expect(cost.class).to be(Fixnum)
  end

end
