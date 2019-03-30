class TimeFormatter
  class FormatError < StandardError
  end

  TIME_FORMATS = %w[year month day hour minute second].freeze

  def self.time(params)
    unpermitted_params = params.map { |param| param unless TIME_FORMATS.include?(param) }.compact
    raise FormatError, "Unknown time format #{unpermitted_params}" if unpermitted_params.count > 0

    times = params.map do |param|
      case param
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
