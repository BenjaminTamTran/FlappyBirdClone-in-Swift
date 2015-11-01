//
//  ViewController.swift
//  Flappy Bird Clone
//
//  Created by Tran Huu Tam on 11/1/15.
//  Copyright © 2015 Benjaminsoft. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var backgroundMusic = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let audioFileLocationURL = NSBundle.mainBundle() .URLForResource("MiningbyMoonlight", withExtension: "mp3")
        backgroundMusic = try! AVAudioPlayer.init(contentsOfURL: audioFileLocationURL!)
        backgroundMusic .play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

