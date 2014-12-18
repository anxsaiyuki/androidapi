class ApiController < ActionController::Base
    respond_to :json, :html
    
    def index
        
        @api = "test"
        
        render json: {message: 'android'}, status: 200
        
    end
    
    def cardinfo
        @cards = Card.all
            respond_to do |format|
              format.html
              format.json { render :json => @cards }
            end
    end
end
