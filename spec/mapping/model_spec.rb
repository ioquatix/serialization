# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'mapping/model'

module Mapping::ModelSpec
	module Human
		Person = Struct.new(:name, :age, :posessions)
		Possession = Struct.new(:name, :value)
	end
	
	class MappingModelV1 < Mapping::Model
		map(Human::Person) do |object|
			{
				name: object.name,
				age: object.age,
			}
		end
	end
	
	class MappingModelV2 < MappingModelV1
		map(Human::Person) do |object|
			super(object).merge(
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

	RSpec.describe Mapping::Model do
		it 'can map with base class' do
			model = MappingModelV1.new
			
			person = Human::Person.new('Bob Jones', 200, [])
			person.posessions << Human::Possession.new('Vase', '$20')
			
			expect(model.map(person)).to be == {
				name: 'Bob Jones',
				age: 200
			}
		end
		
		it 'can map with derived class' do
			model = MappingModelV2.new
			
			person = Human::Person.new('Bob Jones', 200, [])
			person.posessions << Human::Possession.new('Vase', '$20')
			
			expect(model.map(person)).to be == {
				name: 'Bob Jones',
				age: 200, 
				posessions: [
					{name: 'Vase', value: '$20'}
				]
			}
		end
	end
end
