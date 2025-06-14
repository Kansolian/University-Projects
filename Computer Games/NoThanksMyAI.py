# cards numbered 3 - 35    
"""
9 cards are randomly removed from the deck
24 cards in the deck each player has 11 coins

choice either take a card or put coin on card

Each card had a penalty, numver on card  = penatly

sequences get the penalty of the lowest card

"""

from copy import copy
from NoThanksPlayer import Player

class MyAI(Player):
    def __init__( self ):
        Player.__init__( self )
        self.setName( 'Konsalian' )


    def take( self, card, state ):

        t = False

        if self.coins <= 1:
            return True
        if (self.penaltyWhenTake(card) <= self.penalty()):
            return True
        elif card.coins >= card.penalty:
            return True
        
        return t
    
