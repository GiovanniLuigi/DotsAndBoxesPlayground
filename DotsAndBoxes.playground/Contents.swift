
/*
 
    Hello!
    It was made to run on the iPad Pro 12.9-inch display in full screen landscape, but it can be run on mac as well. Hope you like it
 
    There are three different maps in this game, each has a similar game mechanic but has different win conditions.
 
    The mechanics is like this: tap between the dots to create a line between the dots. The player who creates the last line to form a box has this box for himself.

 
    1 - In the first map wins who has more boxes (Case of tie the machine wins).
 
    2 - In the second you only win if you have all the boxes that have garbage in it.
 
    3 - In the third you win if you create a vertical path of boxes that connects the two ends of the board.
 
 ---------
 
    Audio used is free
 
    Inspiration by BoxCat Games
    License can be found at:
    http://freemusicarchive.org/music/BoxCat_Games/Nameless_the_Hackers_RPG_Soundtrack/BoxCat_Games_-_Nameless-_the_Hackers_RPG_Soundtrack_-_07_Inspiration
 
    Lost Forest by Julie Maxwell's Piano Music
    License can be found at:
    http://freemusicarchive.org/music/Julie_Maxwells_Piano_Music/Classic_Piano_Collection_from_the_Princess_of_Mars/Julie_Maxwells_piano_music_-_Classic_Piano_Collection_from_the_Princess_of_Ma_-_17_Lost_Forest
 
 ---------
 
 */

import PlaygroundSupport
import SpriteKit

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))

if let scene = CutScene(fileNamed: "CutScene.sks")  {
    scene.sceneType = .normal
    scene.scaleMode = .aspectFill
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
