class ApiController < ActionController::Base

    def index
        
        @api = "test"
        
        render json: {message: 'android'}
        
    end
end
