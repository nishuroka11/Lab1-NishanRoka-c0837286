//
//  ViewController.swift
//  Lab1-NishanRoka-c0837286
//
//  Created by Nishu Roka on 17/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    enum Turn {
        case Nought
        case Cross
    }
    
    @IBOutlet weak var forTurn: UILabel!
    @IBOutlet weak var crossScore: UILabel!
    @IBOutlet weak var noughtScore: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross
    
    var crossP = Player()
    
    var CROSS = "X"
    var NOUGHT = "O"
    
    var board = [UIButton]()
    
    var noughtsScore = 0
    var crossesScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initBoard()
    }
    
    func initBoard()
    {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    @IBAction func boardTap(_ sender: Any) {
        addToBoard(sender as! UIButton)
        
        if checkForVictory(CROSS)
        {
            crossesScore += 1
            crossScore.text = String(crossesScore)
            resultAlert(title: "Crosses Win!")
        }
        
        if checkForVictory(NOUGHT)
        {
            noughtsScore += 1
            noughtScore.text = String(noughtsScore)
            resultAlert(title: "Noughts Win!")
        }
        
        if(crossP.fullBoard(board: board))
        {
            resultAlert(title: "Draw")
        }
    }
    
    func checkForVictory(_ s :String) -> Bool
    {
        
        if (thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s)) || // Horizontal Victory
            (thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s)) || // Horizontal Victory
            (thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s)) || // Horizontal Victory
            (thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s)) || // Vertical Victory
            (thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s)) || // Vertical Victory
            (thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s)) || // Vertical Victory
            (thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s)) || // Diagonal Victory
            (thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s)) // Diagonal Victory
        {
            return true
        }
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool
    {
        return button.title(for: .normal) == symbol
    }
    
    func resultAlert(title: String)
    {
        let message = "\nNoughts " + String(noughtsScore) + "\n\nCrosses " + String(crossesScore)
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.crossP.resetBoard(board: self.board)
        }))
        self.present(ac, animated: true)
    }
    
    
    
    
    
    func addToBoard(_ sender: UIButton)
    {
        if(sender.title(for: .normal) == nil)
        {
            if(currentTurn == Turn.Nought)
            {
                sender.setTitle(NOUGHT, for: .normal)
                currentTurn = Turn.Cross
                forTurn.text = CROSS
            }
            else if(currentTurn == Turn.Cross)
            {
                sender.setTitle(CROSS, for: .normal)
                currentTurn = Turn.Nought
                forTurn.text = NOUGHT
            }
            sender.isEnabled = false
        }
    }
    
    @IBAction func resetGame(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            crossP.resetBoard(board: board)
            crossesScore = 0
            noughtsScore = 0
            crossScore.text = "0"
            noughtScore.text = "0"
            forTurn.text = ""
        default:
            break
        }
    }
    
    
    
    
    
    
}


