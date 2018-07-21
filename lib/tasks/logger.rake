namespace :logger do
  def logger
    @logger ||= Logger.new(STDOUT)
  end
end
