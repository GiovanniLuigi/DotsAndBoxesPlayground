//
//  IntroGameNode.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 28/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import SpriteKit

public class IntroGameNode: SKSpriteNode, GameDelegate {
    
    
    public var blockSize: CGFloat {
        return size.width/CGFloat(3+2)
    }
    public var markNodes = [MarkNode]()
    public var game = Game()
    public var count = 0
    
    public init() {
        let texture = SKTexture(imageNamed: "Rect")
        super.init(texture: texture, color: .clear, size: texture.size())
        isUserInteractionEnabled = true
        game.delegate = self
        game.initialSetup(size: 3)
        
        for i in 0..<3 {
            for j in 0..<3 {
                let node = MarkNode()
                node.texture = getTexture(for: (i,j))
                node.name = name(for: (i,j))
                node.index = (i,j)
                
                node.size = CGSize(width: blockSize, height: blockSize)
                
                node.position.x = CGFloat(i) * blockSize
                node.position.y = -1 * CGFloat(j) * blockSize
                node.zPosition = 15
                
                node.position.x -= blockSize*CGFloat(2)/2
                node.position.y += blockSize*CGFloat(2)/2
                addChild(node)
                
                markNodes.append(node)
            }
        }
        
        for mark in markNodes {
            if mark.name == Mark.notMarked.text() && count < 3 {
                makePlay(node: mark)
                count += 1
            } else if mark.name == Mark.notMarked.text() && !(count < 3) {
                highlight(node: mark)
            }
        }
    }
    
    func highlight(node: MarkNode) {
        let index = node.index
        
        if index.i % 2 == 0 {
            node.texture = SKTexture(imageNamed: "MarkV")
            node.size = CGSize(width: blockSize / 2.0, height: blockSize * 0.9)
        }else{
            node.texture = SKTexture(imageNamed: "MarkH")
            node.size = CGSize(width: blockSize * 0.9, height: blockSize / 2.0)
        }
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.75)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.75)
        let seq = SKAction.sequence([fadeOutAction, fadeInAction])
        
        node.name = "h"
        
        node.run(SKAction.repeatForever(seq), withKey: "fade")
    }
    
    public func getTexture(for index: (i: Int, j:Int)) -> SKTexture? {
        let mark = game.board[index.j + index.i * game.size]
        if mark == .dot {
            return SKTexture(imageNamed: "Dot")
        }
        return nil
    }
    
    public func name(for index: (i: Int, j:Int)) -> String {
        let mark = game.board[index.j + index.i * game.size]
        return mark.text()
    }
    
    public func makePlay(node: MarkNode) {
        
        let index = node.index
        
        if index.i % 2 == 0 {
            node.texture = SKTexture(imageNamed: "MarkV")
            node.size = CGSize(width: blockSize / 2.0, height: blockSize * 0.9)
        }else{
            node.texture = SKTexture(imageNamed: "MarkH")
            node.size = CGSize(width: blockSize * 0.9, height: blockSize / 2.0)
        }
        
        game.apply(Move(index: node.index.j + node.index.i * game.size))
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else {return}
        if let node = nodes(at: p).first as? MarkNode {
            if node.name == "h" {
                makePlay(node: node)
                node.removeAction(forKey: "fade")
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func game(didClose box: Box, player: Player) {
        let node = markNodes[box.index]
        let colorizeAction = SKAction.colorize(with: .green, colorBlendFactor: 1, duration: 0.45)
        
        node.run(colorizeAction, completion: {
            let view = (self.parent as! SKScene).view!
            let gameScene = GameScene(size: view.bounds.size)
            gameScene.scaleMode = .aspectFit
            view.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.25))
        })
    }
    
    public func game(didOverWith winner: Player?) {
        
    }
    
    public func game(didSwitchTurn to: Player) {
        
    }
    
    
}
