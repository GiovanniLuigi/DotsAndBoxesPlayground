//
//  Mark.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation

public enum Mark: String {
    case none = "E"
    case notMarked = "*"
    case markedH = "|"
    case markedV = "-"
    case dot = "o"
    case box = "B"
    
    public func text() -> String {
        switch self {
        case .box:
            return "B"
        case .dot:
            return "o"
        case .markedH:
            return "-"
        case .markedV:
            return "|"
        case .notMarked:
            return "*"
        case .none:
            return "E"
        }
    }
}
