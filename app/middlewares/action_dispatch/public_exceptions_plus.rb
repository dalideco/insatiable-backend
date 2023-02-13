module ActionDispatch
  # Public exception plus
  class PublicExceptionsPlus < PublicExceptions
    def call(env)
      # puts "test"
      request = ActionDispatch::Request.new(env)
      status = request.path_info[1..].to_i
      content_type = request.formats.first
      # define here your custom format
      body = { errors: [{ status:,
                          title: Rack::Utils::HTTP_STATUS_CODES.fetch(status,
                                                                      Rack::Utils::HTTP_STATUS_CODES[500]) }] }

      render(status, content_type, body)
    end
  end
end
