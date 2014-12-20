class ApiController < ActionController::Base
    respond_to :json, :html
    
    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
    
    def cardinfo
        p "===================================================="
        p params
        p "===================================================="
        
        @cards = Card.all
        @cards = @cards.where('card_type', params[:card_type]) if params[:card_type]
        @cards = @cards.where('color', params[:color]) if params[:color]
        
        render json: {data: @cards}, status: 200  
    end
end
