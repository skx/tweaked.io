#!/usr/bin/ruby
#
# This is a sinatra application for receiving comments.
#

require 'sinatra'
require 'redis'
require 'json'


class CommentStore < Sinatra::Base

  set :bind, "127.0.0.1"
  set :port, 9393

  #
  # Posting a hash of:
  #
  #   author
  #   body
  #
  # On a page with an "id".
  #
  post '/comments/' do
    author = params[:author]
    body   = params[:body]
    id     = params[:id]

    if ( author && body && id )

      content = "#{Time.now}|#{author}|#{body}"

      @redis = Redis.new( :host => "127.0.0.1" );
      @redis.sadd( "comments-#{id}",content )

      status 204
    end

  end

  #
  #  Get all values
  #
  get '/comments/:id' do
    id = params[:id]
    @redis = Redis.new( :host => "127.0.0.1" );

    result = Array.new()
    values = @redis.smembers( "comments-#{id}" )

    i = 1

    values.each do |str|

      # tokenize.
      time,author,body = str.split("|")

      # store the values
      result << { :time => time,
        :author => CGI.escapeHTML(author),
        :body => CGI.escapeHTML(body) }

      i += 1
    end

    # sort to show most recent last.
    json = result.sort_by {|vn| vn[:time]}.to_json()
    "comments(#{json})";
  end
end


if __FILE__ == $0
  CommentStore.run!
end
