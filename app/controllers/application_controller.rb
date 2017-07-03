class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  around_action :wrap_in_rescue

  private
  def wrap_in_rescue
    begin
      yield
    rescue Exception => e
      log_it(e)
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end

  def log_it(e)
    logger.error(e.message)
    e.backtrace.each do |error|
      logger.error(error)
    end
  end

end
