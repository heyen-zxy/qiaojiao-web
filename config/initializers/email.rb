ActionMailer::Base.smtp_settings = {
    :authentication => :login,
    :address => "smtp.263.net",
    :port => 465,
    :domain => "net263.com",
    :user_name => "order_remind@net263.com",
    :password => Settings.smtp_password,
    :tls => true,
    :ssl => true,
    :enable_starttls_auto => true
}