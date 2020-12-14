//
//  ViewController.swift
//  ThreeDEarth
//
//  Created by Nirvana Choudhury on 9/23/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        let sceneView = self.view as! SCNView
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
        //        sceneView.autoenablesDefaultLighting = true
        let lightNode: SCNNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x:0,y:10,z:2)
        
        let lightNode2: SCNNode = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light?.type = .ambient
        lightNode2.position = SCNVector3(x:0,y:10,z:2)
        
        
        
        let imgs: [String] = ["terrestrial_1","terrestrial_2","terrestrial_3"]
        let planet: PlanetNode = PlanetNode(imgs.randomElement()!, 2.0, pos: SCNVector3(0,0,0))
       
        
        scene.background.contents = "space-background.png"

        


        
        
        
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(lightNode2)
        scene.rootNode.addChildNode(planet)
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    
    
}


