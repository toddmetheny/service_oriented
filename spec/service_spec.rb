# require File.dirname(__FILE__) + '/../service'
require 'rspec'
# require 'spec/interop/test'
require 'rack/test'

#set :environment, :test
#Test::Unit::TestCase.send :include, Rack::Test::Methods
#book is old
#commented out these things to get tests to run

def app
	Sinatra::Application
end

describe "service" do
	before(:each) do
		User.delete_all
	end

	describe "GET on /api/v1/users/:id" do
		before(:each) do
			User.create(
				:name => "paul",
				:email => "paul@pauldix.net",
				:password => "strongpass",
				:bio => "rubyist")
		end

		it "should return a user by name" do
			get '/api/v1/users/paul'
			last_response.should be_ok
			attributes = JSON.parse(last_response.body)
			attributes["name"].should == "paul"
		end

		it "should return a user with an email" do
			get '/api/v1/users/paul'
			last_response.should be_ok
			attributes = JSON.parse(last_response.body)
			attributes["email"].should == "paul@pauldix.net"
		end

		it "should not return a user's password" do
			get '/api/v1/users/paul'
			last_response.should be_ok
			attributes = JSON.parse(last_response.body)
			attributes.should_not have_key("password")
		end

		it "should return a user with a bio" do
			get '/api/v1/users/paul'
			last_response.should be_ok
			attributes = JSON.parse(last_response.body)
			attributes["bio"].should == "rubyist"
		end

		it "should return a 404 for a user that doesn't exist" do
			get '/api/v1/users/foo'
			last_response.status.should == 404
		end 
 	end
end
