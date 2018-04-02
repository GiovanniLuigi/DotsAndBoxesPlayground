import SpriteKit
import GameplayKit

public class GameScene: SKScene, GameDelegate {
    public let lastPlayedColor = U.lightYellow
    public var blockSize: CGFloat {
        return size.width/CGFloat(self.level*2)
    }
    public var game: Game = Game()
    public var ai: AI!
    public var hud: HUD!
    
    public var lastPlayed: (player: Player, node: MarkNode)?
    public var markNodes: [MarkNode]!
    public var closedBoxes: [Box]!
    public var level: Int = 9
    public var resetAction: () -> Void = {}
    
    public var aiEnabled = true
    
    public var heroNode: SKSpriteNode!
    public var villainNode: SKSpriteNode!
    
    public var enemyTextureName: String = "VillainSaw"
    
    let sceneHelper = CutSceneHelper()
    
    var numberOfActions = [Int]()
    var playCount = 0
    
    var done = true
    
    var hasIntro: Bool = true
    
    var moveFlies = [SKAction]()
    var moveFlyTowardsPlayerP1: SKAction!
    var moveFlyTowardsPlayerP2: SKAction!
    let scaleAction = SKAction.scale(to: 1, duration: 0.1)
    let scale2Action = SKAction.scale(to: 1, duration: 0.25)
    let scale3Action = SKAction.scale(to: 1, duration: 0.5)
    let removeAction = SKAction.removeFromParent()
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupEnemyTexture()

