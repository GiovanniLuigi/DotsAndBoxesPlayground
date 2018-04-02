
//
//  CutScene.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 27/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import Foundation
import SpriteKit

public class CutScene: SKScene {
    
    let sceneHelper = CutSceneHelper()
    
    var hero: SKSpriteNode!
    var villain: SKSpriteNode!
    var cameraNode: SKCameraNode!
    
    var heroTB: SKNode!
    var villainTB: SKNode!
    
    var numberOfActions = [Int]()
    var playCount = 0
    
    var done = true
    
    var heroCameraPositionX: CGFloat!
    var heroCameraPositionY: CGFloat!
    var heroCameraPostion: CGPoint!
    var villainCameraPositionX: CGFloat!
    var villainCameraPositionY: CGFloat!
    var villainCameraPostion: CGPoint!
    
    public var sceneType: SceneType = .normal
    
    var background: SKSpriteNode!
    
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        background = childNode(withName: "bg") as! SKSpriteNode
        
        //SETUP CHARS
        hero = childNode(withName: "hero") as! SKSpriteNode
        villain = childNode(withName: "villain") as! SKSpriteNode
        
        heroTB = childNode(withName: "heroTB")
        villainTB = childNode(withName: "villainTB")
        
        //SETUP CAMERA
        cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
        
        //SETUP ACTIONS
        heroCameraPositionX = hero.position.x + size.width/1.7 - hero.size.width*1.05
        heroCameraPositionY = 0.0
        heroCameraPostion = CGPoint(x: heroCameraPositionX, y: heroCameraPositionY)
        
        villainCameraPositionX = villain.position.x - size.width/1.7 + villain.size.width*1.05
        villainCameraPositionY = 0.0
        villainCameraPostion = CGPoint(x: villainCameraPositionX, y: villainCameraPositionY)
        
