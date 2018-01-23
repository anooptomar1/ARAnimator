//
//  ViewController.swift
//  AR Animator
//
//  Created by Travis on 12/22/17.
//  Copyright © 2017 Travis. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var frameSlider: UISlider!
    @IBOutlet weak var frameNoLabel: UILabel!
    
    var currFrame: Float!
    
    // Frames start at 0, end at 100
    // FPS: 25, so duration = 4 sec
    
    var startFrame = 0
    var numFrames = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        setupFrameSlider()
        setupFrameLabel()
        
        let boxNode = createBox(0, 0, -0.4)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = [SCNVector3Make(0, 0, -0.4),
                            SCNVector3Make(3, 0, -0.4)]
        
        animation.keyTimes = [0, 1]
        animation.duration = 4
        
        let scnAnimation = SCNAnimation(caAnimation: animation)
        
        let animationPlayer = SCNAnimationPlayer(animation: scnAnimation)
        
        boxNode.addAnimationPlayer(animationPlayer, forKey: "position")
        
        sceneView.scene.rootNode.addChildNode(boxNode)

        addLight()
        
        
        // Add gestures to scene view
        addTapGestureToSceneView()
        addPinchGestureToSceneView()
        addPanGestureToSceneView()
        
        playButton.addTarget(self, action: #selector(playButtonTapped(button:)), for: .touchUpInside)
    }
    
    // MARK: Setup UI
    func setupFrameLabel() {
        frameNoLabel.text = String(frameSlider.value)
    }
    
    func setupFrameSlider() {
        frameSlider.minimumValue = Float(startFrame)
        frameSlider.maximumValue = Float(numFrames)
        frameSlider.value = Float(round(Double(startFrame)))
    }
    
    // MARK: UI Actions
    @objc
    func playButtonTapped(button: UIButton) {
        print("Button tapped")
        
        guard let boxNode = sceneView.scene.rootNode.childNode(withName: "boxNode", recursively: false) else {
            return
        }
        guard let animationPlayer = boxNode.animationPlayer(forKey: "position") else {
            return
        }
        
        animationPlayer.play()
    }
    
    @IBAction func frameSliderValueChanged(_ sender: UISlider) {
        let roundedVal = round(sender.value)
        sender.value = roundedVal
        frameNoLabel.text = String(roundedVal)
    }
    
    func createBox(_ x_pos: Float, _ y_pos: Float, _ z_pos: Float) -> SCNNode {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.firstMaterial!.diffuse.contents = UIColor(red: 0.85, green: 0.07, blue: 0.12, alpha: 1.0)
        let boxNode = SCNNode()
        boxNode.simdScale = float3(1.0)
        boxNode.geometry = box
        boxNode.simdPosition = float3(x_pos, y_pos, z_pos)
        boxNode.name = "boxNode"

        return boxNode
    }
    
    
    func addLight() {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = .omni
        omniLightNode.light!.color = UIColor(red: 0.7, green: 0.6, blue: 0.1, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0.5, 0.5, 0.5)
        sceneView.scene.rootNode.addChildNode(omniLightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 0.5)
        sceneView.scene.rootNode.addChildNode(ambientLightNode)
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func handleTap(_ recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        if hitTestResults.count > 0 {
            let resultNode = hitTestResults[0].node
            resultNode.geometry!.firstMaterial!.diffuse.contents = UIColor.blue
        } else {
            // Here we're adding a new object
            
            // Set the z-depth (in camera view) for the new object
            let zDepth = Float(0.99689)
            
            // Setup the 3D point in world space
            let tapInWorld = sceneView.unprojectPoint(SCNVector3Make(Float(tapLocation.x),
                                                                            Float(tapLocation.y),
                                                                            zDepth))

            
        }
    }
    
    func addPinchGestureToSceneView() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc
    func handlePinch(_ recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        // Check if we hit something
        if hitTestResults.count > 0 {
            // Grab the first result
            let result = hitTestResults[0]
            let pinchRecognizer = recognizer as! UIPinchGestureRecognizer
            result.node.simdScale = float3(Float(pinchRecognizer.scale))
        }
    }
    
    func addPanGestureToSceneView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panGestureRecognizer)
    }
    
    var projectedNode = SCNVector3()
    
    @objc
    func handlePan(_ recognizer: UIGestureRecognizer) {
        let panRecognizer = recognizer as! UIPanGestureRecognizer
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        // Check if we hit something
        if hitTestResults.count > 0 {
            
            // Grab the first result
            let resultNode = hitTestResults[0].node
            
            if recognizer.state == .began {
                projectedNode = sceneView.projectPoint(resultNode.position)
            }

            // We only want to move the object when the finger is moving
            if recognizer.state == .changed {
                // Grab the depth of the object
                let zDepth = projectedNode.z
                
                // panTranslation is the distance from the original point that the finger has moved
                let panTranslation = panRecognizer.translation(in: sceneView)
                
                // Translate the projected node in screen space coords
                let newProjectedNode = SCNVector3Make(projectedNode.x + Float(panTranslation.x),
                                                      projectedNode.y + Float(panTranslation.y),
                                                      zDepth)
                
                // Now, unproject back into world space
                resultNode.position = sceneView.unprojectPoint(newProjectedNode)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