        game.initialSetup(size: level)
        game.delegate = self
        hud = HUD(scene: self)
        initialSetup()
        setupBg()
        if hasIntro {
            setupCutSceneActions()
        }
        createMoveFirefliesActions()
        playBackgroundMusic(filename: "BoxCat_Games_-_07_-_Inspiration.mp3")
    }
    
    public func setupBg() {
        backgroundColor = U.lightGrey
        let bg = SKSpriteNode(imageNamed: "Background1")
        setBgSize(bg: bg)
        addChild(bg)
    }
    
    public func setBgSize(bg: SKSpriteNode) {
        bg.zPosition = U.zPosition1
        bg.size = view!.bounds.size*1.15
        bg.alpha = 0.3
        bg.name = "bg"
    }
    
    public func setupEnemyTexture(){
        enemyTextureName = "VillainSaw"
    }
    
    public func initialSetup() {
        
        setupAI()
        setupResetAction()
        
        for c in children {
            if c.name != "bg"{
                c.removeFromParent()
            }
        }
        
        hud.initialSetup()
        
        //Add players texture to the scene
        heroNode = SKSpriteNode(imageNamed: "HeroHappy")
        villainNode = SKSpriteNode(imageNamed: enemyTextureName)
        
        heroNode.size = heroNode.size/14.15
        heroNode.position = hud.p1Portrait.position
        heroNode.position.y *= -1
        heroNode.zPosition = U.zPosition9
        
        addChild(heroNode)
        
        villainNode.size = villainNode.size/11
        villainNode.position = hud.p2Portrait.position
        villainNode.position.y *= -1
        villainNode.zPosition = U.zPosition9
        
        addChild(villainNode)
        
        //Finish
        
        markNodes = [MarkNode]()
        closedBoxes = [Box]()
        lastPlayed = nil
        
        let offset: CGFloat = 0
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let back = SKSpriteNode(imageNamed: "Rect")
        back.size = CGSize(width: blockSize*CGFloat(level)*1.2, height: blockSize*CGFloat(level)*1.2)
        back.zPosition = U.zPosition2
        back.alpha = 0.99
        addChild(back)
        
        for i in 0..<game.size {
            for j in 0..<game.size {
                let node = MarkNode()
                node.texture = texture(for: (i,j))
                node.name = name(for: (i,j))
                node.index = (i,j)
                node.zPosition = U.zPosition5
                
                node.size = CGSize(width: blockSize, height: blockSize)
                
                if node.name == Mark.box.text() {
                    node.size *= 2.0
                    node.zPosition = U.zPosition4
                }
                
                if node.name == Mark.dot.text() {
                    node.size = CGSize(width: blockSize * 0.25, height: blockSize * 0.25)
                    node.zPosition = U.zPosition6
                    node.color = U.lightGrey
                }
                
                node.position.x = CGFloat(i) * blockSize + offset
                node.position.y = -1 * CGFloat(j) * blockSize - offset
                
                node.position.x -= blockSize*CGFloat(game.size-1)/2
                node.position.y += blockSize*CGFloat(game.size-1)/2
                
                addChild(node)
                
                markNodes.append(node)
            }
        }
        
        //addResetButton()
    }
    
    func setupAI() {
        ai = DefaultGameMediumAI(gameModel: game)
    }
    
    func setupResetAction (){
        resetAction = {
            self.game.initialSetup(size: self.game.size)
            self.initialSetup()
        }
    }
    
    public func texture(for index: (i: Int, j:Int)) -> SKTexture? {
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
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if playCount >= numberOfActions.count && done {
            guard let p = touches.first?.location(in: self) else {return}
            if aiEnabled && game.currentPlayer.playerId != 0 {return}
            if let node = nodes(at: p).first as? MarkNode {
                if node.name == Mark.notMarked.text() {
                    makePlay(node: node)
                }
            }
        }else{
            playNext()
        }
    }
    
    public func makePlay(node: MarkNode) {
        if let lastPlayed = self.lastPlayed {
            lastPlayed.node.run(SKAction.colorize(with: lastPlayed.player.color[1], colorBlendFactor: 1, duration: 0))
        }
        
        let index = node.index
        
        if index.i % 2 == 0 {
            node.size = CGSize(width:  blockSize * 0.1, height: blockSize * 2.0)
        }else{
            node.size = CGSize(width: blockSize * 2.0, height: blockSize * 0.1)
        }
        node.name = Mark.markedH.text()
        node.setScale(0)
        node.run(SKAction.colorize(with: lastPlayedColor, colorBlendFactor: 1, duration: 0))
        node.run(self.scaleAction, completion: {
            self.lastPlayed = (self.game.currentPlayer, node)
            
            self.game.apply(Move(index: node.index.j + node.index.i * self.game.size))
            
            if self.game.currentPlayer.playerId != 0 && self.aiEnabled {
                let randomWait = Double.random(min: 0.25, max: 1.65)
                let waitAction = SKAction.wait(forDuration: randomWait)
                let makePlayAction = SKAction.run {
                    if let move = self.ai.bestMove() {
                        self.makePlay(node:  self.markNodes[move.index])
                    }
                }
                self.run(SKAction.sequence([waitAction, makePlayAction]))
                
                //                if let move = self.ai.bestMove() {
                //                    self.makePlay(node:  self.markNodes[move.index])
                //                }
            }
        })
    }
    
    
    public func didCloseBox(box b: Box) {
        //RUN CLOSE ANIMATION
        let mark = markNodes[b.index]
        mark.setScale(0)
        mark.run(SKAction.colorize(with: game.currentPlayer.color[0], colorBlendFactor: 1, duration: 0))
//        mark.run(SKAction.scale(to: 1, duration: 0.25))
        mark.run(self.scale2Action)
    }
    
    public func game(didClose box: Box, player: Player) {
        //ADD BOX TO CLOSED BOXES
        if !closedBoxes.contains(box){
            closedBoxes.append(box)
        }
        didCloseBox(box: box)
        if player.playerId == 0 {
            closeBoxAnimation(green: true, markNode: markNodes[box.index])
        }else{
            closeBoxAnimation(green: false, markNode: markNodes[box.index])
            
        }
    }
    
    public func game(didOverWith winner: Player?) {
        if winner?.playerId == 0 {
            hud.showBoard(winner: true)
        }else{
            hud.showBoard(winner: false)
        }
    }
    
    public func game(didSwitchTurn to: Player) {
        hud.switchTurns()
    }
    
    public func tryAgain() {
        resetAction()
    }
    
    public func keepGoing(){
        if let view = self.view {
            guard let scene = CutScene(fileNamed: "CutScene") else {return}
            scene.sceneType = .collectTrash
            scene.scaleMode = U.scaleMode
            view.presentScene(scene, transition: U.defaultTransition)
        }
    }
    
    public func createMoveFirefliesActions() {
        let flyVariance: Double = 200
        for _ in 0..<10 {
        let moveFly = SKAction.moveBy(x: CGFloat(Double.random(min: -flyVariance, max: flyVariance)), y: CGFloat(Double.random(min: -flyVariance, max: flyVariance)), duration: Double.random())
            moveFlies.append(moveFly)
        }
        let moveFlyTowardsPlayerGreen = SKAction.move(to: self.hud.p1Portrait.position, duration: Double.random(min: 0, max: 1.5))
        let moveFlyTowardsPlayerRed = SKAction.move(to: self.hud.p2Portrait.position, duration: Double.random(min: 0, max: 1.5))
        moveFlyTowardsPlayerP1 = moveFlyTowardsPlayerGreen
        moveFlyTowardsPlayerP2 = moveFlyTowardsPlayerRed
    }
    
    public func closeBoxAnimation(green: Bool, markNode: MarkNode) {
        let sizeInMark = CGSize(width: self.blockSize*1.75, height: self.blockSize*1.75)
        if green {
            let addFlyAction = SKAction.run({
                let fly = SKSpriteNode(imageNamed: "Firefly1")
                let s = self.blockSize/4
                fly.size = CGSize(width: s, height: s)
                fly.position = markNode.position
                fly.color = U.darkYellow
                fly.zPosition = 100
                let glowSprite = SKSpriteNode()
                glowSprite.size = fly.size
                glowSprite.color = U.lightYellow
                fly.addGlow(glowSprite: glowSprite)
                fly.setScale(0)
                self.addChild(fly)
                
                
                fly.run(SKAction.sequence([
                    self.scaleAction,
                    self.moveFlies[Int.random(self.moveFlies.count)],
                    self.moveFlyTowardsPlayerP1,
                    self.removeAction]))
            })
            markNode.run(SKAction.repeat(addFlyAction, count: 4))
            
            let treeNode = SKSpriteNode(imageNamed: "Tree1")
            treeNode.position = markNode.position
            treeNode.size = sizeInMark
            treeNode.setScale(0)
            treeNode.zPosition = U.zPosition7
            addChild(treeNode)
            
            treeNode.run(self.scale3Action)
        }else {
            let addFlyAction = SKAction.run({
                let fly = SKSpriteNode(imageNamed: "Firefly2")
                let s = self.blockSize/4
                fly.size = CGSize(width: s, height: s)
                fly.position = markNode.position
                fly.color = U.darkRed
                fly.zPosition = 100
                let glowSprite = SKSpriteNode()
                glowSprite.size = fly.size
                glowSprite.color = U.lightRed
                fly.addGlow(glowSprite: glowSprite)
                fly.setScale(0)
                self.addChild(fly)
                
                fly.run(SKAction.sequence([
                    self.scaleAction,
                    self.moveFlies[Int.random(self.moveFlies.count)],
                    self.moveFlyTowardsPlayerP2,
                    self.removeAction]))
            })
            markNode.run(SKAction.repeat(addFlyAction, count: 4))
            
            let stumpNode = SKSpriteNode(imageNamed: "Stump")
            stumpNode.position = markNode.position
            stumpNode.size = sizeInMark
            stumpNode.setScale(0)
            stumpNode.zPosition = U.zPosition7
            addChild(stumpNode)
            
            stumpNode.run(self.scale3Action)
        }
    }
    
    func setupCutSceneActions() {
        let tb6 = "TB6"
        let tb7 = "TB7"
        let tb8 = "TB8"
        let tb9 = "TB9"
        
        let heroTBPosition = CGPoint(x: heroNode.position.x + heroNode.size.width/3, y: heroNode.position.y)
        
        sceneHelper
            
            //START
            .addTextBox(to: self, named: tb6, at: heroTBPosition)
            //FINISH (1)
        
            //START
            .removeTextBox(from: self, named: tb6)
            .addTextBox(to: self, named: tb7, at: heroTBPosition)
            //FINISH (2)
        
            //START
            .removeTextBox(from: self, named: tb7)
            .addTextBox(to: self, named: tb8, at: heroTBPosition)
            //FINISH (2)
            
            //START
            .removeTextBox(from: self, named: tb8)
            .addTextBox(to: self, named: tb9, at: heroTBPosition)
            //FINISH (2)
        
            //START
            .removeTextBox(from: self, named: tb9)
            //FINISH (1)
        
        numberOfActions.append(1)
        numberOfActions.append(2)
        numberOfActions.append(2)
        numberOfActions.append(2)
        numberOfActions.append(1)
        
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

}
