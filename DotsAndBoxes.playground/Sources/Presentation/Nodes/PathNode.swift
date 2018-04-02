//
//  PathNode.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 27/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import GameplayKit

class PathNode: GKGraphNode {
    override var description: String {return "\(index)"}
    var index: (i: Int, j: Int) = (-1,-1)
}
