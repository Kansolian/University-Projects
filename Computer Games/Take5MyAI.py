# -*- coding: utf-8 -*-
"""
Created on Tue Nov  7 09:11:29 2023

@author: friez
"""

from Take5Player import Player
    

class MyAI3(Player):
    def __init__( self ):
        Player.__init__( self )
        self.setName( 'Konsalian' )


    def playCard( self, hand, rows, state ):
        highestR =  [r.cards[-1].number for r in rows]
        highestR.sort()
        pick = hand[-1]

        for i in range(len(hand)):
            current = hand[i]
            rowCards = rows[current.goesToRow(rows)].cards
            changed = False

            for h in highestR:
                if current.number > h and len(rowCards)<=3 and current.goesToRow(rows) != -1:
                    pick = current
                    changed = True
                    break
            if changed:
                break

        return pick
    
    def chooseRow( self, rows, state ):
        chosen = 0
        penalty = 1000
        for i in range(4):
            pen = rows[i].penalty()
            if pen < penalty:
                penalty = pen
                chosen = i
        return chosen