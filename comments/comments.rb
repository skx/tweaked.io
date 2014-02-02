#!/usr/bin/ruby
#
# This is a sinatra application for receiving comments.
#

require 'sinatra'
require 'redis'
require 'json'


class CommentStore < Sinatra::Base

  #
  # Listen on 127.0.0.1:9393
  #
  set :bind, "127.0.0.1"
  set :port, 9393

  #
  # Posting a hash of author + body, with a given ID will
  # appends a simplified version of the comment to a redis set.
  #
  post '/comments/' do
    author = params[:author]
    body   = params[:body]
    id     = params[:id]

    if ( author && body && id )

      #
      #  Trivial stringification.
      #
      content = "#{Time.now}|#{author}|#{body}"

      #
      #  Add to the set.
      #
      @redis = Redis.new( :host => "127.0.0.1" );
      @redis.sadd( "comments-#{id}",content )

      #
      #  All done
      #
      status 204
    end

    status 500, "Missing data"
  end

  #
  #  Get the comments associated with a given ID, sorted
  # by the date - oldest first.
  #
  get '/comments/:id' do
    id = params[:id]

    result = Array.new()

    #
    #  Get the members of the set.
    #
    @redis = Redis.new( :host => "127.0.0.1" );
    values = @redis.smembers( "comments-#{id}" )


    i = 1

    #
    # For each comment add to our array a hash of the comment-data.
    #
    values.each do |str|

      # tokenize.
      time,author,body = str.split("|")

      # Add the values to our array of hashes
      result << { :time => time,
        :author => CGI.escapeHTML(author),
        :body => CGI.escapeHTML(body) }

      i += 1
    end

    # sort to show most recent last.
    json = result.sort_by {|vn| vn[:time]}.to_json()

    # now return a JSONP-friendly result.
    "comments(#{json})";
  end
end


if __FILE__ == $0
  CommentStore.run!
end
