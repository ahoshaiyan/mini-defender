# MiniDefender

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-yellowgreen.svg)](http://makeapullrequest.com)
[![Ruby Version](https://img.shields.io/badge/ruby-%3E%3D%202.7.0-red.svg)](https://www.ruby-lang.org/)
[![Gem Version](https://img.shields.io/badge/gem-v0.6.5-lightblue.svg)](https://rubygems.org/gems/mini_defender/versions/0.6.5)

A pragmatic approach to validation in Rails inspired by Laravel's Validator.


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add mini_defender

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install mini_defender


## Usage

Mini Defender allows the developer to quickly and easily validate incoming requests data as the verify first step
in the request, alongside this Mini Defender also provides the following benefits:

- Concise and easy to write validation logic
- Validate complex and nested data structures
- More than 80 validation rules available
- Custom validation rules

The easiest way to use Mini Defender is to include the concern `MiniDefender::ValidatesInput` to your
`ApplicationController` as follows:

```ruby
class ApplicationController < ActionController::Base
  include MiniDefender::ValidatesInput
end
```

Now you will have access to a method called `validate!` which will accept a hash of keys and their respective rules.

```ruby
# frozen_string_literal: true
class BooksController < ActionController::Base
  def create
    Book.create!(book_params)
  end
  
  private
  
  def book_params
    # Optional if you need easy access to rule definitions
    rules = MiniDefender::Rules
    
    validate!({
        'name' => 'string|required|max:255',
        'type' => ['string', rules::In.new(Book::TYPES)],
        'tags' => 'array',
        'tags.*' => 'required|string|max:255',
        'pages' => 'required|integer',
        'author' => 'required|hash',
        'author.name' => 'required|string',
        'author.email' => 'email',
    }, true)
  end
end
```

The `validate!` method accepts two arguments, the first is a hash of keys and rules and the second a boolean to indicate
if you want the values to be coerced to the type indicated by rule, i.e. `integer`.

Suppose we passed the following input to our app:

```json
{
  "name": "The Story of Some Guy",
  "type": "Biography",
  "tags": ["inspiring", "business"],
  "pages": "200",
  "author": {
    "name": "Some Guy himself",
    "random_field": "hello i can haz hakc?"
  }
}
```

Notice that we have passed a string `"200"` to page instead of `200` and added an extra field to `author` called `random_field`.
We didn't also provide an `email` field.

The validation will pass, since `email` is not optional, and we will get the following `Hash` as a result:

```Ruby
{
  'name' => 'The Story of Some Guy',
  'type' => 'Biography',
  'tags' => %w[inspiring business],
  'pages' => 200,
  'author' => {
    'name' => 'Some Guy himself'
  }
}
```

You can see that `pages` has the value converted to `200` (integer), since we chose to coerce by passing `true` to `validate!`.
You can also see that Mini Defender left out the key `random_field` as it was not a part of our validations.


## Rendering Errors

When the validation fails, an error of type `MiniDefender::ValidationError` will be raised.

You can either handle the error using `rescue` or add a global `rescue_from` to handle the errors throughout the application.


## Outside of a Controller

The `validate!` method is actually the following four lines of code:

```ruby
def validate!(rules, coerced = false)
    data = params.to_unsafe_hash.deep_stringify_keys
    validator = MiniDefender::Validator.new(rules, data)
    validator.validate!
    coerced ? validator.coerced : validator.data
end
```

You can use Mini Defender out side of the controller by creating a new instance of `MiniDefender::Validator` and calling
any of the methods on it, see [validator.rb](./lib/mini_defender/validator.rb) for the API.
 

## Rules

Mini Defender tries to implement the same set of rules provided by Laravel, you can explore the available rules in two ways:
- Browse the source code: [lib/mini_defender/rules](./lib/mini_defender/rules)
- View the rules list: [RULES-LIST.md](RULES-LIST.md)


## Add a Custom Rule

To implement your custom rules, you need to create a new class that inherent from `MiniDefender::Rule` and implement
at least the following:

```ruby
class MyAwesomeRule < MiniDefender::Rule
  def self.signature
    'all_caps'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && /^[A-Z]+$/.match?(value)
  end

  def message(attribute, value, validator)
    'ONLY CAPS ALLOWED!!!'
  end
end
```

After creating the class, you can register it as follows:

```ruby
MiniDefender::RulesFactory.register(MyAwesomeRule)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ahoshaiyan/mini_defender.

## License

The gem is available as open source under the terms of the [MIT License](./LICENSE.md).
