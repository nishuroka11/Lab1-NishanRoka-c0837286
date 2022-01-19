//
//  Player.swift
//  Lab1-NishanRoka-c0837286
//
//  Created by Nishu Roka on 18/01/2022.
//

import Foundation
import UIKit



class Player {
    
    enum Turn {
        case Nought
        case Cross
    }

    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross
    
    func fullBoard(board:[UIButton]) -> Bool
    {
        for button in board
        {
            if button.title(for: .normal) == nil
            {
                return false
            }
        }
        return true
    }
    
    func resetBoard(board:[UIButton])
    {
        for button in board
        {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if firstTurn == Turn.Nought
        {
            firstTurn = Turn.Cross
        }
        else if firstTurn == Turn.Cross
        {
            firstTurn = Turn.Nought
        }
        currentTurn = firstTurn
    }
    
    
    
}
