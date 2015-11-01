//
//  MainScene.swift
//  Flappy Bird Clone
//
//  Created by Tran Huu Tam on 11/1/15.
//  Copyright © 2015 Benjaminsoft. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene : SKScene {
    
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
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
