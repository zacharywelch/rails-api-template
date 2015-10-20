unless Rails.env.test? || Rails.env.development?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: "[my_app_name #{Rails.env.upcase}] ",
      sender_address: %{"CB Notifier" <notifier.cb@gmail.com>},
      exception_recipients: %w{notifications.cb@paragon-labs.com}
    }

end
