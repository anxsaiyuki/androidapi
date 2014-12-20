#encoding: utf-8
class ApiController < ActionController::Base
    respond_to :json, :html
    
    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
    
    def cardinfo
        p "===================================================="
        p params
        p "=================================================="
        
        @cards = Card.find_all_by_card_type("UNIT")
     
        
        render json: {data: @cards}, status: 200  
    end
end
