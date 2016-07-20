## Installation

Follow these steps to get started in development.

Clone the repository

    $ git clone git@cagit.careerbuilder.com:CorpAppsCB/my_app_name.git

Switch to the project's directory

    $ cd my_app_name

Then bundle

    $ bundle

Copy database.yml.sample as database.yml

    $ cp config/database.yml.sample config/database.yml

Copy secrets.yml.sample as secrets.yml

    $ cp config/secrets.yml.sample config/secrets.yml

Make sure all config files mentioned above are filled with the proper configuration data

Create the database

    $ rake db:create

Run the migrations

    $ rake db:migrate

Seed the authentication data

    $ rake db:authentication

Run the seeds

    $ rake db:seed

Run tests

    $ rspec spec

## Testing in Postman

While testing in Postman you'll need to pass in an authorization header or you'll receive 401 Unauthorized. This is because `my_app_name` uses [partner authentication](https://cagit.careerbuilder.com/zwelch/partner_authentication).  If you've run the seeds a partner `foo:bar` was created for you already.

```http
GET http://localhost:3000
Authorization: Partner foo:bar
```
