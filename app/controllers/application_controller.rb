class ApplicationController < ActionController::Base
    protect_from_forgery
    rescue_from ::ActionController::ParameterMissing, with: :missing_parameter

    def missing_parameter(exception)
        render status: 400, json: {"error"=> "Bad request", "message" => exception.message}
        return
    end
end
