# Sleepa

Sleepa is a backend service that clocks in your sleep history and share it with your friends.

## Ruby version
3.2.2 — Rails version 8.0.1

## System dependencies
- MySQL 9.1.0
- Redis 7.4.2

## Development Guideline in Local
### Setup Sleepa
1. set your ruby version to 3.2.2 e.g. using ruby version manager like `rbenv local 3.2.2`
2. `bundle install`
3. `cp env.sample .env` and adjust the env as needed

### Database Setup and Initialization
For testing purpose in `development` environment:
1. Setup docker-compose instances using `docker-compose up` (run `docker-compose down -v` to Remove the instances if needed)
2. Enable and disable docker-compose using `docker compose start` or `docker compose stop`
3. Create, migrate, and populate database using `RAILS_ENV=development rails db:create db:migrate db:seed`

### Run Unit Tests
`bundle exec rspec`

### Run Service
`RAILS_ENV=development rails server`

### Testing APIs
See sample curls in [Sample Curls Documentation](docs/sample_curls.md).
