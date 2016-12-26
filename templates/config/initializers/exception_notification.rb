unless Rails.env.test? || Rails.env.development?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    ignore_exceptions: ['ActionController::ParameterMissing'] + ExceptionNotifier.ignored_exceptions,
    email: {
      email_prefix: "[my_app_name #{Rails.env.upcase}] ",
      sender_address: %{"CB Notifier" <notifier.cb@gmail.com>},
      exception_recipients: %w{notifications.cb@paragon-labs.com}
    }

end
