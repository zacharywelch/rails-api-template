# rails-api-template

A rails [application template](http://guides.rubyonrails.org/rails_application_templates.html) for APIs.

To see a sample of using Rails as an API check out [rails-api](https://cagit.careerbuilder.com/zwelch/rails-api) sample.

## Installation

Before generating your API, you will need [rails-api](https://github.com/rails-api/rails-api) gem installed

```ruby
gem install 'rails-api'
```

## Usage

```ruby
rails-api new [api_name] --skip-test-unit -m https://raw.githubusercontent.com/zacharywelch/rails-api-template/master/template.rb
```

## What it does

1. Adds the following gems
  - [rails-api](https://github.com/rails-api/rails-api)
  - [rails](https://github.com/rails/rails)
  - [jbuilder](https://github.com/rails/jbuilder)
  - [responders](https://github.com/plataformatec/responders)
  - [faker](https://github.com/stympy/faker)
  - [kaminari](https://github.com/amatsuda/kaminari)
  - [spring](https://github.com/rails/spring)
  - [sqlite3](https://github.com/sparklemotion/sqlite3-ruby)
  - [activerecord-sqlserver-adapter](https://github.com/rails-sqlserver/activerecord-sqlserver-adapter)
  - [tiny_tds](https://github.com/rails-sqlserver/tiny_tds)
  - [annotate](https://github.com/ctran/annotate_models)
  - [rspec-rails](https://github.com/rspec/rspec-rails)
  - [factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails)
  - [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
  - [simplecov](https://github.com/colszowka/simplecov)
  - [codeclimate-test-reporter](https://github.com/codeclimate/ruby-test-reporter)
  - [newrelic_rpm](https://github.com/newrelic/rpm)
  - [exception_notification](https://github.com/smartinez87/exception_notification)
  - [byebug](https://github.com/deivid-rodriguez/byebug)
  - [okcomputer](https://github.com/sportngin/okcomputer)
  - [lograge](https://github.com/roidrage/lograge)
  - [fluentd](https://github.com/fluent/fluentd)
  - [fluent-plugin-record-modifier](https://github.com/repeatedly/fluent-plugin-record-modifier)

  Several custom gems add behaviors needed by CareerBuilder APIs
  - [json_responder](https://cagit.careerbuilder.com/zwelch/json_responder)
  - [paginate-responder](https://cagit.careerbuilder.com/zwelch/paginate-responder)
  - [rails_api_sortable](https://cagit.careerbuilder.com/zwelch/rails_api_sortable)
  - [partner_authentication](https://cagit.careerbuilder.com/zwelch/partner_authentication)

2. Runs `bundle`

3. Runs the following generators
  - `rspec:install`
  - `responders:install`
  - `partner_authentication:install`

4. Adds a sample [Partner ID](https://cagit.careerbuilder.com/zwelch/partner_authentication) for development

5. Removes `ActionView` and `Sprockets` from stack

6. Adds json as default format for routes

7. Configures rspec to exclude view, route, and controller specs

8. Hooks up `JsonResponder` and `PaginateResponder` to responder chain

9. Adds template for controller scaffold

10. Configures New Relic

11. Configures Code Climate

12. Configures lograge and fluentd, to be consummed from Sumo Logic

13. Creates sample config files and git ignores the original ones
  - config/database.yml
  - config/secrets.yml

14. Replaces README with markdown

15. Customizes .gitignore file

16. Creates initial github commit

## Additional steps

### Code Climate
Replace the badge placeholders in `README.md` with the markdown snippets from Code Climate.

### TeamCity
Replace the badge placeholders in `README.md` with the markdown snippets from TeamCity.
