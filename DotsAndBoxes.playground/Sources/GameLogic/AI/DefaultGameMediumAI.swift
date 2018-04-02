//
//  DefaultGameMediumAI.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import GameplayKit

public class DefaultGameMediumAI: AI {
    
    private let strategist: GKMinmaxStrategist = GKMinmaxStrategist()
    private let aiMaxLookAheadDepth: Int = 2
    private let gameModel: Game
    
    public init(gameModel: Game) {
        self.gameModel = gameModel
        strategist.gameModel = gameModel
        strategist.maxLookAheadDepth = self.aiMaxLookAheadDepth
    }
    
    public func bestMove() -> Move? {
        if let move = strategist.bestMoveForActivePlayer() as? Move{
            return move
        }else{
            return self.gameModel.possibleMoves.first
        }
    }
    
}
