//
//  PathGameScene.swift
//  DotsAndBoxes
//
//  Created by Giovanni Bruno on 27/03/18.
//  Copyright © 2018 Giovanni Bruno. All rights reserved.
//

import SpriteKit
import GameplayKit

public class PathGameScene: GameScene {
    
    var initialGraphNode = PathNode()
    var finalGraphNode = PathNode()
    var allNodes = [PathNode]()
    var graph = GKGraph()
    var connections = [PathNode]()
    
    override public func initialSetup() {
        super.initialSetup()
        
        initialGraphNode = PathNode()
        finalGraphNode = PathNode()
        allNodes = [PathNode]()
        graph = GKGraph()
        
        allNodes.append(initialGraphNode)
        allNodes.append(finalGraphNode)
        
        for i in 0..<markNodes.count {
            if markNodes[i].name == Mark.box.text() {
                if markNodes[i].index.j == 1 {
                    let graphNode = PathNode()
                    graphNode.index = markNodes[i].index
                    graphNode.addConnections(to: [finalGraphNode], bidirectional: true)
                    allNodes.append(graphNode)
                }else if markNodes[i].index.j == game.size - 2 {
                    let graphNode = PathNode()
                    graphNode.index = markNodes[i].index
                    graphNode.addConnections(to: [initialGraphNode], bidirectional: true)
                    allNodes.append(graphNode)
                }else {
                    let graphNode = PathNode()
                    graphNode.index = markNodes[i].index
                    allNodes.append(graphNode)
                }
                
            }
            
            graph.add(allNodes)
            
        }
        
    }
    
    func connection() -> [PathNode] {
        return graph.findPath(from: initialGraphNode, to: finalGraphNode) as! [PathNode]
    }
    
    override public func game(didClose box: Box, player: Player) {
        super.game(didClose: box, player: player)
        
        if player.playerId == 0 {
            let markNode = markNodes[box.index]
            //FIND THE GRAPH NODE THAT HAS THE SAME INDEX
            let result = findPathNodeAndNeighbors(for: markNode.index)
            
            for case let neighbor as PathNode in result.neighbors {
                let index = neighbor.index.j + neighbor.index.i * game.size
                for box in game.boxes {
                    if box.index == index && box.player?.playerId == 0 {
                        result.node.addConnections(to: [neighbor as GKGraphNode], bidirectional: true)
                    }
                }
            }
            
        }
        
        connections = self.connection()
        if connections.count > 0 {
            //RUN ANIMATIONS AND SHOW WINNERBOARD
            didWinAnimation()
        }
    }
    
    func findPathNodeAndNeighbors(for index: (i: Int, j: Int)) -> (node: PathNode, neighbors: [GKGraphNode]) {
        
        let ind1 = (i: index.i - 2, j: index.j)
        let ind2 = (i: index.i + 2, j: index.j)
        let ind3 = (i: index.i, j: index.j - 2)
        let ind4 = (i: index.i, j: index.j + 2)
        let indexes = [ind1, ind2 , ind3, ind4]
        
        var foundNeighbors = [GKGraphNode]()
        var foundNode: PathNode!
        
        for pathNode in allNodes {
            if pathNode.index == index {
                foundNode = pathNode
            }
            for ind in indexes {
                if game.indexIsWithinBounds(index: ind.j + ind.i * game.size) && pathNode.index == ind {
                    foundNeighbors.append(pathNode)
                }
            }
        }
        
        return (foundNode, foundNeighbors)
    }
    
    override public func setupEnemyTexture() {
        enemyTextureName = "VillainLazy"
    }
    
    override public func setupCutSceneActions() {
        let tb21 = "TB21"
        
        let heroTBPosition = CGPoint(x: heroNode.position.x + heroNode.size.width/3, y: heroNode.position.y)
        
        sceneHelper
            
            //START
            .addTextBox(to: self, named: tb21, at: heroTBPosition)
            //FINISH (1)
            
            //START
            .removeTextBox(from: self, named: tb21)
        //FINISH (1)
        
        numberOfActions.append(1)
        numberOfActions.append(1)
        
        playNext()
    }
    
    func didWinAnimation() {
        heroNode.zPosition = U.zPosition7
        var moves = [SKAction]()
        moves.append(SKAction.move(to: CGPoint(x: 0, y: heroNode.position.y), duration: 1.55))
        for c in connections {
            if c.index.i > -1 {
                let index = c.index.j + c.index.i * game.size
                moves.append(
                    SKAction.move(to: markNodes[index].position, duration: 0.5)
                )
            }
        }
        moves.append(SKAction.animate(with: [SKTexture(imageNamed: "HeroCelebrate")], timePerFrame: 0.1))
        moves.append(SKAction.wait(forDuration: 0.5))
        heroNode.run(SKAction.sequence(moves), completion: {
            self.game(didOverWith: self.game.allPlayers[0])
        })
    }
    
    override public func keepGoing() {
        if let view = self.view {
            guard let scene = CutScene(fileNamed: "CutScene") else {return}
            scene.sceneType = .finish
            scene.scaleMode = U.scaleMode
            view.presentScene(scene, transition: U.defaultTransition)
        }
    }
    
    override public func game(didOverWith winner: Player?) {
        if self.connection().count > 0 {
            super.game(didOverWith: game.allPlayers[0])
        }else{
            super.game(didOverWith: game.allPlayers[1])
        }
    }

    
    override public func closeBoxAnimation(green: Bool, markNode: MarkNode) {}
}
