//
//  PhotoGameScene.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 26/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import SpriteKit

class PhotoGameScene: GameScene {
    
    override func game(didClose box: Box, player: Player) {
        if player.playerId == 0 {
            let mask = SKSpriteNode()
            let imageNode = SKSpriteNode(imageNamed: "img")
            let cropNode = SKCropNode()
            
            mask.size = markNodes[box.index].size
            mask.color = .black
            imageNode.size = CGSize(width: blockSize*CGFloat(level), height: blockSize*CGFloat(level))*2

            cropNode.maskNode = mask
            cropNode.addChild(imageNode)
            cropNode.zPosition = U.zPosition3
            
            mask.position = markNodes[box.index].position
            
            addChild(cropNode)
        }else{
            super.game(didClose: box, player: player)
        }
    }
    
}
