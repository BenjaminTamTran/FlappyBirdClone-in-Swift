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
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    
    // Game property
    var bird = SKSpriteNode()
    var skyColor = SKColor()
    var pipeTexture1 = SKTexture()
    var pipeTextTure2 = SKTexture()
    var moving = SKNode()
    var pipes = SKNode()
    var canRestart = false
    
    override init(size: CGSize) {
        super.init(size: size)
        canRestart = false
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        self.physicsWorld.contactDelegate = self
        
        skyColor = SKColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        let birdTexture1 = SKTexture(imageNamed: "Bird1")
        let birdTexture2 = SKTexture(imageNamed: "Bird2")
        birdTexture1.filteringMode = SKTextureFilteringMode.Nearest
        birdTexture2.filteringMode = SKTextureFilteringMode.Nearest
        // define flap ation
        let flapAction = SKAction .animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction .repeatActionForever(flapAction)
        
        // create bird node
        bird = SKSpriteNode(texture: birdTexture1)
        bird .setScale(3.0)
        bird.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame))
        bird.runAction(flap)
        
        // set physic body
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        self .addChild(bird)
        
        // create main node
        self .addChild(moving)
        // add node of Pipes
        moving .addChild(pipes)
        
        let groundTexture = SKTexture(imageNamed: "Ground")
        groundTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        let moveGroundSprite = SKAction .moveByX(-groundTexture.size().width*2, y: 0, duration: 0.02 * Double(groundTexture.size().width) * 2.0)
        let resetGroundSprite = SKAction .moveByX(groundTexture.size().width*2, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction .repeatActionForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))
        
        for (var i = 0; i < 2 + Int(self.frame.size.width / (groundTexture.size().width * 2)) ; i++) {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(CGFloat(i) * sprite.size.width, sprite.size.height / 2)
            sprite .runAction(moveGroundSpritesForever)
            moving .addChild(sprite)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // SKPhysicsContactDelegate's methods
    func didBeginContact(contact: SKPhysicsContact) {
    
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bird.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame))
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 4))
    }
}
