# Mapping

The mapping gem is a structured system for mapping one model to another, using an intermediate model which represents the transformation to apply.

[![Build Status](https://travis-ci.org/ioquatix/mapping.svg?branch=master)](https://travis-ci.org/ioquatix/mapping)
[![Code Climate](https://codeclimate.com/github/ioquatix/mapping.svg)](https://codeclimate.com/github/ioquatix/mapping)
[![Coverage Status](https://coveralls.io/repos/ioquatix/mapping/badge.svg)](https://coveralls.io/r/ioquatix/mapping)

## Installation

Add this line to your application's Gemfile:

	gem 'mapping'

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install mapping

## Usage

A mapping model is required for mapping data from one format to another:

```ruby
# Your database model:
module Human
	Person = Struct.new(:name, :age, :posessions)
	Possession = Struct.new(:name, :value)
end

# Your mapping model:
class APIv1 < Mapping::Model
	map(Human::Person) do |object|
		{
			name: object.name,
			age: object.age,
		}
	end
end

class APIv2 < MappingModelV1
	map(Human::Person) do |object|
		super.merge(
			posessions: self.map(object.posessions)
		)
	end
	
	map(Human::Possession) do |object|
		{
			name: object.name,
			value: object.value,
		}
	end
end
```

A simple use case would be something like the following:

```ruby
model = APIv1.new

person = Human::Person.new('Bob Jones', 200, [])
person.posessions << Human::Possession.new('Vase', '$20')

expect(model.map(person)).to be == {
	name: 'Bob Jones',
	age: 200
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Released under the MIT license.

Copyright, 2016, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.