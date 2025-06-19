# Applications API

This repository contains the `Applications API`, a Ruby on Rails application designed to manage and serve job's applications data.

## Prerequisites

Before setting up the project, ensure you have the following installed:

- **Ruby**: Version specified in the `.ruby-version` file.
- **Bundler**: Install using `gem install bundler`.

## Instructions

Follow these steps to set up the project:
1. Setup
 - Clone the Repository
 - Install Dependencies `bundle install`
 - Setup the Database: Create and migrate the database:
    ```bash
    rails db:create
    rails db:migrate
    ```
 - Seed the Database:
    ```bash
    rails db:seed
    ```
 - start the Server: Run the Rails server:
    ```bash
    rails server
    ```
   
2. Running Tests: To run the test suite, use:
    ```bash
    bundle exec rspec
    ```
3.Execute requests: You can use tools like Postman or curl to interact with the API endpoints.
 - Example request to get all applications:
    ```bash
    curl -X GET http://localhost:{port}/api/v1/applications
    ```
 - Example request to get all jobs:
    ```bash
    curl -X GET http://localhost:{port}/api/v1/jobs
    ```
