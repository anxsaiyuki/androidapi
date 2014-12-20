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
        
        
        @cards = Card.where(color: params[:color]).to_a if params[:color]
        
        
        p "===================================================="
        p @cards
        p "=================================================="
     
        
        render json: {data: @cards}, status: 200  
    end
end
