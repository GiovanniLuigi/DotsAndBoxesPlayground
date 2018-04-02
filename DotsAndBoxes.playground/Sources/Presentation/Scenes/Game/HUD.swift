//
//  HUD.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 28/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import SpriteKit

public class HUD {
    
    private let scene: GameScene
    private var p1PointsLabel: SKLabelNode!
    private var p2PointsLabel: SKLabelNode!
    private var turnIndicator: SKSpriteNode!
    private var turnIndicatorParent: SKCropNode!
    private var loserBoard: SKSpriteNode!
    private var winnerBoard: SKSpriteNode!
    private var hideBoardPosition: CGPoint = .zero

    public var p1Portrait: SKCropNode!
    public var p2Portrait: SKCropNode!
    
    private var backIndicator: SKSpriteNode!
    
    public init(scene: GameScene, hiddenPoints: Bool = false) {
        self.scene = scene
    }
    
    func initialSetup() {
        //P1
        let maskNode = SKSpriteNode(imageNamed: "Dot")
        maskNode.size = CGSize(width: scene.size.width/10, height: scene.size.width/10)
//        maskNode.color = scene.game.allPlayers[0].color[0]
        
        let charBackNode = SKSpriteNode()
        charBackNode.size = maskNode.size*1.1
        charBackNode.color = scene.game.allPlayers[0].color[0]

        let cropNode = SKCropNode()
        cropNode.maskNode = maskNode
        cropNode.addChild(charBackNode)
        cropNode.zPosition = U.zPosition7
        cropNode.position.x -= scene.size.width/2.55
        cropNode.position.y += scene.size.height*0.15
        
        scene.addChild(cropNode)
        
        p1Portrait = cropNode
        
        //P2
        let maskNode2 = SKSpriteNode(imageNamed: "Dot")
        maskNode2.size = CGSize(width: scene.size.width/10, height: scene.size.width/10)
        maskNode2.color = scene.game.allPlayers[1].color[0]
        
        let charBackNode2 = SKSpriteNode()
        charBackNode2.size = maskNode2.size*1.1
        charBackNode2.color = scene.game.allPlayers[1].color[0]
        
        let cropNode2 = SKCropNode()
        cropNode2.maskNode = maskNode2
        cropNode2.addChild(charBackNode2)
        cropNode2.zPosition = U.zPosition7
        cropNode2.position.x += scene.size.width/2.55
        cropNode2.position.y += scene.size.height*0.15
        
        scene.addChild(cropNode2)
        
        p2Portrait = cropNode2
        
        //Retry button
        let retryButton = ButtonNode(imageNamed: "RetryButton")
        retryButton.action = {
            self.scene.tryAgain()
        }
        retryButton.size = charBackNode2.size/2
        retryButton.size.width *= 2
        retryButton.position.y = +scene.size.height/2 - retryButton.size.height*2.0
        retryButton.position.x = cropNode2.position.x
//        retryButton.position.y += maskNode2.size.height*1.5
        retryButton.zPosition = U.zPosition9
        scene.addChild(retryButton)
        
        //Turn indicator setup
        let cropNode3 = SKCropNode()
        
        turnIndicator = SKSpriteNode(imageNamed: "Indicator")
        turnIndicator.zRotation -= .pi/2
        turnIndicator.zPosition = U.zPosition7
        turnIndicator.size = charBackNode.size/4.25
        
        let maskNode3 = SKSpriteNode(imageNamed: "Dot")
        maskNode3.size = turnIndicator.size*0.9
        
        cropNode3.position = cropNode.position
        cropNode3.position.x -= charBackNode.size.width*0.65
        cropNode3.addChild(turnIndicator)
        cropNode3.maskNode = maskNode3
        cropNode3.zPosition = U.zPosition7
        
        scene.addChild(cropNode3)
        
        backIndicator = SKSpriteNode(imageNamed: "Dot")
        backIndicator.size = maskNode3.size * 1.5
        backIndicator.position = cropNode3.position
        backIndicator.position.x += backIndicator.position.x * 0.005
        backIndicator.run(SKAction.colorize(with: U.darkGrey.withAlphaComponent(0.99), colorBlendFactor: 1, duration: 0))
        scene.addChild(backIndicator)
        
        turnIndicatorParent = cropNode3
        
        turnIndicatorParent.position.x -= 5
        backIndicator.position.x -= 5
        
        //Setup loser board
        loserBoard = SKSpriteNode(imageNamed: "Loserboard")
        loserBoard.size = scene.size * 0.65
        loserBoard.zPosition = U.zPosition8
        
        let tryAgainButton = ButtonNode(imageNamed: "TryAgain")
        tryAgainButton.size.width = loserBoard.size.width * 0.655
        tryAgainButton.size.height = loserBoard.size.height * 0.33
        tryAgainButton.position.y -= tryAgainButton.size.height/1.5
        tryAgainButton.zPosition = U.zPosition9
        tryAgainButton.action = {
            self.hideBoard(winner: false)
            self.scene.tryAgain()
        }
        loserBoard.addChild(tryAgainButton)
        
        scene.addChild(loserBoard)
        
        //Setup WINNER board
        winnerBoard = SKSpriteNode(imageNamed: "Winnerboard")
        winnerBoard.size = scene.size * 0.65
        winnerBoard.zPosition = U.zPosition8
        
        let continueButton = ButtonNode(imageNamed: "Continue")
        continueButton.size.width = loserBoard.size.width * 0.655
        continueButton.size.height = loserBoard.size.height * 0.33
        continueButton.position.y -= continueButton.size.height/1.5
        continueButton.zPosition = U.zPosition9
        continueButton.action = {
            self.hideBoard(winner: true)
            self.scene.keepGoing()
        }
        winnerBoard.addChild(continueButton)
        
        scene.addChild(winnerBoard)
        
        hideBoardPosition = winnerBoard.position
        hideBoardPosition.y += winnerBoard.size.height*2
        
        winnerBoard.position = hideBoardPosition
        loserBoard.position = hideBoardPosition
        
        addBackTo(at: p1Portrait.position, size: charBackNode.size*1.1, left: true)
        addBackTo(at: p2Portrait.position, size: charBackNode.size*1.1, left: false)

    }
    
