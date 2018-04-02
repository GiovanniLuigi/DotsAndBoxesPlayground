//
//  CutSceneManager.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 27/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import SpriteKit

public typealias Interaction = (actor: SKNode, action: SKAction)
public class CutSceneHelper {
    
    private var marker = 0
    private var interactions = [Interaction]()
    
    @discardableResult
    public func move(_ node: SKNode,
                     to position: CGPoint,
                     with duration: TimeInterval = 2.5,
                     timingMode: SKActionTimingMode = .easeInEaseOut)
        -> CutSceneHelper {
            let moveAction = SKAction.move(to: position, duration: duration)
            moveAction.timingMode = timingMode
            interactions.append((actor: node, action: moveAction))
            
            return self
    }
    
    @discardableResult
    public func move(parent: SKNode,
                     node named: String,
                     to position: CGPoint,
                     with duration: TimeInterval = 2.5,
                     timingMode: SKActionTimingMode = .easeInEaseOut)
        -> CutSceneHelper {
            let moveAction = SKAction.move(to: position, duration: duration)
            moveAction.timingMode = timingMode
            interactions.append((actor: parent.childNode(withName: named)!, action: moveAction))
            
            return self
    }
    
    @discardableResult
    public func moveBy(_ node: SKNode,
                     x: CGFloat = 0,
                     y: CGFloat = 0,
                     with duration: TimeInterval = 2.5,
                     timingMode: SKActionTimingMode = .easeInEaseOut)
        -> CutSceneHelper {
            let moveAction = SKAction.moveBy(x: x, y: y, duration: duration)
            moveAction.timingMode = timingMode
            interactions.append((actor: node, action: moveAction))
            
            return self
    }
    
    @discardableResult
    public func moveBy(parent: SKNode,
                       node named: String,
                       x: CGFloat = 0,
                       y: CGFloat = 0,
                       with duration: TimeInterval = 2.5,
                       timingMode: SKActionTimingMode = .easeInEaseOut)
        -> CutSceneHelper {
            let moveAction = SKAction.moveBy(x: x, y: y, duration: duration)
            moveAction.timingMode = timingMode
            interactions.append((actor: parent.childNode(withName: named)!, action: moveAction))
            
            return self
    }
    
    @discardableResult
    public func shake(_ node: SKNode,
                      duration: TimeInterval = 0.75) -> CutSceneHelper {
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        
        let actionSeq = SKAction.sequence(actionsArray)
        
        interactions.append((node, actionSeq))
        
        return self
    }
    
    @discardableResult
    public func addTextBox(to node: SKNode,
                    named: String,
                    at: CGPoint,
                    left: Bool = true) -> CutSceneHelper {
        let textBox = SKSpriteNode(imageNamed: named)
        textBox.name = named
        textBox.position = at
        textBox.setScale(0)
        if left {
            textBox.anchorPoint = CGPoint(x: 0,y: 0)
        }else{
            textBox.anchorPoint = CGPoint(x: 1,y: 0)
        }
        textBox.zPosition = 10
        node.addChild(textBox)
        let animateTextBoxAction = SKAction.scale(to: 1, duration: 0.4)
        animateTextBoxAction.timingMode = .easeOut
        
        interactions.append((textBox, animateTextBoxAction))
        
        return self
    }
    
    @discardableResult
    public func removeTextBox(from node: SKNode,
                       named: String) -> CutSceneHelper {
        let tb = node.childNode(withName: named)
        
        let animateTextBoxAction = SKAction.scale(to: 0, duration: 0.4)
        animateTextBoxAction.timingMode = .easeIn
        
        let removeAction = SKAction.removeFromParent()
        
        let seq = SKAction.sequence([animateTextBoxAction, removeAction])
        
        interactions.append((tb!, seq))
        
        return self
    }
    
    @discardableResult
    public func fadeOut(node: SKNode, duration: TimeInterval = 0) -> CutSceneHelper {
        
        let fadeOutAction = SKAction.fadeOut(withDuration: duration)
        
        interactions.append((node, fadeOutAction))
        
        return self
    }
    
    @discardableResult
    public func fadeIn(node: SKNode, duration: TimeInterval = 0) -> CutSceneHelper {
        
        let fadeInAction = SKAction.fadeIn(withDuration: duration)
        
        interactions.append((node, fadeInAction))
        
        return self
    }
    
    @discardableResult
    public func addGameElement(node: SKNode,
                        to: SKNode,
                        at position: CGPoint) -> CutSceneHelper {
        
        node.position = position
        
        let addAction = SKAction.run {
            to.addChild(node)
        }
        
        interactions.append((to, addAction))
        
        return self
    }
    
    @discardableResult
    public func run(_ node: SKNode, block: @escaping ()-> Void ) -> CutSceneHelper {
        let action = SKAction.run(block)
        interactions.append((node, action))
        return self
    }
    
    @discardableResult
    public func animate(_ node: SKNode, to: SKTexture) -> CutSceneHelper {
        
        let animateAction = SKAction.animate(with: [to], timePerFrame: 0.25)
        
        interactions.append((node, animateAction))
        
        return self
    }
    
    public func play(numberOfInteractions: Int = 1, completion: @escaping () -> Void) {
        if numberOfInteractions < 1 {
            completion()
            return
        }
        if let interaction = next() {
            interaction.actor.run(interaction.action, completion: {
                self.play(numberOfInteractions: numberOfInteractions-1, completion: completion)
            })
        }
    }
    
    public func next() -> Interaction? {
        if (marker < interactions.count) {
            let interaction = interactions[marker]
            marker += 1
            return interaction
        }
        return nil
    }
    
}
