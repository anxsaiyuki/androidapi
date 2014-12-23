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
            render json: {message: 'Login Failed'}, status: 200
        else 
            render json: {message: 'Login Successful', user_id: user.id}, status: 200
        end
        
    end
    
    def register
        p "===================================="
        p params
        p "===================================="
        
        user = User.find_by_user_name(params[:user_name])
        
        if user.nil?
            user = User.create(user_name: params[:user_name], password: params[:password])
            render json: {message: 'Login Successful'}, status: 200
        else
            render json: {message: 'Login Failed'}, status: 200
        end
        
    end
    
    def editdeck
        p "===================================="
        p params
        p "===================================="
        if params[:user_id].nil? || params[:card_id].nil? || params[:deck_name].nil? || params[:card_quantity].nil? || params[:card_type].nil? || params[:deck_action].nil? || params[:user_id].blank? || params[:card_id].blank? || params[:deck_name].blank? || params[:card_quantity].blank? || params[:card_type].blank? || params[:deck_action].blank?
            render json: {message: 'error'}, status: 200
        else
            decktotal = DeckList.where(deck_name: params[:deck_name])
            totalquantity = 0
            decktotal.each do |quantity|
                totalquantity = totalquantity + quantity.card_quantity
            end
            if totalquantity < 50
                cardtotal = DeckList.find_by_user_id_and_card_id_and_deck_name(params[:user_id], params[:card_id], params[:deck_name])
                if cardtotal.nil? && params[:deck_action] == "add"
                    deck = DeckList.create(user_id: params[:user_id], card_id: params[:card_id], deck_name: params[:deck_name], card_quantity: params[:card_quantity])
                    render json: {message: 'update'}, status: 200
                else
                    if params[:deck_action] == "add"
                        if params[:card_type] != "GRAPHIC" && cardtotal.card_quantity >= 3
                            render json: {message: 'Card Quantity Pass Limit'}, status: 200
                        else
                            newCardQuantity = params[:card_quantity].to_i + cardtotal.card_quantity.to_i
                            DeckList.find(cardtotal.id).update_attributes(card_quantity: newCardQuantity)
                            render json: {message: 'update add'}, status: 200
                        end
                    elsif params[:deck_action] == "subtract"
                        if cardtotal.card_quantity == 0
                            render json: {message: 'Card Quantity Pass Cannot go Under 0'}, status: 200
                        else
                            newCardQuantity = cardtotal.card_quantity.to_i - params[:card_quantity].to_i
                            DeckList.find(cardtotal.id).update_attributes(card_quantity: newCardQuantity)
                            render json: {message: 'update subtract'}, status: 200
                        end
                    end
                end
            else
                render json: {message: 'You have passed Deck Limit'}, status: 200
            end
        end    
    end
    
    def getdeck
        @deckName = DeckName.select("deck_name, user_id")
        @deckName = @deckName.where(user_id: params[:user_id])

        render json: {data: @deckName.to_a}, status: 200
        
    end
    
    def createdeck
        checkDeck = DeckName.find_by_user_id_and_Deck_Name(params[:user_id], params[:deck_name])
        if checkDeck.nil?
            DeckName.create(user_id: params[:user_id], Deck_Name: params[:deck_name])
            render json: {message: 'You have created a Deck'}, status: 200
        else
            render json: {message: 'Deck Already Exists'}, status: 200
        end
    end
end
