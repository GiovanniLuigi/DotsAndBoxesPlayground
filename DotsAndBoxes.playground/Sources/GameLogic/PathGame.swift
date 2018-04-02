//
//  PathGame.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 26/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import SpriteKit
import GameplayKit

class PathGame: Game {
    
    var graphNodes: [GKGraphNode]!
    var graph: GKGraph!
    
    override func initialSetup(size: Int) {
        super.initialSetup(size: size)
        graph = GKGraph()
        graphNodes = Array(repeating: GKGraphNode(), count: boxes.count)
        
        didCloseBox = {
            box, player in
            player.points += 1
            //Add a connection to graph node
        }
        
    }
    
    func hasPath() -> Bool {
        return false
    }
    
}
