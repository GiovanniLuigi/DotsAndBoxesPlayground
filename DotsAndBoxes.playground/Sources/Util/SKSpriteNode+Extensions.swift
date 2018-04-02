//
//  SKSpriteNode+Extensions.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 29/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    
    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
    
    func addGlow(glowSprite: SKSpriteNode, radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(glowSprite)
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
}
