//
//  StartScene.swift
//  Player Jump
//
//  Created by Lennart Wisbar on 21.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    let startButton = SKSpriteNode(imageNamed: "Playbutton")
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.lightGray
        
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(startButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let userPosition = touch.location(in: self)
            
            if atPoint(userPosition) == startButton {
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene)
            }
        }
    }
}
