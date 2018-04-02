//
//  Int+Extensions.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation

extension Int{
    public static func random(_ n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
}
