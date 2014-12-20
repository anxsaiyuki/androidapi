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
        
        
        @cards = Card.where(color: "青").to_a
        p "===================================================="
        p @cards
        p "=================================================="
     
        
        render json: {data: @cards}, status: 200  
    end
end
