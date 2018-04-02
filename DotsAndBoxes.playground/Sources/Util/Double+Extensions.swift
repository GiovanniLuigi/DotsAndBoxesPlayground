//
//  CGFloat+Extensions.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 29/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation

extension Double {
    
    public static func random() -> Double {
        return Double(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}
