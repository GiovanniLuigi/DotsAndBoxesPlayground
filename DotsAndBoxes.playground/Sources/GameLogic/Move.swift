//
//  Move.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import GameplayKit

public class Move: NSObject, GKGameModelUpdate {
    public var value: Int = 0
    public var index: Int
    
    public init(index: Int) {
        self.index = index
    }
}
