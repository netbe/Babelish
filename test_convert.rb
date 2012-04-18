# == Synopsis
# tesing script
begin
	require "test/unit"	
rescue Exception => e
	puts "gem install test-unit"
	exit
end
$: << File.expand_path(File.join(File.dirname(__FILE__)))

require 'convert'
# require File.expand_path('convert',File.dirname(__FILE__))

class TestConvert < Test::Unit::TestCase

	def test_usage
		begin
			usage
		rescue SystemExit => e
			assert e.status == 0
		end
	end

end