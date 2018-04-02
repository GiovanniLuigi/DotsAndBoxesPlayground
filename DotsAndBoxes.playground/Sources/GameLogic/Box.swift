//
//  Box.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation

public class Box: NSObject {
    public let index: Int
    public var player: Player?
    
    public init(index: Int, player: Player? = nil) {
        self.index = index
    }
    
    public func copy() -> Box {
        let copy = Box(index: index)
        if let p = player {
            copy.player = Player(playerId: p.playerId)
        }
        return copy
    }
}
