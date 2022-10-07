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
	class DateMapping < Mapping::Model
		map(Time) do |date, offset = nil|
			if offset
				date.localtime(offset)
			else
				date
			end
		end
	end

	RSpec.describe DateMapping do
		let(:time) {Time.now}
		
		it 'can map without timezone option' do
			expect(subject.map(time)).to be == time
		end
		
		it 'can map with timezone option' do
			expect(subject.map(time, offset = 0)).to be == time.gmtime
		end
	end
	
	class LowerCaseMapping < Mapping::Model
		map(String) {|string| string.downcase}
		map(Float) {|float| float.to_s}
	end
	
	RSpec.describe LowerCaseMapping do
		it 'can map string' do
			expect(subject.map("FOO")).to be == "foo"
		end
	end
	
	class EmptyMapping < LowerCaseMapping
		unmap(String)
	end
	
	RSpec.describe EmptyMapping do
		it 'can remove a mapped method' do
			expect{subject.map("foo")}.to raise_error(NoMethodError)
		end
		
		it 'can still call super' do
			expect(subject.map(10.0)).to be == "10.0"
		end
	end
end
