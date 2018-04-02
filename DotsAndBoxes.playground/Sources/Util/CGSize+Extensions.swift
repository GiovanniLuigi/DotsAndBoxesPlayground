//
//  CGSize+Extensions.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import SpriteKit

public func / (left: CGSize, right: CGFloat) -> CGSize{
    return CGSize(width: left.width/right, height: left.height/right)
}

public func * (left: CGSize, right: CGFloat) -> CGSize{
    return CGSize(width: left.width*right, height: left.height*right)
}

public func *= (left: inout CGSize, right: CGFloat) {
    left = left * right
}
