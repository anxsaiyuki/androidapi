class DeckName < ActiveRecord::Base
    has_many :deck_lists
    has_many :share_decks
end
