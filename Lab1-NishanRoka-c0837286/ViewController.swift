//
//  ViewController.swift
//  Lab1-NishanRoka-c0837286
//
//  Created by Nishu Roka on 17/01/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    
    
    var shakeCount = 0
    
    enum Turn {
        case Nought
        case Cross
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    var lastTap:UIButton!
    
    var noughtsScore = 0
    var crossesScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initBoard()
        loadWins()
        
        //for shake gesture
        becomeFirstResponder()
        
    }
    
    var winState:Wins!
    
    
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
    
    func loadWins() {
        
        let request: NSFetchRequest<Wins> = Wins.fetchRequest()
        
        do {
            let winStates = try context.fetch(request)
            winState = winStates.first
            if winState != nil {
                crossesScore = Int(winState.crossWin!) ?? 0
                noughtsScore = Int(winState.noughtWin!) ?? 0
                crossScore.text = winState.crossWin
                noughtScore.text = winState.noughtWin
            }
        } catch {
            print("Error loading folders \(error.localizedDescription)")
        }
    }
    
    @IBAction func boardTap(_ sender: Any) {
        addToBoard(sender as! UIButton)
        lastTap = sender as? UIButton
        shakeCount = 0
        
        if checkForVictory(CROSS)
        {
            crossesScore += 1
            crossScore.text = String(crossesScore)
            resultAlert(title: "Crosses Win!")
            
            if winState == nil {
                winState = Wins(context: context)
            }
            winState.crossWin = crossScore.text
            winState.noughtWin = noughtScore.text
            do{
                try context.save()
            } catch (let error) {
                print(error)
                return
            }
            
        }
        
        if checkForVictory(NOUGHT)
        {
            noughtsScore += 1
            noughtScore.text = String(noughtsScore)
            resultAlert(title: "Noughts Win!")
            
            if winState == nil {
                winState = Wins(context: context)
            }
            winState.crossWin = crossScore.text
            winState.noughtWin = noughtScore.text
            do{
                try context.save()
            } catch (let error) {
                print(error)
                return
            }
            do{
                try context.save()
            }catch{
                print("Error saving data \(error.localizedDescription)")
            }
            
        }
        
        if(crossP.fullBoard(board: board))
        {
            if winState == nil {
                winState = Wins(context: context)
            }
            winState.crossWin = crossScore.text
            winState.noughtWin = noughtScore.text
            do{
                try context.save()
            } catch (let error) {
                print(error)
                return
            }
            
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
    
    
    //shake gesture
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            shakeCount += 1
            if (shakeCount < 2){
                let random = lastTap.title(for: .normal)!
                if random == "X"{
                    currentTurn = Turn.Cross
                    forTurn.text = CROSS
                    
                }else{
                    currentTurn = Turn.Nought
                    forTurn.text = NOUGHT
                    
                }
                lastTap.setTitle(nil, for: .normal)
                lastTap.isEnabled = true
                
            }else{
                print("Too many shakes")
            }
            
            
            
            
            
            
            
        }
    }
    
    
    
}


