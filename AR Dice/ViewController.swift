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
        sceneView.scene.rootNode.addChildNode(sphereNode)
        sceneView.autoenablesDefaultLighting = true
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        /*
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        // Create Dice Node for Pos.
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(0, 0, 0)
            // Set the scene to the view
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
         */
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

}
