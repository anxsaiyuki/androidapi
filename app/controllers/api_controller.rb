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
        
        @cards = Card.
        @cards = @cards.where('card_type', params[:card_type].force_encoding(Encoding::UTF_8)) if params[:card_type]
        @cards = @cards.where('color', params[:color].force_encoding(Encoding::UTF_8)) if params[:color]
        @cards = @cards.where('color', "紫");
        
        render json: {data: @cards}, status: 200  
    end
end
