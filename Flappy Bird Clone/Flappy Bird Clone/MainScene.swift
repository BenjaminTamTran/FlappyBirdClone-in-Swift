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
    let kVerticalPipeGap: CGFloat = 100.0
    
    // Game property
    var bird = SKSpriteNode()
    var skyColor = SKColor()
    var pipeTextTure1 = SKTexture()
    var pipeTextTure2 = SKTexture()
    var moving = SKNode()
    var pipes = SKNode()
    var canRestart = false
    var resetSound = SKAction()
    var swapSound = SKAction()
    var movePipesAndRemove = SKAction()
    
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
        bird .setScale(2.0)
        bird.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame))
        bird.runAction(flap)
        
        // set physic body
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        self .addChild(bird)
        
        // create main node
        self .addChild(moving)
        // add node of Pipes
        moving .addChild(pipes)
        
        let groundTexture = SKTexture(imageNamed: "Ground")
        groundTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        let moveGroundSprite = SKAction .moveByX(-groundTexture.size().width * 2, y: 0, duration: 0.02 * Double(groundTexture.size().width) * 2.0)
        let resetGroundSprite = SKAction .moveByX(groundTexture.size().width * 2, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction .repeatActionForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))
        
        for (var i = 0; i < 2 + Int(self.frame.size.width / (groundTexture.size().width * 2)) ; i++) {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(CGFloat(i) * sprite.size.width, sprite.size.height / 2)
            sprite .runAction(moveGroundSpritesForever)
            moving .addChild(sprite)
        }
        
        // Skyeline
        let skylineTexture = SKTexture(imageNamed: "Skyline")
        skylineTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        let moveSkyelineSprite = SKAction .moveByX(-skylineTexture.size().width * 2, y: 0, duration: 0.1 * Double(skylineTexture.size().width * 2))
        let resetSkyelineSprite = SKAction.moveByX(skylineTexture.size().width * 2, y: 0, duration: 0)
        let moveSkylelineSpriteForever = SKAction .repeatActionForever(SKAction.sequence([moveSkyelineSprite, resetSkyelineSprite]))
    
        for (var i = 0; i < 2 + Int(self.frame.size.width / (skylineTexture.size().width * 2)) ; i++) {
            let sprite = SKSpriteNode(texture: skylineTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -10
            sprite.position = CGPointMake(CGFloat(i) * sprite.size.width, sprite.size.height / 2 + groundTexture.size().height * 2)
            sprite .runAction(moveSkylelineSpriteForever)
            moving .addChild(sprite)
        }
        
        // Create ground physics container
        let dummyGround = SKNode()
        dummyGround.position = CGPointMake(0, groundTexture.size().height)
        dummyGround.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2))
        dummyGround.physicsBody?.dynamic = false
        dummyGround.physicsBody?.categoryBitMask = worldCategory
        self .addChild(dummyGround)
        
        // Create pipes
        pipeTextTure1 = SKTexture(imageNamed: "Pipe1")
        pipeTextTure1.filteringMode = SKTextureFilteringMode.Nearest
        pipeTextTure2 = SKTexture(imageNamed: "Pipe2")
        pipeTextTure2.filteringMode = SKTextureFilteringMode.Nearest
        
        let distanceToMove = self.frame.size.width + 2 * pipeTextTure1.size().width
        let movePipes = SKAction .moveByX(-distanceToMove, y: 0, duration: 0.01 * Double(distanceToMove))
        let removePipes = SKAction .removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // action Spwan Pipes with selector
        let spawn = SKAction .performSelector(Selector("spawnPipes"), onTarget: self)
        let delay = SKAction .waitForDuration(2.0)
        let spwanThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction .repeatActionForever(spwanThenDelay)
        self .runAction(spawnThenDelayForever)
        
        resetSound = SKAction .playSoundFileNamed("Chomp.wav", waitForCompletion: false)
        swapSound = SKAction .playSoundFileNamed("Ka-Ching", waitForCompletion: false)
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeTextTure1.size().width, 0)
        pipePair.zPosition = -5
        
        let y = CGFloat(arc4random_uniform(UInt32(self.frame.size.height / 3)))
        
        let pipe1 = SKSpriteNode(texture: pipeTextTure1)
        pipe1 .setScale(2.0)
        pipe1.position = CGPointMake(0, y)
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        pipe1.physicsBody?.categoryBitMask = pipeCategory
        pipe1.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipe1)
        
        let pipe2 = SKSpriteNode(texture: pipeTextTure2)
        pipe2 .setScale(2.0)
        pipe2.position = CGPointMake(0, y + pipe1.size.height + kVerticalPipeGap)
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        pipe2.physicsBody?.categoryBitMask = pipeCategory
        pipe2.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipe2)
        
        let contactNode = SKNode()
        contactNode.position = CGPointMake(pipe1.size.width + bird.size.width / 2, CGRectGetMidY(self.frame))
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe2.size.width, self.frame.size.height))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair .runAction(movePipesAndRemove)
        pipes .addChild(pipePair)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if value > max {
            return max
        } else if value < min {
            return min
        } else {
            return value
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if( moving.speed > 0 ) {
            bird.zRotation = clamp( -1, max: 0.5, value: (bird.physicsBody?.velocity.dy)! * ( (bird.physicsBody?.velocity.dy)! < 0 ? 0.003 : 0.001 ) )
//            print("bird.zRotation \(bird.zRotation)")
        }
    }
    
    func resetScene() {
        bird.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame))
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0
        
        pipes .removeAllChildren()
        
        canRestart = false
        
        moving.speed = 1
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if moving.speed > 0 {
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 4))
            self .runAction(swapSound)
        } else if canRestart {
            resetScene()
        }
    }
    
    // SKPhysicsContactDelegate's methods
    func didBeginContact(contact: SKPhysicsContact) {
        if moving.speed > 0 {
            if contact.bodyA.categoryBitMask & worldCategory == worldCategory || contact.bodyB.categoryBitMask & worldCategory == worldCategory{
                self .runAction(resetSound)
                moving.speed = 0
                bird.physicsBody?.collisionBitMask = worldCategory
                let actionRotate = SKAction .rotateByAngle(CGFloat(M_PI) * bird.position.y * CGFloat(0.01), duration: Double(bird.position.y) * 0.003)
                bird .runAction(actionRotate, completion: { () -> Void in
                    self.bird.speed = 0
                    self.runAction(self.resetSound)
                })
                canRestart = true
            }
        }
    }
}
