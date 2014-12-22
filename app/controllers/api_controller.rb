#encoding: utf-8
class ApiController < ActionController::Base
    respond_to :json, :html
    
    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
    
    def cardinfo        
        @cards = Card.all
        @cards = @cards.where(color: params[:color]) if params[:color]
        @cards = @cards.where(card_type: params[:card_type]) if params[:card_type]
        @cards = @cards.where(g_sign: params[:g_sign]) if params[:g_sign]
        @cards = @cards.where(total_cost: params[:total_cost]) if params[:total_cost]
        @cards = @cards.where(roll_cost: params[:roll_cost]) if params[:roll_cost]
        
        render json: {data: @cards.to_a}, status: 200  
    end
    
    def login
        user = User.find_by_user_name_and_password(params[:user_name],params[:password])
        if user.nil?
            render json: {message: 'failed'}, status: 200
        else 
            render json: {message: 'success'}, status: 200
        end
        
    end
    
    def register
        p "===================================="
        p params
        p "===================================="
        
        user = User.find_by_user_name(params[:user_name])
        
        if user.nil?
            User.create(user_name: params[:user_name], password: params[:password])
            render json: {message: 'success'}, status: 200
        else
            render json: {message: 'fail'}, status: 200
        end
        
        
    end
end
