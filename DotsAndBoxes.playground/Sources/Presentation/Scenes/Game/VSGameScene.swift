//
//  VSGameScene.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 31/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import SpriteKit


class VSGameScene: GameScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        aiEnabled = false
        hasIntro = false
    }
    
    override func keepGoing() {
        if let view = self.view {
            let gameScene = VSGameScene(size: view.bounds.size)
            gameScene.scaleMode = U.scaleMode
            gameScene.aiEnabled = false
            gameScene.hasIntro = false
            view.presentScene(gameScene, transition:U.defaultTransition)
        }
    }
    
}
