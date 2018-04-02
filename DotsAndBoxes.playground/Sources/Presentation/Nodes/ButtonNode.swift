//
//  ButtonNode.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import SpriteKit

public class ButtonNode: SKSpriteNode {
    let scaleSequence: SKAction
    
    var action: (() -> Void)?
    var text: String? {
        didSet {
            childNode(withName: "label")?.removeFromParent()
            let lbl = SKLabelNode(text: text)
            lbl.verticalAlignmentMode = .center
            lbl.horizontalAlignmentMode = .center
            lbl.color = .white
            lbl.name = "label"
            lbl.zPosition = -1
            addChild(lbl)
        }
    }
    
    init(imageNamed: String) {
        let scaleUpAction = SKAction.scale(by: 1.25, duration: 0.1)
        let scaleDownAction = scaleUpAction.reversed()
        scaleSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: texture.size())
        isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(scaleSequence, completion: {
            if let action = self.action {
                action()
            }
        })
    }
}
