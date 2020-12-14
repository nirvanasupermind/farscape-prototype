//
//  GameViewController.swift
//  GeometryFighter
//
//  Created by Nirvana Choudhury on 9/14/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupScene()
        self.setupCamera()
        self.spawnShape()
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
        
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        // 1
        var geometry:SCNGeometry
        // 2
        switch ShapeType.random() {
        case ShapeType.Cone:
            geometry = SCNCone(topRadius: 1.0, bottomRadius: 1.0, height: 1.0)
        case ShapeType.Capsule:
            geometry = SCNCapsule(capRadius: 1.0, height: 1.0)
        case ShapeType.Cylinder:
            geometry = SCNCylinder(radius: 1.0, height: 2.0)
        case ShapeType.Pyramid:
            geometry = SCNPyramid(width: 1.0, height: 2.0, length: 1.0)
        case ShapeType.Sphere:
            geometry = SCNSphere(radius: 1.0)
        default:
            // 3
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        }
        // 4
        let geometryNode = SCNNode(geometry: geometry)
        // 5
        scnScene.rootNode.addChildNode(geometryNode)
    }
    
}





//
//
//class GameViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // create and add a camera to the scene
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        scene.rootNode.addChildNode(cameraNode)
//
//        // place the camera
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
//
//        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
//
//        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient
//        ambientLightNode.light!.color = UIColor.darkGray
//        scene.rootNode.addChildNode(ambientLightNode)
//
//        // retrieve the ship node
//        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
//
//        // animate the 3d object
//        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
//
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//
//        // set the scene to the view
//        scnView.scene = scene
//
//        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = true
//
//        // show statistics such as fps and timing information
//        scnView.showsStatistics = true
//
//        // configure the view
//        scnView.backgroundColor = UIColor.black
//
//        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        scnView.addGestureRecognizer(tapGesture)
//    }
//
//    @objc
//    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//
//        // check what nodes are tapped
//        let p = gestureRecognize.location(in: scnView)
//        let hitResults = scnView.hitTest(p, options: [:])
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result = hitResults[0]
//
//            // get its material
//            let material = result.node.geometry!.firstMaterial!
//
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.5
//
//            // on completion - unhighlight
//            SCNTransaction.completionBlock = {
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 0.5
//
//                material.emission.contents = UIColor.black
//
//                SCNTransaction.commit()
//            }
//
//            material.emission.contents = UIColor.red
//
//            SCNTransaction.commit()
//        }
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//}
