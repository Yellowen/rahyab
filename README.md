# Rahyab

Rahyab gem is Ruby implimentation of Rahyab SMS Service Gateway.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rahyab'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rahyab

## Usage

### Initialize 
```
@sms = Rahyab::SMS.new(@url, @user, @password, @company)
```

### Send SMS

```
sms = @sms.send_sms(@sender, @numbers, @text)
```

### Get Delivery
```
delivery = @sms.get_delivery(@batchID)
```

### Check balance
```
 balance = @sms.get_balance
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Yellowen/rahyab.
