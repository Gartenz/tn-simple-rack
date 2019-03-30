require 'cgi'
require_relative 'time_format'

class App
  DEFAULT_HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
    return responde(404, ['NOT FOUND']) if env['PATH_INFO'] != '/time'

    params = parse_params(env['QUERY_STRING'])
    return responde(400, ["Unknown params #{params.keys}"]) if params.keys.count != 1 || params.keys[0] != 'format'

    format_params = params['format'][0].split(',')

    responde(200, TimeFormatter.time(format_params))
  rescue TimeFormatter::FormatError => e
    responde(400, [e.message])
  end

  private

  def responde(code, body)
    [
      code,
      DEFAULT_HEADERS,
      body
    ]
  end

  def parse_params(params_string)
    CGI.parse(params_string)
  end
end
