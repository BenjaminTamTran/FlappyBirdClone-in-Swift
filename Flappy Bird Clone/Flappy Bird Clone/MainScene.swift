//
//  MainScene.swift
//  Flappy Bird Clone
//
//  Created by Tran Huu Tam on 11/1/15.
//  Copyright © 2015 Benjaminsoft. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene : SKScene, SKPhysicsContactDelegate {
    
    // Game category
    let birdCategory = 1 << 0
    let worldCategory = 1 << 1
    let pipeCategory = 1 << 2
    let scoreCategory = 1 << 3
    
    
    // Game property
    var bird = SKSpriteNode()
    var skyColor = SKColor()
    var pipeTexture1 = SKTexture()
    var pipeTextTure2 = SKTexture()
    var canRestart = false
    
    override init(size: CGSize) {
        super.init(size: size)
        canRestart = false;
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        self.physicsWorld.contactDelegate = self
        
        skyColor = SKColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // SKPhysicsContactDelegate's methods
    func didBeginContact(contact: SKPhysicsContact) {
    
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
}
