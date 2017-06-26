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
        
        // Background
        self.backgroundColor = SKColor.lightGray
        
        bottom1.anchorPoint = CGPoint.zero
        bottom1.position = CGPoint.zero
        bottom1.zPosition = 1
        self.addChild(bottom1)
        
        bottom2.anchorPoint = CGPoint.zero
        bottom2.position = CGPoint(x: bottom1.size.width - 1, y: 0)
        bottom2.zPosition = 1
        self.addChild(bottom2)
        
        // Player
        player.position = CGPoint(x: player.size.width / 2, y: bottom1.size.height + player.size.height / 2)
        player.zPosition = 2
        self.addChild(player)
        
        // Clouds
        addCloud(named: "cloud1", at: CGPoint(x: self.size.width * 0.1, y: self.size.height * 0.8), scale: 1.5)
        addCloud(named: "cloud2", at: CGPoint(x: self.size.width * 0.6, y: self.size.height * 0.65), scale: 2)
        addCloud(named: "cloud3", at: CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.45), scale: 2.5)
    }
    
    func addCloud(named name: String, at position: CGPoint, scale: CGFloat) {
        let cloud = SKSpriteNode(imageNamed: "Wolke")
        cloud.name = name
        cloud.position = position
        cloud.setScale(scale)
        cloud.zPosition = 1
        self.addChild(cloud)
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.zRotation -= CGFloat.pi * 5 / 180
        
        // Move floor
        bottom1.position.x -= 4
        bottom2.position.x -= 4
        
        if bottom1.position.x < -bottom1.size.width {
            bottom1.position.x = bottom2.position.x + bottom2.size.width
        } else if bottom2.position.x < -bottom2.size.width {
            bottom2.position.x = bottom1.position.x + bottom1.size.width
        }
        
        // Move clouds
        let cloud1 = childNode(withName: "cloud1") as! SKSpriteNode
        let cloud2 = childNode(withName: "cloud2") as! SKSpriteNode
        let cloud3 = childNode(withName: "cloud3") as! SKSpriteNode
        
        cloud1.position.x += 1.5
        cloud2.position.x += 2
        cloud3.position.x += 1
        
        let clouds = [cloud1, cloud2, cloud3]
        for cloud in clouds {
            if cloud.position.x > self.size.width + cloud.size.width / 2 {
                cloud.position.x = 0 - cloud.size.width / 2
            }
        }
    }
}
