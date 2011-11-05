class Notifier < ActionMailer::Base
  ActionMailer::Base.default_url_options[:host] = "ilustratorzy.pl"
  
  def activation_instructions(user)
    subject       "Aktywacji Konta na Ilustratorzy.pl"
    from          "Ilustratorzy.pl"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Aktywacja Konta na Ilustratorzy.pl Pomyslnie zakonczona"
    from          "Ilustratorzy.pl"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end
end
