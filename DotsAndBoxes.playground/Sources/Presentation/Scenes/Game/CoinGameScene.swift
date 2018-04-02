//
//  CoinGameScene.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 23/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import SpriteKit

public class CoinGameScene: GameScene {
    
    var coinNodes = [CoinNode]()
    
    override public func didMove(to view: SKView) {
        game = CoinGame(numberOfCoins: 3)
        super.didMove(to: view)
    }
    
    override public func initialSetup() {
        super.initialSetup()
        villainNode.position.x += villainNode.size.width * 0.1
        villainNode.size *= 0.7
        
        game.delegate = self

        coinNodes = [CoinNode]()
        
        for coinIndex in coinGame().coins {
            for markNode in markNodes {
                let index = markNode.index
                if (index.j + index.i * game.size) == coinIndex {
                    let coinNode = CoinNode(imageNamed: "Trash4")
                    coinNode.index = coinIndex
                    coinNode.position = markNode.position
                    coinNode.size = markNode.size/4
                    coinNode.color = UIColor.yellow
                    coinNode.zPosition = U.zPosition7
                    coinNodes.append(coinNode)
                    addChild(coinNode)
                }
            }
        }
    }
    
    func coinGame() -> CoinGame {
        return game as! CoinGame
    }
    
    
    override public func game(didClose box: Box, player: Player) {
        super.game(didClose: box, player: player)
        for coin in coinNodes {
            if coin.index == box.index {
                coin.run(SKAction.sequence([
                    SKAction.scale(to: 0, duration: 0.1),
                    SKAction.removeFromParent()
                    ]))
            }
        }
    }
    
    override public func game(didOverWith winner: Player?) {
       super.game(didOverWith: winner)
    }
    
    
    override public func setupCutSceneActions() {
        let tb15 = "TB15"
        let tb16 = "TB16"
        
        let heroTBPosition = CGPoint(x: heroNode.position.x + heroNode.size.width/3, y: heroNode.position.y)
        
        sceneHelper
            
            //START
            .addTextBox(to: self, named: tb15, at: heroTBPosition)
            //FINISH (1)
            
            //START
            .removeTextBox(from: self, named: tb15)
            .addTextBox(to: self, named: tb16, at: heroTBPosition)
            //FINISH (2)
            
            //START
            .removeTextBox(from: self, named: tb16)
            //FINISH (1)
        
        numberOfActions.append(1)
        numberOfActions.append(2)
        numberOfActions.append(1)
        
        playNext()
    }
    
    override public func keepGoing() {
        if let view = self.view {
            guard let scene = CutScene(fileNamed: "CutScene") else {return}
            scene.sceneType = .findPath
            scene.scaleMode = U.scaleMode
            view.presentScene(scene, transition: U.defaultTransition)
        }
    }
    
    override public func setupEnemyTexture() {
        enemyTextureName = "VillainTrash"
    }
    
    override public func closeBoxAnimation(green: Bool, markNode: MarkNode) {
        let index = markNode.index.j + markNode.index.i * level
        for coinNode in coinNodes {
            if coinNode.index == index {
                super.closeBoxAnimation(green: true, markNode: markNode)
            }
        }
    }
}
