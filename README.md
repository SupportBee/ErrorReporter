
ErrorReporter
=====

Ruby class for reporting errors in our applications

It wraps the the [honeybadger](https://docs.honeybadger.io/ruby/gem-reference/api.html) gem

## Installation

Add ErrorReporter to your application's Gemfile

```
gem "error-reporter", :git => "https://github.com/SupportBee/ErrorReporter"
```

and run

```
bundle install
```

ErrorReporter internally uses the [honeybadger])(https://docs.honeybadger.io/ruby/gem-reference/api.html) gem.

Create a project in our [honeybadger](https://app.honeybadger.io/projects Ping the team in the Dev flow if you haven't yet been invited to our honeybadger

Create the file `config/honeybadger.yml` and configure honeybadger

```
---
api_key: the_honeybadger_project_api_key
report_data: true
# Disable user feedback forms
# http://docs.honeybadger.io/lib/ruby.html#configuration
"feedback.enabled": false
# Don't send auth tokens to honeybadger
"request.filter_keys":
  - auth_token
```

## Usage

See https://github.com/SupportBee/ErrorReporter/blob/master/lib/error_reporter/error_reporter.rb for usage examples