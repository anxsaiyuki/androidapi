class ApiController < ActionController::Base
    respond_to :json, :html
    
    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
    
    def cardinfo
        p "===================================================="
        p params
        p "=================我================================"
        
        @cards = Card.all
        @cards = @cards.where('card_type', params[:card_type].force_encoding(Encoding::UTF_8)) if params[:card_type]
        @cards = @cards.where('color', params[:color].force_encoding(Encoding::UTF_8)) if params[:color]
        
        render json: {data: @cards}, status: 200  
    end
end
