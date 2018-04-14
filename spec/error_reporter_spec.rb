require 'spec_helper'

describe ErrorReporter do
  describe '.report' do
    let(:exception) { StandardError.new('Some error') }
    let(:error_message) { "Some error message" }

    context 'first argument is a ruby exception' do
      it 'reports the exception to honeybadger' do
        honeybadger_options = {
          exception: exception,
          tags: %w(severity_normal)
        }
        flexmock(Honeybadger).should_receive(:notify).with(honeybadger_options).once
        ErrorReporter.report(exception)
      end
    end

    context 'first argument is an error message string' do
      it 'reports the error message to honeybadger' do
        honeybadger_options = {
          error_message: error_message,
          error_class: error_message,
          tags: %w(severity_normal)
        }
        flexmock(Honeybadger).should_receive(:notify).with(honeybadger_options).once
        ErrorReporter.report(error_message)
      end
    end

    describe 'context hash' do
      let(:context) {
        {
          ticket_id: 1,
          company_subdomain: 'wildtrails'
        }
      }

      it 'accepts a context hash which has useful details to debug the error' do
        honeybadger_options = {
          exception: exception,
          context: context,
          tags: %w(severity_normal)
        }
        flexmock(Honeybadger).should_receive(:notify).with(honeybadger_options).once
        ErrorReporter.report(exception, context: context)

        honeybadger_options = {
          error_message: error_message,
          error_class: error_message,
          context: context,
          tags: %w(severity_normal)
        }
        flexmock(Honeybadger).should_receive(:notify).with(honeybadger_options).once
        ErrorReporter.report(error_message, context: context)
      end
    end

    describe 'tags' do
      it 'can add tags to an error' do
        tags = %w(billing)

        honeybadger_options = {
          exception: exception,
          tags: %w(billing severity_normal)
        }
        flexmock(Honeybadger).should_receive(:notify).with(honeybadger_options).once
        ErrorReporter.report(exception, tags: tags)
      end

      describe 'valid tags' do
        context 'only some tags are allowed' do
          before(:each) do
            ErrorReporter.valid_tags = %w(email_importing billing sidekiq)
          end

          after(:each) do
            ErrorReporter.valid_tags = nil
          end

          context 'one of the given tags is not allowed' do
            it "raises an error" do
              doing { ErrorReporter.report(exception, tags: %w(smtp sidekiq)) }.should raise_error(ArgumentError)
            end
          end

          context 'all given tags are allowed' do
            it "doesn't raise error" do
              doing { ErrorReporter.report(exception, tags: %w(sidekiq)) }.should_not raise_error
            end
          end
        end

        context "all tags are allowed" do
          before(:each) do
            ErrorReporter.valid_tags.should be_nil
          end

          it "doesn't raise an error" do
            doing { ErrorReporter.report(exception, tags: %w(smtp sidekiq)) }.should_not raise_error
          end
        end
      end
    end

    describe 'error severities' do
      it 'can add a severity level to an error' do
        honeybadger_options = {
          exception: exception,
          tags: %w(severity_critical)
        }
        flexmock(Honeybadger).should_receive(:notify).with(honeybadger_options).once
        ErrorReporter.report(exception, severity: :critical)
      end

      it "can set the severity level of an error as 'low'" do
        honeybadger_options = {
          exception: exception,
          tags: %w(severity_low)
        }
        flexmock(Honeybadger).should_receive(:notify).with(honeybadger_options).once
        ErrorReporter.report(exception, severity: :low)
      end

      context "error severity isn't given" do
        it "sets the severity of the error as 'normal'" do
          honeybadger_options = {
            exception: exception,
            tags: %w(severity_normal)
          }
          flexmock(Honeybadger).should_receive(:notify).with(honeybadger_options).once
          ErrorReporter.report(exception)
        end
      end
    end
  end
end
