//
//  GameScene.swift
//  Player Jump
//
//  Created by Lennart Wisbar on 21.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Nodes
    let ground1 = SKSpriteNode(imageNamed: "Bottom")
    let ground2 = SKSpriteNode(imageNamed: "Bottom")
    let player = SKSpriteNode(imageNamed: "Player")
    let replayButton = SKSpriteNode(imageNamed: "Playbutton")
    
    // Jumping
    var playerIsOnTheGround = true
    var jumpVelocity: CGFloat = 0
    var jumpAudioPlayer: AVAudioPlayer!
    
    var wallSpeed: CGFloat = 5
    
    struct BitMasks {
        static let player: UInt32 = 0b1
        static let wall: UInt32 = 0b10
    }
    
    override func didMove(to view: SKView) {
        
        // Physics
        self.physicsWorld.contactDelegate = self
        
        // Background
        self.backgroundColor = SKColor.lightGray
        
        // Ground
        ground1.anchorPoint = CGPoint.zero
        ground1.position = CGPoint.zero
        ground1.zPosition = 1
        self.addChild(ground1)
        
        ground2.anchorPoint = CGPoint.zero
        ground2.position = CGPoint(x: ground1.size.width - 1, y: 0)
        ground2.zPosition = 1
        self.addChild(ground2)
        
        // Player
        player.position = CGPoint(x: player.size.width, y: ground1.size.height + player.size.height / 2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = BitMasks.player
        player.physicsBody?.contactTestBitMask = BitMasks.wall
        self.addChild(player)
        
        // Clouds
        addCloud(named: "cloud1", at: CGPoint(x: size.width * 0.1, y: size.height * 0.8), scale: 1.5)
        addCloud(named: "cloud2", at: CGPoint(x: size.width * 0.6, y: size.height * 0.65), scale: 2)
        addCloud(named: "cloud3", at: CGPoint(x: size.width * 0.5, y: size.height * 0.45), scale: 2.5)
        
        // Audio
        prepareJumpSound()
        
        // Wall
        addWall(named: "wall1", xScale: 1, yScale: 1.5, xPoint: 0)
        
        // Button
        replayButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.4)
        replayButton.zPosition = 3
        replayButton.run(SKAction.hide())
        self.addChild(replayButton)
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.zRotation -= CGFloat.pi * 5 / 180
        moveGroundLeft(points: 4)
        moveCloudsRight(cloud1Speed: 1.5, cloud2Speed: 2, cloud3Speed: 1)
        updateJumpMotion(slowDown: 0.6)
        updateWallMotion()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if children.contains(player), playerIsOnTheGround {
            initiateJump(initialVelocity: 16)
            return
        }
        
        for touch in touches {
            let fingerLocation = touch.location(in: self)
            if atPoint(fingerLocation) == replayButton {
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene)
            }
        }
    }
    
    // PhysicsContact
    func didBegin(_ contact: SKPhysicsContact) {
//        var playerBody: SKPhysicsBody
//        var wallBody: SKPhysicsBody
//
//        if contact.bodyA == player.physicsBody, contact.bodyB.contactTestBitMask == BitMasks.wall {
//            playerBody = contact.bodyA
//            wallBody = contact.bodyB
//        } else if contact.bodyB == player.physicsBody, contact.bodyB.contactTestBitMask == BitMasks.wall {
//            playerBody = contact.bodyB
//            wallBody = contact.bodyA
//        } else {
//            return
//        }
        
        player.removeFromParent()
        addGameOverFire()
        addGameOverLabel()
        replayButton.run(SKAction.unhide())
    }
    
    func addCloud(named name: String, at position: CGPoint, scale: CGFloat) {
        let cloud = SKSpriteNode(imageNamed: "Wolke")
        cloud.name = name
        cloud.position = position
        cloud.setScale(scale)
        cloud.zPosition = 1
        self.addChild(cloud)
    }
    
    func addWall(named name: String, xScale: CGFloat, yScale: CGFloat, xPoint: CGFloat) {
        let wall = SKSpriteNode(imageNamed: "Balken")
        wall.name = name
        wall.xScale = xScale
        wall.yScale = yScale
        wall.anchorPoint = .zero
        wall.position = CGPoint(x: self.size.width + (2 * wall.size.width) + xPoint, y: ground1.size.height - 16)
        wall.zPosition = 2
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size, center: CGPoint(x: wall.size.width / 2, y: wall.size.height / 2))
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = BitMasks.wall
        wall.physicsBody?.contactTestBitMask = BitMasks.player
        self.addChild(wall)
    }
    
    func addGameOverLabel() {
        let label = SKLabelNode(text: "Game Over")
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        label.fontSize = self.size.height / 18
        label.fontColor = SKColor.black
        label.zPosition = 3
        self.addChild(label)
    }
    
    func addGameOverFire() {
        let fire = SKEmitterNode(fileNamed: "Fire.sks")
        fire?.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        fire?.zPosition = 2
        self.addChild(fire!)
    }
    
    func moveGroundLeft(points: CGFloat) {
        ground1.position.x -= points
        ground2.position.x -= points
        
        if ground1.position.x < -ground1.size.width {
            ground1.position.x = ground2.position.x + ground2.size.width
        } else if ground2.position.x < -ground2.size.width {
            ground2.position.x = ground1.position.x + ground1.size.width
        }
    }
    
    func moveCloudsRight(cloud1Speed: CGFloat, cloud2Speed: CGFloat, cloud3Speed: CGFloat) {
        let cloud1 = childNode(withName: "cloud1") as! SKSpriteNode
        let cloud2 = childNode(withName: "cloud2") as! SKSpriteNode
        let cloud3 = childNode(withName: "cloud3") as! SKSpriteNode
        
        cloud1.position.x += cloud1Speed
        cloud2.position.x += cloud2Speed
        cloud3.position.x += cloud3Speed
        
        let clouds = [cloud1, cloud2, cloud3]
        for cloud in clouds {
            if cloud.position.x > self.size.width + cloud.size.width / 2 {
                cloud.position.x = 0 - cloud.size.width / 2
            }
        }
    }
    
    func initiateJump(initialVelocity: CGFloat) {
        jumpVelocity = initialVelocity
        playerIsOnTheGround = false
        jumpAudioPlayer.play()
        jumpAudioPlayer.prepareToPlay()
    }
    
    func updateJumpMotion(slowDown: CGFloat) {
        jumpVelocity -= slowDown
        player.position.y += jumpVelocity
        if player.position.y <= ground1.size.height {
            player.position.y = ground1.size.height
            jumpVelocity = 0
            playerIsOnTheGround = true
        }
    }
    
    func updateWallMotion() {
        let wall = childNode(withName: "wall1") as! SKSpriteNode
        wall.position.x -= wallSpeed
        if wall.position.x < (0 - wall.size.width) {
            wall.position.x = self.size.width + (2 * wall.size.width) + 20
            wall.yScale = CGFloat(arc4random_uniform(UInt32(2.5))) + 0.5
            wallSpeed = CGFloat(arc4random_uniform(UInt32(6))) + 4
        }
    }
    
    func prepareJumpSound() {
        let jumpAudioURL = Bundle.main.url(forResource: "Jump", withExtension: "wav")
        do {
            jumpAudioPlayer = try AVAudioPlayer(contentsOf: jumpAudioURL!)
        } catch {
            print("Audio file not found")
        }
        jumpAudioPlayer.numberOfLoops = 1
        jumpAudioPlayer.prepareToPlay()
    }
}
