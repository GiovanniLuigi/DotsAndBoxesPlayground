//
//  GameDelegate.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation

public protocol GameDelegate {
    func game(didClose box: Box, player: Player)
    func game(didOverWith winner: Player?)
    func game(didSwitchTurn to: Player)
}