    func addBackTo(at: CGPoint, size: CGSize, left: Bool) {
        let rectBack = SKSpriteNode(imageNamed: "Rect2")
        rectBack.size = size
        if left {
            rectBack.run(SKAction.colorize(with: scene.game.allPlayers[0].color[1], colorBlendFactor: 1, duration: 0))
        }else{
            rectBack.run(SKAction.colorize(with: scene.game.allPlayers[1].color[1], colorBlendFactor: 1, duration: 0))
        }
        rectBack.zPosition = U.zPosition2
        
        let cropNode = SKCropNode()
        let mask = SKSpriteNode(imageNamed: "Dot")
        mask.size = size
        cropNode.maskNode = mask
        cropNode.position = at
        cropNode.addChild(rectBack)
       
        scene.addChild(cropNode)
    }
    
    func setPoints(_ points: Int, to: Player) {
        
    }
    
    func switchTurns() {
        turnIndicatorParent.position.x *= -1
        backIndicator.position.x *= -1
        turnIndicator.zRotation += .pi
    }
    
    func showBoard(winner: Bool) {
        let moveAction = SKAction.move(to: .zero, duration: 0.35)
        moveAction.timingMode = .easeInEaseOut
        if winner {
            winnerBoard.run(moveAction)
            winAnimation()
        }else{
            loserBoard.run(moveAction)
        }
    }
    
    func hideBoard(winner: Bool) {
        if winner {
            winnerBoard.position = hideBoardPosition
        }else{
            loserBoard.position = hideBoardPosition
        }
    }
    
    func winAnimation() {
        let confettiParticle = SKEmitterNode(fileNamed: "Confetti")!
        confettiParticle.position.y += scene.size.height/1.5
        scene.addChild(confettiParticle)
        let wait = SKAction.wait(forDuration: 7.0)
        let removeConfetti = SKAction.removeFromParent()
        confettiParticle.run(SKAction.sequence([
            wait, removeConfetti
            ]))
    }
    
}
