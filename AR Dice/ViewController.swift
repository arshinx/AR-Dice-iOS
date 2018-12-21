//
//  ViewController.swift
//  AR Dice
//
//  Created by Arshin Jain on 12/19/18.
//  Copyright © 2018 Arshin Jain. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // Properties
    var diceArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Shapes and Materials
        let sphere = SCNSphere(radius: 0.2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
        sphere.materials = [material]
        
        // Position
        let sphereNode = SCNNode()
        sphereNode.position = SCNVector3(0, 0.1, -0.5)
        sphereNode.geometry = sphere
        
        // Add to Scene with Lighting
        //sceneView.scene.rootNode.addChildNode(sphereNode)
        sceneView.autoenablesDefaultLighting = true
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Horizontal Plane Detection
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // Receive User Touches and Convert to Real World Location
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // detect if touches were really detected
        if let touch = touches.first {
            
            // get first touch
            let touchLocation = touch.location(in: sceneView)
            
            // converts touch on screen to 3D world location
            let results = sceneView.hitTest(touchLocation, types: .existingPlane)
            
            // Use Found Coordinate and Place Dice
            if let hitResult = results.first {
                
                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                // Create Dice Node for Pos.
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    
                    // Assign found position to dice
                    diceNode.position = SCNVector3(
                        hitResult.worldTransform.columns.3.x,
                        hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        hitResult.worldTransform.columns.3.z
                    )
                    
                    roll(dice: diceNode)
                    
                    diceArray.append(diceNode)
                    
                    // Set the scene to the view
                    sceneView.scene.rootNode.addChildNode(diceNode)
                }
            }
            
            if !results.isEmpty {
                print("Got a position: \(results.description)")
            } else {
                print("Touched somewhere else!")
            }
        }
    }
    
    // --- ----- ---
    // Mark: Helpers
    
    // Helper - Roll
    func rollAll() {
        
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        
        // Rotate Dice along x-axis
        let randomX = Float(arc4random_uniform(4)) + 1 * (Float.pi/2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(randomX * 5),
            y: 0,
            z: CGFloat(randomZ * 5),
            duration: 0.5)
        )
    }
    
    // --- ----- ---
    // Mark: Actions
    
    // Roll Again Button
    @IBAction func rollAgain(_ sender: Any) {
        rollAll()
    }
    
    // Shake Phone to roll dice
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    // Removes all Dice
    @IBAction func removeAllDice(_ sender: Any) {
        
    }
    
    // --- --- ----- --- ---
    // Mark: Plane Detection
    
    // Detect Horizontal Plane in real world
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // Create plane and turn it 90* to make it horizontal
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            // Grid Material
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            // Assign Material
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            // Add to scene
            node.addChildNode(planeNode)
            
            
        } else {
            return
        }
    }

}
