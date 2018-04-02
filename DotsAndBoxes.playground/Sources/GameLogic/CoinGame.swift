//
//  CoinGame.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import SpriteKit
import GameplayKit

class CoinGame: Game {
    
    var coins = [Int]()
    var numberOfCoins: Int = 3
    
    init(numberOfCoins: Int) {
        super.init()
        self.numberOfCoins = numberOfCoins
        
    }
    
    override func initialSetup(size: Int) {
        super.initialSetup(size: size)
        self.didCloseBox = {
            box, player in
            if self.coins.contains(box.index) {
                player.points += 1
            }
        }
        coins = [Int]()
        if numberOfCoins > 0 {
            for _ in 0..<numberOfCoins {
                var coinAdded = false
                while !coinAdded {
                    let randomIndex = randomCoinIndex()
                    if !coins.contains(randomIndex) && board[randomIndex] == .box {
                        coinAdded = true
                        coins.append(randomIndex)
                    }
                }
            }
        }
    }
    
    func randomCoinIndex() -> Int {
        return Int.random(board.count)
    }
    
    override func isGameOver() -> Bool {
        var sum = 0
        for player in allPlayers {
            sum += player.points
        }

        if sum >= self.coins.count {
            return true
        }
        return false
    }
    
    override func getWinner() -> Player? {
        if allPlayers[0].points >= coins.count {
            return allPlayers[0]
        }else if allPlayers[1].points >= coins.count {
            return allPlayers[1]
        }
        return nil
    }
}
