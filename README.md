## Zoksh Ruby SDK

Zoksh is a Ruby gem that provides integration with the Lightning Network for asset transfer and cross-chain payments.

### Features

- Connect to the Lightning Network
- Create and manage orders for asset transfer
- Validate payments
- Webhook integration for receiving payment notifications

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'zoksh', '~> 1.0.0'
```

And then execute:

```shell
$ bundle install
```

Or install it yourself as:

```shell
$ gem install zoksh
```

### Usage
#### Connector
The Connector class allows you to connect to the Lightning Network and sign and send requests.

```ruby
require 'zoksh'

connector = Zoksh::Connector.new('your_zoksh_key', 'your_zoksh_secret', testnet: true)

# Example: Sign and send a request
response = connector.sign_and_send('/v2/order', { amount: 100, token: 'BTC' })
puts response
```

#### Payment
The Payment class provides methods to validate payments.

```ruby

require 'zoksh'

connector = Zoksh::Connector.new('your_zoksh_key', 'your_zoksh_secret', testnet: true)
payment = Zoksh::Payment.new(connector)

# Example: Validate a payment
transaction_hash = 'your_transaction_hash'
response = payment.validate(transaction_hash)
puts response
```

#### Webhook
The Webhook class allows you to handle webhook notifications for payment events.

```ruby
require 'zoksh'

connector = Zoksh::Connector.new('your_zoksh_key', 'your_zoksh_secret', testnet: true)
webhook = Zoksh::Webhook.new(connector, 'your_webhook_url')

# Example: Handle a webhook request
request_headers = { 'zoksh-key': 'your_zoksh_key', 'zoksh-ts': 'your_timestamp', 'zoksh-sign': 'your_signature' }
request_body = { transaction: 'your_transaction_hash' }

webhook.handle(request_headers, request_body)
```

### Running Tests
To run the tests, execute the following command in the root directory of the gem:

```shell
$ rake test
```

This will run the test cases and provide the test results.

### Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/MuLx10/zoksh-ruby.

### License
The gem is available as open source under the terms of the MIT License."

