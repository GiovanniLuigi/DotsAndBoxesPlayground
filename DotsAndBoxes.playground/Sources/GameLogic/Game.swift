//
//  Game.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import SpriteKit
import GameplayKit

public class Game: NSObject {
    
    public var allPlayers = [Player(playerId: 0), Player(playerId: 1)]
    public var lastId = 1
    public var size: Int!
    public var board: [Mark]!
    public var boxes: [Box]!
    public var currentPlayer: Player!{
        didSet {
            lastPlayer = oldValue
        }
    }
    public var lastPlayer: Player?
    public var maxPlays = 0
    public var didCloseBox: ((_ box: Box, _ player: Player) -> Void)?
    public var delegate: GameDelegate?
    public var gameOver: Bool = false {
        didSet {
            if gameOver {
                winner = getWinner()
                delegate?.game(didOverWith: winner)
            }
        }
    }
    public var possibleMoves: [Move]!
    public var winner: Player? = nil
    
    public func initialSetup(size: Int) {
        self.size = size
        self.currentPlayer = allPlayers[0]
        self.maxPlays = 0
        self.winner = nil
        self.gameOver = false
        
        for p in allPlayers {
            p.points = 0
        }
        
        board = [Mark]()
        boxes = [Box]()
        
        for i in 0..<size {
            for j in 0..<size {
                if i % 2 == 0 && j % 2 == 0 {
                    board.append(Mark.dot)
                }else if i % 2 != 0 && j % 2 != 0{
                    board.append(Mark.box)
                    boxes.append(Box(index: j + i * size, player: nil))
                }else{
                    board.append(Mark.notMarked)
                    maxPlays += 1
                }
            }
        }
        
        self.didCloseBox = {
            _, player in
            player.points += 1
        }
        
        self.possibleMoves = getPossibleMoves()
    }
    
    public func printBoard() {
        for i in 0..<size {
            for j in 0..<size {
                print(board[j + i * size].text(), terminator: " ")
            }
            print("")
        }
    }
    
    public func mark(index: Int) {
        if !indexIsWithinBounds(index: index) {
            return
        }
        let mark = board[index]
        if mark == .notMarked {
            board[index] = Mark.markedH
            
            if !checkForClosedBoxes() {
                currentPlayer = nextPlayer()
                delegate?.game(didSwitchTurn: currentPlayer)
            }
            
            possibleMoves = getPossibleMoves()
            gameOver = isGameOver()
        }
    }
    
    public func checkForClosedBoxes() -> Bool {
        var closedAnyBox = false
        for b in boxes {
            if b.player == nil && indexIsWithinBounds(index: b.index){
                if isBoxClosed(box: b) {
                    closedAnyBox = true
                    b.player = currentPlayer
                    delegate?.game(didClose: b, player: currentPlayer)
                    if let didCloseBox = self.didCloseBox {
                        didCloseBox(b, currentPlayer)
                    }
                }
            }
        }
        return closedAnyBox
    }
    
    public func indexIsWithinBounds(index: Int) -> Bool {
        if index < 0 || index > size*size-1 {
            return false
        }
        
        return true
    }
    
    public func isBoxClosed(box: Box) -> Bool {
        let indexs = [box.index + size, box.index - size, box.index + 1, box.index - 1]
        
        for i in indexs {
            if !indexIsWithinBounds(index: i) {
                return false
            }
            if board[i] != .markedH && board[i] != .markedV {
                return false
            }
        }
        return true
    }
    
    public func nextPlayer() -> Player {
        if currentPlayer.playerId + 1 < allPlayers.count {
            return allPlayers[currentPlayer.playerId + 1]
        }
        return allPlayers[0]
    }
    
    public func getLastPlayer() -> Player? {
        if lastPlayer == nil {return allPlayers[0]}
        return lastPlayer
    }
    
    public func isGameOver() -> Bool {
        return possibleMoves.count <= 0
    }
    
    public func getWinner() -> Player? {
        if !gameOver {return nil}
        guard let p1 = currentPlayer else {return nil}
        let p2 = nextPlayer()
        
        if p1.points > p2.points {
            return p1
        }else if p2.points > p1.points{
            return p2
        }
        return nil
    }
    
    public func reset(size: Int) {
        initialSetup(size: size)
    }
    
    public func addPlayer() {
        let id = lastId + 1
        allPlayers.append(Player(playerId: id))
        lastId = id
    }
    
    public func reset() {
        lastId = -1
        allPlayers = [Player]()
    }
    
    func getPossibleMoves() -> [Move] {
        var moves = [Move]()
        for (i,mark) in board.enumerated() {
            if mark == .notMarked {
                moves.append(Move(index: i))
            }
        }
        return moves
    }
    
    func opponent(for player: Player) -> Player {
        if player.playerId == 0 {
            return allPlayers[1]
        }
        return allPlayers[0]
    }
}

extension Game: GKGameModel {
    
    public var players: [GKGameModelPlayer]? {
        return allPlayers
    }
    
    public var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    public func setGameModel(_ gameModel: GKGameModel) {
        if let game = gameModel as? Game {
            self.boxes = [Box]()
            self.board = [Mark]()
            self.allPlayers = [Player]()
            for b in game.boxes {
                self.boxes.append(b.copy())
            }
            for m in game.board {
                self.board.append(Mark(rawValue: m.text())!)
            }
            
            for p in game.allPlayers {
                self.allPlayers.append(p.copy())
            }
            
            self.currentPlayer = self.allPlayers[game.currentPlayer.playerId]
            self.size = game.size
            self.lastId = game.lastId
            
            self.maxPlays = game.maxPlays
            
            if let winner = game.winner {
                self.winner = self.allPlayers[winner.playerId]
            }
            
            self.possibleMoves = getPossibleMoves()
            
//            self.didCloseBox = game.didCloseBox
        }
    }
    
    public func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        if gameOver {
            return nil
        }
        return possibleMoves
    }
    
    public func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else {return false}
        if winner == player {
            return true
        }
        return false
    }
    
    public func isLoss(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else {return false}
        if winner == opponent(for: player) {
            return true
        }
        return false
    }
    
    public func apply(_ gameModelUpdate: GKGameModelUpdate) {
        if let move = gameModelUpdate as? Move {
            mark(index: move.index)
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Game()
        copy.setGameModel(self)
        return copy
    }
    
    public func score(for player: GKGameModelPlayer) -> Int {
        guard let player = player as? Player else {return 0}
        var score = 0
        score += player.points
        
        for box in boxes {
            var markedCount = 0
            var notMarkedCount = 0
            let indexs = [box.index + size, box.index - size, box.index + 1, box.index - 1]
            
            for i in indexs {
                if indexIsWithinBounds(index: i) {
                    if board[i] == .markedH || board[i] == .markedV {
                        markedCount += 1
                    }else if board[i] == .notMarked {
                        notMarkedCount += 1
                    }
                }
            }
            if markedCount == 3 && notMarkedCount == 1 {
                score -= 1
            }
        }
        
        return score
    }
    
}
