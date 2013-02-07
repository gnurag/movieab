# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Webapp::Application.initialize!

ActionMailer::Base.smtp_settings = { 
  :address => 'localhost', 
  :port => '25',
  :enable_starttls_auto => false}
