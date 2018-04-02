//
//  Player.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import GameplayKit

public class Player: NSObject, GKGameModelPlayer {
    
    public override var description: String {return "Player: \(playerId) | Points: \(points)"}
    public static var allColors = [[U.lightGreen, U.darkGreen], [U.lightRed, U.darkRed]]
    
    public var playerId: Int = 0
    public var points: Int = 0
    
    public var color: [UIColor] {
        return Player.allColors[playerId]
    }
    
    public init(playerId: Int) {
        self.playerId = playerId
    }
    
    func copy() -> Player {
        let copy = Player(playerId: playerId)
        copy.points = Int(points)
        return copy
    }
    
}
