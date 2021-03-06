#encoding: utf-8
class ApiController < ActionController::Base
    respond_to :json, :html
    
    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
    
    def cardinfo        
        if params[:card_action] == "info"
            
            @apiCount = Card.count(:id)
            if @apiCount.to_i == params[:counter].to_i
                p "============================"
                p "good"
                render json: {data: 'none', total_count: '0'}, status: 200 
            else
                
                @cards = Card.where("id > ?", params[:counter])
                @cards = @cards.where(card_color: params[:card_color]) if params[:card_color]
                @cards = @cards.where(card_type: params[:card_type]) if params[:card_type]
                @cards = @cards.where(g_sign: params[:g_sign]) if params[:g_sign]
                @cards = @cards.where(total_cost: params[:total_cost]) if params[:total_cost]
                @cards = @cards.where(roll_cost: params[:roll_cost]) if params[:roll_cost]
                @cards = @cards.where(pack_name: params[:pack_name]) if params[:pack_name]
                
                @total_count = @apiCount.to_i - params[:counter].to_i
                render json: {data: @cards, total_count: @total_count }, status: 200 
            end
            
        elsif params[:card_action] == "list"
            @color = Card.select(:card_color).uniq
            @type = Card.select(:card_type).uniq
            @g_sign = Card.select(:g_sign).uniq
            @total_cost = Card.select(:total_cost).uniq
            @roll_cost = Card.select(:roll_cost).uniq
            @pack_name = Card.select(:pack_name).uniq
            
            render json: {card_color: @color, card_type: @type, g_sign: @g_sign, total_cost: @total_cost, roll_cost: @roll_cost, pack_name: @pack_name, rarity: @rarity}, status: 200
        elsif params[:card_action] == "pack_list"
            @apiCount = PackName.count(:id)
            if @apiCount.to_i == params[:counter].to_i
                p "============================"
                p "good"
                render json: {data: 'none', total_count: '0'}, status: 200 
            else
                @pack_name = PackName.where("id > ?", params[:counter])
                @total_count = @apiCount.to_i - params[:counter].to_i
                render json: {data: @pack_name, total_count: @total_count}, status: 200
            end
        end
    end
    
    def user
        if params[:user_action] == "login"
            user = User.find_by_user_name_and_user_password(params[:user_name],params[:password])
            if user.nil?
                render json: {message: '0'}, status: 200
            else 
                render json: {message: '1', user_id: user.id}, status: 200
            end
        
        elsif params[:user_action] == "register"
            user = User.find_by_user_name(params[:user_name])

            if user.nil?
                user = User.create(user_name: params[:user_name], user_password: params[:password])
                render json: {message: '1'}, status: 200
            else
                render json: {message: '0'}, status: 200
            end
            
        elsif params[:user_action] == "shared"
            
            @user_share = ShareDeck.select("users.id, users.user_name").joins("LEFT JOIN deck_names ON deck_names.id = share_decks.deck_name_id").joins("LEFT JOIN users ON users.id = share_decks.share_user_id").where(:deck_names => {:user_id => params[:user_id]}).where(:share_decks => {:deck_name_id => params[:deck_id]})
            render json: {data: @user_share.to_a}, status: 200
            
        elsif params[:user_action] == "share_list"
            
            @user_share_list = FriendList.select("users.id, users.user_name").joins("LEFT JOIN users ON users.id = friend_lists.friend_id").joins("LEFT JOIN share_decks ON share_decks.share_user_id = friend_lists.friend_id and share_decks.deck_name_id = " + params[:deck_id]).where(user_id: params[:user_id], status: 2).where("share_decks.id is NULL")
            
            render json: {data: @user_share_list.to_a}, status: 200

        else
            render json: {message: 'select user action'}, status: 200
        end
        
    end
    
    def friend
            if params[:friend_action] == "friend_list"
                @friend = FriendList.select("users.id, users.user_name").joins("LEFT JOIN users ON users.id = friend_lists.friend_id").where(user_id: params[:user_id], :friend_lists => {status: 2})
                render json: {data: @friend}, status: 200
            elsif params[:friend_action] == "request_list"
                
                @friend = User.select("users.id, users.user_name, friend_lists.friend_id").joins("LEFT JOIN friend_lists ON (friend_lists.user_id = users.id or friend_lists.friend_id = users.id)").where.not(:users => {id: params[:user_id]}).where("(friend_lists.friend_id != " + params[:user_id] + " AND friend_lists.user_id != " + params[:user_id] + ") OR friend_lists.user_id is null").uniq
                render json: {data: @friend}, status: 200
            elsif params[:friend_action] == "accept_list"
                
                @friend = User.select("users.id, users.user_name, friend_lists.friend_id").joins("LEFT JOIN friend_lists ON friend_lists.user_id = users.id").where(:friend_lists => {friend_id: params[:user_id]}).where(:friend_lists => {status: 1})
                render json: {data: @friend}, status: 200
               
            elsif params[:friend_action] == "request"
                friend_exist = User.find_by_user_name(params[:friend_name])
                if friend_exist.nil?
                    render json: {message: "0"}, status: 200
                else
                    @friend_check = FriendList.find_by_user_id_and_friend_id_and_status(params[:user_id],friend_exist.id, 1)
                    if @friend_check.nil?
                        @friend = FriendList.create(user_id: params[:user_id], friend_id: friend_exist.id, status: 1)
                        render json: {message: "1"}, status: 200
                    else
                        render json: {message: "2"}, status: 200
                    end
                end
                
            elsif params[:friend_action] == "accept"
                
                @user_friend = FriendList.find_by_user_id_and_friend_id_and_status(params[:user_id], params[:friend_id], 1)
                @user_friend = @user_friend.update_attributes(status: 2)
                @friend_user = FriendList.create(user_id: params[:friend_id], friend_id: params[:user_id], status: 2)
                render json: {message: "Friend Accepted"}, status: 200
            
            end
    
    end
    
    def deck
        if params[:deck_main_action] == "editdeck"
   
            if params[:user_id].nil? || params[:card_id].nil? || params[:deck_id].nil? || params[:card_quantity].nil? || params[:card_type].nil? || params[:deck_action].nil? || params[:user_id].blank? || params[:card_id].blank? || params[:deck_id].blank? || params[:card_quantity].blank? || params[:card_type].blank? || params[:deck_action].blank?
                render json: {message: 'error'}, status: 200
            else
                decktotal = DeckList.where(deck_name_id: params[:deck_id])
                totalquantity = 0
                decktotal.each do |quantity|
                    totalquantity = totalquantity + quantity.card_quantity
                end
                if totalquantity < 50 || params[:deck_action] == "subtract"
                    cardtotal = DeckList.find_by_user_id_and_card_id_and_deck_name_id(params[:user_id], params[:card_id], params[:deck_id])
                    if cardtotal.nil? && params[:deck_action] == "add"
                        deck = DeckList.create(user_id: params[:user_id], card_id: params[:card_id], deck_name_id: params[:deck_id], card_quantity: params[:card_quantity])
                        render json: {message: '1'}, status: 200
                    else
                        if params[:deck_action] == "add"
                            if params[:card_type] != "GRAPHIC" && cardtotal.card_quantity >= 3
                                render json: {message: '3'}, status: 200
                                # past Card Quantity 3
                            else
                                newCardQuantity = params[:card_quantity].to_i + cardtotal.card_quantity.to_i
                                DeckList.find(cardtotal.id).update_attributes(card_quantity: newCardQuantity)

                                render json: {message: '1'}, status: 200
                                # add 1

                            end
                        elsif params[:deck_action] == "subtract"
                            if cardtotal.nil?
                                render json: {message: '4'}, status: 200
                                # go under 0 4
                            elsif cardtotal.card_quantity == 1
                                deckList = DeckList.find(cardtotal.id)
                                deckList.destroy
                                render json: {message: '2', quantity: "0" }, status: 200
                            else
                                newCardQuantity = cardtotal.card_quantity.to_i - params[:card_quantity].to_i
                                DeckList.find(cardtotal.id).update_attributes(card_quantity: newCardQuantity)

                                render json: {message: '2'}, status: 200
                                # add 2

                            end
                        end
                    end
                else
                    render json: {message: '5'}, status: 200
                end
			end
            
        elsif params[:deck_main_action] == "edit_deck_content"
            
            if params[:deck_action] == "deck_name"
                DeckName.find(params[:deck_id]).update_attributes(deck_name: params[:content])
                render json: {message: '1'}, status: 200
            elsif params[:deck_action] == "deck_summary"
                DeckName.find(params[:deck_id]).update_attributes(deck_summary: params[:content])
                render json: {message: '2'}, status: 200
            end
            
		elsif params[:deck_main_action] == "create_deck"
			checkDeck = DeckName.find_by_user_id_and_deck_name(params[:user_id], params[:deck_name])
			
			if params[:deck_action] == "create"
				if checkDeck.nil?
					DeckName.create(user_id: params[:user_id], deck_name: params[:deck_name], deck_summary: params[:deck_summary], status: 1)
					render json: {message: '1'}, status: 200
                    #1 Create Successful
				else
					render json: {message: '2'}, status: 200
                    #2 Deck already exist
				end
			elsif params[:deck_action] == "delete"
				deckName = DeckName.find(checkDeck.id)
				deckName.destroy
				
				deckList = DeckList.find_by_user_id_and_deck_name_id(params[:user_id], checkDeck.id)
                deckComment = DeckComment.find_by_deck_id(checkDeck.id)
                shareDeck = ShareDeck.find_by_deck_name_id(checkDeck.id)
                if deckComment.nil?
                else
                    DeckComment.destroy_all(:deck_id => checkDeck.id)
                end
                if shareDeck.nil?
                else
                    ShareDeck.destroy_all(:deck_id => checkDeck.id)
                end
				if deckList.nil?
					render json: {message: '1'}, status: 200
				else
					DeckList.destroy_all(:user_id => params[:user_id], :deck_id => checkDeck.id)
					render json: {message: '1'}, status: 200
				end
				
			end
        end
    end
    
    def getdeck
        if params[:deck_action] == "own"
            @deckName = DeckName.select("id, deck_name, deck_summary, public_status, share_status, user_id")
            @deckName = @deckName.where(user_id: params[:user_id])

            render json: {data: @deckName.to_a}, status: 200
        elsif params[:deck_action] == "share"
            @deckName = ShareDeck.joins("LEFT JOIN deck_names ON deck_names.id = share_decks.deck_name_id").joins("LEFT JOIN users ON users.id = share_decks.user_id").select("share_decks.id", "users.user_name", "share_decks.user_id", "share_decks.share_user_id", "deck_names.deck_name", "deck_names.id as deck_id").where(share_user_id: params[:user_id])
            
            render json: {data: @deckName.to_a}, status: 200
        elsif params[:deck_action] == "public"
            @deckName = DeckName.select("deck_names.id, deck_names.deck_name, deck_names.deck_summary, users.user_name, users.id as user_id").joins("LEFT JOIN users ON users.id = deck_names.user_id")
            @deckName = @deckName.where(public_status: 1)
            
            render json: {data: @deckName.to_a}, status: 200
        end
        
    end
    
    
    def decklist
        if params[:deck_action] == "own"
            @deckId = DeckList.select("*").joins(:card).where(deck_name_id: params[:deck_id]).order("card_type desc")
            render json: {data: @deckId}, status: 200
        end
    end
    
    def sharedeck

            if params[:share_action] == "share"
                share_list = params[:share_user_id_list].split(",")
                share_list.each do |shareList|
                    ShareDeck.create(user_id: params[:user_id], share_user_id: shareList, deck_name_id: params[:deck_id])
                end
                render json: {message: 'You have shared your deck'}, status: 200
                
            elsif params[:share_action] == "remove_share"
                
                
            elsif params[:share_action] == "public"
                @deck_name = DeckName.find_by_id(params[:deck_id])
                @deck_name = @deck_name.update_attributes(public_status: 1)
                render json: {message: '1'}, status: 200
                
            elsif params[:share_action] == "public_unshare"
                @deck_name = DeckName.find_by_id(params[:deck_id])
                @deck_name = @deck_name.update_attributes(public_status: 0)
                render json: {message: '2'}, status: 200
            end
        
        
    end
    
    def deckcomment
        if params[:deck_comment_action] == "create"
            @deckComment = DeckComment.create(deck_id: params[:deck_id], user_id: params[:user_id], comment: params[:deck_comment].to_s, priority: 0)
            render json: {message: '1'}, status: 200
        elsif params[:deck_comment_action] == "add_priority"
            
        elsif params[:deck_comment_action] == "get"
            @deckComment = DeckComment.select("deck_comments.id, users.user_name, users.id as user_id, deck_comments.comment, deck_comments.priority").joins("LEFT JOIN users ON users.id = deck_comments.user_id").where(:deck_comments => {:deck_id => params[:deck_id]})
            @deckOwner = DeckName.find_by_id(params[:deck_id])
            render json: {data: @deckComment, sub_data: @deckOwner.user_id}, status: 200
        elsif params[:deck_comment_action] == "delete"
            deckComment = DeckComment.find(params[:deck_comment_id])
			deckComment.destroy
            render json: {message: '1'}, status: 200
        
        end
    end

    
end