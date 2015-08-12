require_relative '../lib/rahyab'

describe Rahyab::SMS do
  before :all do
    @sms = Rahyab::SMS.new
  end

  it "Sends sms and returns id" do
    @sms.send(sender, numbers, text)
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
    @sms.get_cache(sender, sms_id, number)
  end

end
