class ErrorReporter
  class << self
    # A list of valid tag values
    #
    # Valid tags are configured in the initializer +config/initializers/error_reporter.rb+.
    # Valid tags are kept to a minimum. Discuss with the team on flowdock or github
    # to add a new tag.
    #
    # @example
    #   SupportBee::Utils::ErrorReporter.valid_tags = %w(mail_importing billing)
    attr_accessor :valid_tags
  end

  # Send an error to Honeybadger, our error tracking tool
  #
  # @param exception_or_error_message [Exception String] Can either be a ruby exception or an error message string
  # @option options :context [Hash] A hash with useful debugging data
  # @option options :tags [Array] An array of tags to classify the error. Valid
  #   tags are listed in +config/initializers/error_reporter.rb+. If an invalid
  #   tag is passed, an invalid tag error is raised.
  #
  #   Tags are useful for searching errors and configuring alert notifications
  #   in honeybadger. Valid tags are kept to a minimum. Discuss
  #   with the team on flowdock or github to add a new tag.
  # @option options :severity [Symbol] (:normal) The severity of the error.
  #   Valid values are +:critical+, +:normal+ and +:low+. If an error is
  #   +:critical+, an alert notification is sent to flowdock.
  #
  #   Severity is useful for searching errors and configuring alert notifications
  #   in honeybadger.
  # @raise [ArgumentError] if an invalid tag is given
  #
  # @example Report a ruby exception
  #   begin
  #     send_push_notification(push_notification)
  #   rescue HTTPError => e
  #     ErrorReporter.report(e)
  #   end
  #
  # @example Report an error message string
  #   begin
  #     sanitize_html(html)
  #   rescue
  #     ErrorReporter.report('Failed to sanitize html')
  #   end
  #
  # @example Pass a context hash with useful debugging data
  #   begin
  #     execute_filters(ticket)
  #   rescue => e
  #     context = {
  #       ticket_id: ticket.id,
  #       company_subdomain: ticket.company.subdomain
  #     }
  #     ErrorReporter.report(e, context: context)
  #   end
  #
  # @example Classify error with tags
  #   begin
  #     import_email(email)
  #   rescue => e
  #     context = { message_id: email.message_id }
  #     tags = %w(mail_importing)
  #     ErrorReporter.report(e, context: context, tags: tags)
  #   end
  #
  # @example Mark error as critical
  #   begin
  #     cancel_company_subscription(company)
  #   rescue
  #     options = {
  #       context: {
  #         company_subdomain: company_subdomain,
  #       },
  #       tags: %w(billing),
  #       severity: :critical
  #     }
  #     ErrorReporter.report('Failed to cancel company subscription', options)
  #   end
  def self.report(exception_or_error_message, options = {})
    new.report(exception_or_error_message, options)
  end

  def report(exception_or_error_message, options = {})
    honeybadger_options = build_honeybadger_options(exception_or_error_message, options)

    Honeybadger.notify(honeybadger_options)
  end

  private

  def build_honeybadger_options(exception_or_error_message, options)
    honeybadger_options = if exception?(exception_or_error_message)
      exception = exception_or_error_message
      { exception: exception }
    else
      error_message = exception_or_error_message
      {
        error_message: error_message,
        error_class: error_message # Honeybadger uses error_class to group similar errors
      }
    end
    honeybadger_options[:tags] = fetch_tags(options)
    honeybadger_options[:context] = options[:context] if options[:context]

    honeybadger_options
  end

  def exception?(exception_or_error_message)
    exception_or_error_message.is_a?(Exception)
  end

  def fetch_tags(options)
    SupportBee::TagList.new(options[:tags], severity: options[:severity]).to_a
  end
end
