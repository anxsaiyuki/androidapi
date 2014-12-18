class ApiController < ActionController::Base
    respond_to :json, :html
    
    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
    
    def cardinfo
        @cards = Card.all.limit(4)
        render json: {data: @cards}, status: 200  
    end
end
