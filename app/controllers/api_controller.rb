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
        
        @cards = Card.all
        @cards = @cards.where(color: params[:color]) if params[:color]
        @cards = @cards.where(card_type: params[:card_type]) if params[:card_type]
        @cards = @cards.where(g_sign: params[:g_sign]) if params[:g_sign]
        @cards = @cards.where(total_cost: params[:total_cost]) if params[:total_cost]
        @cards = @cards.where(roll_cost: params[:roll_cost]) if params[:roll_cost]
        
        
        
        render json: {data: @cards.to_a}, status: 200  
    end
end
