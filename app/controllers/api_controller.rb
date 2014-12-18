class ApiController < ActionController::Base

    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
end