        setupActions(for: sceneType)
    }
    
    func setupActions(for sceneType: SceneType) {
        switch sceneType {
        case .normal:
            setupNormalActions()
        case .collectTrash:
            setupCollectActions()
        case .findPath:
            setupPathActions()
        case .photo:
            setupPhotoActions()
        case .finish:
            setupFinishActions()
        }
        playBackgroundMusic(filename: "Julie_Maxwells_Piano_Music_-_17_-_Lost_Forest.mp3")
    }
    
    func setupNormalActions() {
        let tb1 = "TB1"
        let tb2 = "TB2"
        let tb3 = "TB3"
        let tb4 = "TB4"
        let tb5 = "TB5"
        
        let heroAngry = SKTexture(imageNamed: "HeroAngry")
        let heroWorried = SKTexture(imageNamed: "HeroWorried")

        sceneHelper
            
            //Start
            .moveBy(hero, y: -hero.size.height*1.5, with: 0)
            .moveBy(villain, y: -villain.size.height*1.5, with: 0)
            .move(cameraNode, to: villainCameraPostion, with: 1.5)
            .move(cameraNode, to: heroCameraPostion, with: 0.7)
            .moveBy(hero, y: hero.size.height*1.5, with: 0.55)
            .shake(hero)
            .animate(hero, to: heroWorried)
            .addTextBox(to: self, named: tb1, at: heroTB.position)
            //Finish (8)
            
            //START
            .removeTextBox(from: self, named: tb1)
            .animate(hero, to: heroAngry)
            .addTextBox(to: self, named: tb2, at: heroTB.position)
            //FINISH (3)
            
            //Start
            .removeTextBox(from: self, named: tb2)
            .move(cameraNode, to: villainCameraPostion)
            .moveBy(villain, y: villain.size.height*1.5, with: 0.55)
            .shake(villain)
            .addTextBox(to: self, named: tb3, at: villainTB.position, left: false)
            //Finish (5)
            
//            //START
//            .removeTextBox(from: self, named: tb3)
//            .addTextBox(to: self, named: tb4, at: villainTB.position, left: false)
//            //FINISH (2)
            
            //Start
            .removeTextBox(from: self, named: tb3)
            .move(cameraNode, to: heroCameraPostion, with: 0.45)
            .addTextBox(to: self, named: tb5, at: heroTB.position)
            //Finish (3)
            
            //Start
            .run(self, block: {
                let gameScene = GameScene(size: self.view!.bounds.size)
                gameScene.scaleMode = U.scaleMode
                self.view!.presentScene(gameScene, transition:U.defaultTransition)
            })
            //Finish (1)
        
        //REGISTER THE NUMBER OF ACTIONS PER PLAY
        numberOfActions.append(8)
        numberOfActions.append(3)
        numberOfActions.append(5)
//        numberOfActions.append(2)
        numberOfActions.append(3)
        numberOfActions.append(1)
        
        
        //START ACTIONS
        playNext()
        
    }
    
    func setupCollectActions() {
        let tb10 = "TB10"
        let tb11 = "TB11"
        let tb12 = "TB12"
        let tb13 = "TB13"
        let tb14 = "TB14"
        
        let heroCelebrate = SKTexture(imageNamed: "HeroCelebrate")
        let heroSad = SKTexture(imageNamed: "HeroSad")
        let heroAngry = SKTexture(imageNamed: "HeroAngry")
        
        villain.texture = SKTexture(imageNamed: "VillainTrash")
        villain.position.x += villain.size.width * 0.1
        
        background.texture = SKTexture(imageNamed: "Background2")
        background.size = CGSize(width: 1300, height: 1200)
        background.position = CGPoint(x: -10, y: 200)
        
        sceneHelper
            
            //Start
            .moveBy(hero, y: -hero.size.height*1.5, with: 0)
            .moveBy(villain, y: -villain.size.height*1.5, with: 0)
            .move(cameraNode, to: villainCameraPostion, with: 1.5)
            .move(cameraNode, to: heroCameraPostion, with: 0.7)
            .moveBy(hero, y: hero.size.height*1.5, with: 0.55)
            .shake(hero)
            .animate(hero, to: heroCelebrate)
            .addTextBox(to: self, named: tb10, at: heroTB.position)
            //Finish (8)
            
            //START
            .removeTextBox(from: self, named: tb10)
            .animate(hero, to: heroSad)
            .addTextBox(to: self, named: tb11, at: heroTB.position)
            //FINISH (3)
            
            //Start
            .removeTextBox(from: self, named: tb11)
            .move(cameraNode, to: villainCameraPostion)
            .moveBy(villain, y: villain.size.height*1.5, with: 0.55)
            .shake(villain)
            .addTextBox(to: self, named: tb12, at: villainTB.position, left: false)
            //Finish (5)
            
//            //START
//            .removeTextBox(from: self, named: tb12)
//            .addTextBox(to: self, named: tb13, at: villainTB.position, left: false)
//            //FINISH (2)
            
            //Start
            .removeTextBox(from: self, named: tb12)
            .move(cameraNode, to: heroCameraPostion, with: 0.45)
            .animate(hero, to: heroAngry)
            .addTextBox(to: self, named: tb14, at: heroTB.position)
            //Finish (4)
            
            //Start
            .run(self, block: {
                let gameScene = CoinGameScene(size: self.view!.bounds.size)
                gameScene.scaleMode = U.scaleMode
                self.view!.presentScene(gameScene, transition:U.defaultTransition)
            })
        //Finish (1)
        
        //REGISTER THE NUMBER OF ACTIONS PER PLAY
        numberOfActions.append(8)
        numberOfActions.append(3)
        numberOfActions.append(5)
//        numberOfActions.append(2)
        numberOfActions.append(4)
        numberOfActions.append(1)
        
        
        //START ACTIONS
        playNext()
    }
    
    func setupPathActions() {
        let tb17 = "TB17"
        let tb18 = "TB18"
        let tb19 = "TB19"
        let tb20 = "TB20"
        
        let heroCelebrate = SKTexture(imageNamed: "HeroCelebrate")
        let heroSad = SKTexture(imageNamed: "HeroSad")
        let heroAngry = SKTexture(imageNamed: "HeroAngry")
        
        villain.texture = SKTexture(imageNamed: "VillainLazy")
        villain.position.x += villain.size.width * 0.1
        
        background.texture = SKTexture(imageNamed: "Background3")
        background.size = CGSize(width: 1300, height: 1200)
        background.position = CGPoint(x: -10, y: 200)
        
        sceneHelper
            
            //Start
            .moveBy(hero, y: -hero.size.height*1.5, with: 0)
            .moveBy(villain, y: -villain.size.height*1.5, with: 0)
            .move(cameraNode, to: villainCameraPostion, with: 1.5)
            .move(cameraNode, to: heroCameraPostion, with: 0.7)
            .moveBy(hero, y: hero.size.height*1.5, with: 0.55)
            .shake(hero)
            .animate(hero, to: heroCelebrate)
            .addTextBox(to: self, named: tb17, at: heroTB.position)
            //Finish (8)
            
            //START
            .removeTextBox(from: self, named: tb17)
            .animate(hero, to: heroSad)
            .addTextBox(to: self, named: tb18, at: heroTB.position)
            //FINISH (3)
            
            //Start
            .removeTextBox(from: self, named: tb18)
            .move(cameraNode, to: villainCameraPostion)
            .moveBy(villain, y: villain.size.height*1.5, with: 0.55)
            .shake(villain)
            .addTextBox(to: self, named: tb19, at: villainTB.position, left: false)
            //Finish (5)
            
            //Start
            .removeTextBox(from: self, named: tb19)
            .move(cameraNode, to: heroCameraPostion, with: 0.45)
            .animate(hero, to: heroAngry)
            .addTextBox(to: self, named: tb20, at: heroTB.position)
            //Finish (4)
            
            //Start
            .run(self, block: {
                let gameScene = PathGameScene(size: self.view!.bounds.size)
                gameScene.scaleMode = U.scaleMode
//                gameScene.level = 13
                self.view!.presentScene(gameScene, transition:U.defaultTransition)
            })
        //Finish (1)
        
        //REGISTER THE NUMBER OF ACTIONS PER PLAY
        numberOfActions.append(8)
        numberOfActions.append(3)
        numberOfActions.append(5)
        numberOfActions.append(4)
        numberOfActions.append(1)
        
        
        //START ACTIONS
        playNext()
    }
    
    func setupPhotoActions() {
        
    }
    
    func setupFinishActions() {
        let tb22 = "TB22"
        let tb23 = "TB23"
        let tb24 = "TB24"
        let tb25 = "TB25"
        
        let heroCelebrate = SKTexture(imageNamed: "HeroCelebrate")
        let heroHappy = SKTexture(imageNamed: "HeroHappy")
        
        villain.texture = SKTexture(imageNamed: "VillainLazy")
        villain.position.x += villain.size.width * 0.1
        
        background.texture = SKTexture(imageNamed: "Background4")
        background.size = CGSize(width: 1300, height: 1200)
        background.position = CGPoint(x: -10, y: 200)
        
        sceneHelper
            
            //Start
            .moveBy(hero, y: -hero.size.height*1.5, with: 0)
            .moveBy(villain, y: -villain.size.height*1.5, with: 0)
            .move(cameraNode, to: villainCameraPostion, with: 1.5)
            .move(cameraNode, to: heroCameraPostion, with: 0.7)
            .moveBy(hero, y: hero.size.height*1.5, with: 0.55)
            .shake(hero)
            .animate(hero, to: heroCelebrate)
            .addTextBox(to: self, named: tb22, at: heroTB.position)
            //Finish (8)
            
            //START
            .removeTextBox(from: self, named: tb22)
            .animate(hero, to: heroHappy)
            .addTextBox(to: self, named: tb23, at: heroTB.position)
            //FINISH (3)
            
            //Start
            .removeTextBox(from: self, named: tb23)
            .move(cameraNode, to: heroCameraPostion, with: 0.45)
            .addTextBox(to: self, named: tb24, at: heroTB.position)
            //Finish (3)
        
            //Start
            .removeTextBox(from: self, named: tb24)
            .addTextBox(to: self, named: tb25, at: heroTB.position)
            //Finish (2)
        
            //Start
            .run(self, block: {
                let gameScene = VSGameScene(size: self.view!.bounds.size)
                gameScene.scaleMode = U.scaleMode
                gameScene.aiEnabled = false
                gameScene.hasIntro = false
                //                gameScene.level = 13
                self.view!.presentScene(gameScene, transition:U.defaultTransition)
            })
            //Finish (1)
        
        //REGISTER THE NUMBER OF ACTIONS PER PLAY
        numberOfActions.append(8)
        numberOfActions.append(3)
        numberOfActions.append(3)
        numberOfActions.append(2)
        numberOfActions.append(1)
        
        //START ACTIONS
        playNext()
    }
    
    
    func playNext() {
        if playCount < numberOfActions.count && done {
            done = false
            sceneHelper.play(numberOfInteractions: numberOfActions[playCount], completion: {
                self.done = true
            })
            playCount += 1
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playNext()
    }
    
}
