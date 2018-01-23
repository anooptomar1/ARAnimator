//
//  Object.swift
//  AR Animator
//
//  Created by Travis on 12/27/17.
//  Copyright © 2017 Travis. All rights reserved.
//

// Code is under development

/*
import UIKit
import SceneKit

class Object {
    let animLength = 100
    
    let animProperties: [String] = ["position", "rotation", "scale"]

    // MARK: Properties
    var name: String
    var node: SCNNode!
    var animations = Dictionary<String, CAKeyFrameAnimation>
    
    init?(name: String, node: SCNNode) {
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.node = node
        
        setupAnimations()
    }
    
    func insertKey(frameNo: Int, attribute: String, vec3: SCNVector3, vec4: SCNVector4) {
        if !animProperties.contains(attribute) {
            fatalError("Attribute to be keyed does not exist")
        }
        
        if attribute == "rotation" {
            
        } else {
        
        }
    }
    
    
    private func setupAnimations() {
        animations = [String: CAKeyframeAnimation]()
        animations["position"] = CAKeyframeAnimation(keyPath: "position")
        animations["rotation"] = CAKeyframeAnimation(keyPath: "rotation")
        animations["scale"] = CAKeyframeAnimation(keyPath: "scale")
    }
    
    // frameNo is passed in as 0, ..., 100
    // The keyTimes are stored as 0.0, ..., 1.0, so conversion is necessary
    func getKeyTimeIndex(array: [Float], frameNo: Float) -> Float {
        let keyTime = frameNo / animLength
        
        // index = index of array, value = keyTime keyframe value
        for (index, value) in array.enumerated() {
            if value == keyTime {
                array[index] = keyTime
            } else if value > keyTime {
                
            }
        }
    }

}
*/
