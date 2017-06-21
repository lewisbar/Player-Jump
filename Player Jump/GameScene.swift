//
//  GameScene.swift
//  Player Jump
//
//  Created by Lennart Wisbar on 21.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let bottom1 = SKSpriteNode(imageNamed: "Bottom")
    let bottom2 = SKSpriteNode(imageNamed: "Bottom")
    
    let player = SKSpriteNode(imageNamed: "Player")
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.lightGray
        
        bottom1.anchorPoint = CGPoint.zero
        bottom1.position = CGPoint.zero
        bottom1.zPosition = 1
        self.addChild(bottom1)
        
        bottom2.anchorPoint = CGPoint.zero
        bottom2.position = CGPoint(x: bottom1.size.width - 1, y: 0)
        bottom2.zPosition = 1
        self.addChild(bottom2)
        
        player.position = CGPoint(x: player.size.width / 2, y: bottom1.size.height + player.size.height / 2)
        player.zPosition = 2
        self.addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.zRotation -= CGFloat.pi * 5 / 180
    }
}
