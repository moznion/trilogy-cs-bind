# Trilogy::Cs::Bind [![Test](https://github.com/moznion/trilogy-cs-bind/actions/workflows/test.yml/badge.svg)](https://github.com/moznion/trilogy-cs-bind/actions/workflows/test.yml) [![Gem Version](https://badge.fury.io/rb/trilogy-cs-bind.svg)](https://badge.fury.io/rb/trilogy-cs-bind)

An expansion library for [Trilogy](https://github.com/trilogy-libraries/trilogy) to support client-side binding.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add trilogy-cs-bind
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install trilogy-cs-bind
```

## Usage

This library extends two instance methods `#xquery` and `#pseudo_bind` to the Trilogy class on library loaded.

### Synopsis

```ruby
require "trilogy"
require "trilogy-cs-bind"

client = Trilogy.new(host: "127.0.0.1", port: 3306, username: "root", read_timeout: 2)
client.xquery("select ? AS ret", "abc'def\"ghi\0jkl%mno").each_hash.to_a # => [{"ret" => "abc'def\"ghi\0jkl%mno"}]
```

### `xquery: (String sql, *untyped values, ?flags: Integer | nil) -> Trilogy::Result`

This method executes the query with client-side binding.

The placeholder character for binding in the query is `?`, and this library binds each value (provided through the `values` parameter) into its corresponding placeholder with MySQL escaping.

### `pseudo_bind: (String sql, Array[untyped] values) -> String`

This method binds the values into the given SQL query with MySQL escaping by replacing the placeholders.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moznion/trilogy-cs-bind. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/moznion/trilogy-cs-bind/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

The reference implementation of this library is [mysql2-cs-bind](https://rubygems.org/gems/mysql2-cs-bind).

## Code of Conduct

Everyone interacting in the Trilogy::Cs::Bind project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/moznion/trilogy-cs-bind/blob/main/CODE_OF_CONDUCT.md).

