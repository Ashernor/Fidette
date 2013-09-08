# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Fidette::Application.initialize!

ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => 'app17060796@heroku.com',
    :password       => 'b76gfif1',
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
}
ActionMailer::Base.delivery_method = :smtp
