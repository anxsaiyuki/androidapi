class DeckName < ActiveRecord::Base
    has_many :deck_lists
end
