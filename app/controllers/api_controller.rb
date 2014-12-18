class ApiController < ActionController::Base

    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
    
    def cardinfo
        @cards = Card.find(1)
        render json: {message: '#{@cards}'}, status: 200
    end
end
