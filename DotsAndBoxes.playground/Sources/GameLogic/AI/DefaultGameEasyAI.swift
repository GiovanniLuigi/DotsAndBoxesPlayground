//
//  DefaultGameEasyAI.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import GameplayKit

public class DefaultGameEasyAI: AI {
    
    private let strategist: GKMonteCarloStrategist = GKMonteCarloStrategist()
    private let aiBudget = 5
    private let aiExplorationParameter = 50
    private let randomSource = GKARC4RandomSource()
    private let gameModel: Game
    
    public init(gameModel: Game) {
        self.gameModel = gameModel
        strategist.gameModel = gameModel
        strategist.budget = self.aiBudget
        strategist.explorationParameter = self.aiExplorationParameter
        strategist.randomSource = self.randomSource
    }
    
    public func bestMove() -> Move? {
        if let move = strategist.bestMoveForActivePlayer() as? Move{
            return move
        }else{
            return self.gameModel.possibleMoves.first
        }
    }

}
