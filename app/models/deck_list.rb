class DeckList < ActiveRecord::Base
    belongs_to :card
    belongs_to :deck_name
end
