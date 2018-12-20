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
        
        // Shapes
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let sphere = SCNSphere(radius: 0.2)
        // Red
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        cube.materials = [material]
        sphere.materials = [material]
        
        // Node; Position
        let cubeNode = SCNNode()
        cubeNode.position = SCNVector3(0, 0.1, -0.5) // in meters, so 0.1 = 10cm
        cubeNode.geometry = cube
        
        let sphereNode = SCNNode()
        sphereNode.position = SCNVector3(0.1, 0, 0.5)
        sphereNode.geometry = sphere
        
        // Add to Scene with Lighting
        sceneView.scene.rootNode.addChildNode(cubeNode)
        sceneView.autoenablesDefaultLighting = true
        
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
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
