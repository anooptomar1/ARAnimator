//
//  ButtonsOverlay.swift
//  AR Animator
//
//  Created by Travis on 12/27/17.
//  Copyright © 2017 Travis. All rights reserved.
//

import UIKit
import SpriteKit

class ButtonsOverlay: SKScene {
    var playNode: SKSpriteNode!
    
    override init(size:CGSize) {
        super.init(size: size)
        
        self.backgroundColor = UIColor.clear
        
        let spriteSize = size.width/12
        self.playNode = SKSpriteNode(imageNamed: "playButton")
        self.playNode.size = CGSize(width: spriteSize, height: spriteSize)
        self.playNode.position = CGPoint(x: spriteSize + 8, y: spriteSize + 8)
        
        self.addChild(playNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        if self.playNode.contains(location!) {
            print("Play button pressed!")
        } else {
            print("Missed play button")
        }
    }
    
}
