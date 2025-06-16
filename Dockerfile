FROM ruby:3.2

# Install nodejs (required by Rails)
RUN apt-get update -qq && apt-get install -y nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
