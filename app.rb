require 'cgi'
require_relative 'time_format'

class App
  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new([], nil, 'Content-Type' => 'text/plain')

    case @request.path_info
    when '/time'
      time_response
    else
      response(404, 'Unknown Path')
    end
    @response.finish
  end

  private

  def time_response
    time_format = TimeFormatter.new(@request.params['format'])
    time_format.parse

    if time_format.parsed?
      response(200, time_format.value)
    else
      response(400, "Unknown time format #{time_format.bad_params}")
    end
  end

  def response(code, body)
    @response.status = code
    @response.write(body)
  end
end
