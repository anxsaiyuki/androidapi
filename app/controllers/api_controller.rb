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
            render json: {message: 'Login Successful'}, status: 200
        else
            render json: {message: 'Login Failed'}, status: 200
        end
        
    end
    
    def editdeck
        cardtotal = DeckList.find_by_user_id_and_card_id_and_deck_name(params[:user_id], params[:card_id], params[:deck_name])
        if cardtotal.nil?
            deck = DeckList.create(user_id: params[:user_id], card_id: params[:card_id], deck_name: params[:deck_name], card_quantity: params[:card_quantity])
            render json: {message: 'update'}, status: 200
        else
            if params[:card_type] != "GENERATION" && cardtotal.card_quantity == 3
                render json: {message: 'Card Quantity Pass Limit'}, status: 200
            else
                newCardQuantity = params[:card_quantity].to_i + cardtotal.card_quantity.to_i
                DeckList.find(cardtotal.id).update_attributes(card_quantity: newCardQuantity)
                render json: {message: 'update'}, status: 200
            end
        end
        
    end
end
