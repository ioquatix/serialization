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

module Mapping
	class Model
		PREFIX = 'map_'.freeze
		
		# This function generates mapping names like `map_Array` and `map_Hash` which while a bit non-standard are perfectly fine for our purposes and this never really needs to leak.
		def self.method_for_mapping(klass)
			PREFIX + klass.name.gsub(/::/, '_')
		end
		
		# Get the name of the method for mapping the given object.
		def method_for_mapping(object)
			self.class.method_for_mapping(object.class)
		end
		
		# Add a mapping from a given input class to a specific block.
		def self.map(*klasses, &block)
			klasses.each do |klass|
				method_name = self.method_for_mapping(klass)
				define_method(method_name, &block)
			end
		end
		
		# Sometimes you just want to map things to themselves (the identity function). This makes it convenient to specify a lot of identity mappings.
		def self.map_identity(*klasses)
			self.map(*klasses) {|value| value}
		end
		
		# Remove a mapping, usually an inherited one, which you don't want.
		def self.unmap(*klasses)
			klasses.each do |klass|
				method_name = self.method_for_mapping(klass)
				undef_method(method_name)
			end
		end
		
		# The primary function, which maps an input object to an output object.
		def map(root, *args)
			method_name = self.method_for_mapping(root)
			
			self.send(method_name, root, *args)
		end
	end
end
