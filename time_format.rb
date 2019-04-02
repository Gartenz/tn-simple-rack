class TimeFormatter
  TIME_FORMATS = { year: Time.now.year, month: Time.now.month, day: Time.now.day,
                   hour: Time.now.hour, minute: Time.now.min, second: Time.now.sec }.freeze

  attr_reader :value, :bad_params

  def initialize(params)
    @params = params.split(',')
    @bad_params = []
    @value = ''
  end

  def parse
    @bad_params = @params.map { |p| p unless TIME_FORMATS.key?(p.to_sym) }.compact

    return unless @bad_params.count.zero?

    time = @params.map do |param|
      TIME_FORMATS[param.to_sym]
    end
    @value = time.join('-')
  end

  def parsed?
    !value.empty?
  end

  private

  attr_writer :value, :bad_params
end
