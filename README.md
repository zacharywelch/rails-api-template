# rails-api-template

A rails [application template](http://guides.rubyonrails.org/rails_application_templates.html) for APIs.

This repository has moved to my [public github account](https://github.com/zacharywelch/rails-api-template).

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
  - [jbuilder](https://github.com/rails/jbuilder)
  - [responders](https://github.com/plataformatec/responders)
  - [faker](https://github.com/stympy/faker)
  - [kaminari](https://github.com/amatsuda/kaminari)
  - [annotate](https://github.com/ctran/annotate_models)
  - [rspec-rails](https://github.com/rspec/rspec-rails)
  - [factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails)

  Several custom gems add behaviors needed by CareerBuilder APIs
  - [json_responder](https://cagit.careerbuilder.com/zwelch/json_responder)
  - [pagination_responder](https://cagit.careerbuilder.com/zwelch/pagination_responder)
  - [rails_api_filters](https://cagit.careerbuilder.com/zwelch/rails_api_filters)
  - [rails_api_sortable](https://cagit.careerbuilder.com/zwelch/rails_api_sortable)

2. Runs `bundle`

3. Runs the following generators
  - `rspec:install`
  - `responders:install`

4. Removes `ActionView` and `Sprockets` from stack

5. Adds json as default format for routes

6. Configures rspec to exclude view, route, and controller specs

7. Hooks up `JsonResponder` and `PaginationResponder` to responder chain

8. Adds template for controller scaffold

9. Creates initial github commit