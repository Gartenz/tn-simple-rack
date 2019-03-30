require 'cgi'

class App
  TIME_FORMATS = %w[year month day hour minute second].freeze
  DEFAULT_HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
    return responde(404, ['NOT FOUND']) if env['PATH_INFO'] != '/time'

    params = parse_params(env['QUERY_STRING'])
    return responde(400, ['Unknown params %w[params.keys]']) if params.keys.count != 1 || params.keys[0] != 'format'

    format_params = params['format'][0].split(',')
    unpermitted_params = format_params.map { |param| param unless TIME_FORMATS.include?(param) }.compact
    return responde(400, ["Unknown time format #{unpermitted_params}"]) if unpermitted_params.count > 0

    responde(200, make_time(format_params))
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

  def make_time(params)
    times = []
    params.each do |param|
      times << case param
        when 'year' then Time.now.year
        when 'month' then Time.now.month
        when 'day' then Time.now.day
        when 'hour' then Time.now.hour
        when 'minute' then Time.now.min
        when 'second' then Time.now.sec
        end
    end
    [times.join('-')]
  end
end
