//
//  ViewController.swift
//  Concentration
//
//  Created by Luuk Harmeling on 28/10/2019.
//  Copyright © 2019 CarthagoICT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Initialiseer de game (concentration.swift)
    // We hebben in de button array 12 kaarten, maar om
    private lazy var game = Concentration(numberOfPairsOfCards: buttonArray.count / 2)
    
    
    var flipCount: Int = 0{
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!

    
    @IBOutlet var buttonArray: [UIButton]!

    var emojiChoices: Array<String> = ["🦇","🏓","👙","🚽","🏏","🥊","🥋","🏹","🥅"]
    private var emoji = [Int:String]()

    
    @IBAction func touchCard(_ sender: UIButton) {
           flipCount += 1
           if let cardNumber = buttonArray.firstIndex(of: sender) {
               game.chooseCard(at: cardNumber)
               updateViewFromModel()
           } else {
               print("Chosen card was not in cardButtons")
           }
       }
    
    @IBAction func restartButton(_ sender: Any) {
      restartGame()
    }
    
    func updateViewFromModel() {
        for index in buttonArray.indices {
            let button = buttonArray[index]
            let card = game.cards[index]
            if(card.isFaceUp && !card.isMatched) {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            }
        }
        
        if (game.allCardsAreMatched()) {
            let alert = UIAlertController(title: "YOU WON!", message: "It took you \(flipCount) flips to finish the game", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: {action in self.restartGame()}))
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
    }
    
    
   func emoji(for card: Card) -> String {
       if emoji[card.identifier] == nil, emojiChoices.count > 0 {
               let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
               emoji[card.identifier]  = emojiChoices.remove(at: randomIndex)
       }
       
       return emoji[card.identifier] ?? "?"
   }
    
    func restartGame() {
        resetCardStates()
        flipCount = 0
        emojiChoices = ["🦇","🏓","👙","🚽","🏏","🥊","🥋","🏹","🥅"]
        game = Concentration(numberOfPairsOfCards: buttonArray.count / 2)
    }
    
    func resetCardStates() {
        for index in buttonArray.indices {
            buttonArray[index].setTitle("", for: UIControl.State.normal)
            buttonArray[index].backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
    }

}

