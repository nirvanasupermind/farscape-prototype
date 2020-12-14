//
//  GameViewController.swift
//  Solar-system
//
//  Created by Nirvana Choudhury on 10/8/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit


extension String {
    func charAt(_ x: Int) -> String {
        if(x > self.count-1) {
            return ""
        } else {
            return Array(self)[x].description
        }
    }
    func substr(_ x: ClosedRange<Int>) -> String {
        var result = ""
        var i: Int = x.min()!-1
        while(i < x.max()!) {
            i += 1
            result = result+self.charAt(i)
        }
        
        return result
        
    }
    
    
    
}

class GameViewController: UIViewController {
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var planetData: [[String:String]] = []
    var moonData: [[String:String]] = []
    var starData: [String:String] = [:]
    
    
    var nodeDict: [String:SCNNode] = [:]
    
    var geometryDict: [String:SCNSphere] = [:]
    
    
    
    
    
    
    var exoplanetName: String = "Exoplanet Name    "
    
    var sysname: String = "Kepler-20"
    
    var sysname2: String {
        if(sysname == "Sun") {
            return "Sol"
        } else {
            return sysname
        }
    }
    
    
    func getRadius(_ m: Double) -> Double {
        if(m < 1) {
            return pow(m,0.3)
        } else if(m < 200) {
            return pow(m,0.5)
        } else {
            return 22.6*pow(m,-0.0886)
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.planetData = loadJson(fileName: "core_planet_1")!.filter { $0["Star Name           "] == sysname  }
        print(sysname2)
        self.moonData = loadJson(fileName: "core_moon_1")!.filter { $0["Alternate Name"]!.contains(sysname2) || $0["Moon Name"]!.contains(sysname2)}
        
        self.starData = loadJson(fileName: "core_star_1")!.filter { $0["Star Name           "]! == sysname }[0]
        
        print(self.starData)
        
        
        self.setupView()
        self.setupScene()
        self.setupCamera()
        
        var star: SCNNode = SCNNode()
        var stellarRadius: Double = sqrt(parseDouble(starData["Stellar Radius(Rsun) "]!))
        var stellarMass: Double = parseDouble(starData["Stellar Mass(Msun) "]!)
        if(stellarMass == Double.nan) {
            stellarMass = pow(stellarRadius,1.25)
        }
        
        if(stellarRadius == Double.nan) {
            stellarRadius = pow(parseDouble(starData["Stellar Mass(Msun) "]!),0.8)
        }
        
        
        star.geometry = SCNSphere(radius: 2.0*CGFloat(parseDouble(starData["Stellar Radius(Rsun) "]!)))
        star.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "g-star")
        scnScene.rootNode.addChildNode(star)
        
        nodeDict[sysname] = star
        geometryDict[sysname] = star.geometry as! SCNSphere
        spawnText(1.0, name: sysname, SCNVector3Make(0, 0, 0.5))
        for i in 0...planetData.count-1 {
            
            var radius: Double = parseDouble(planetData[i]["Radius (Rjup / Re)"]!)/0.0892
            
            if(radius == 0.0 || radius.isNaN) {
                radius = getRadius(parseDouble(planetData[i]["Mass   (Mjup / Me)"]!)/0.0031)
            }
            
            var semiMajor: Double = parseDouble(planetData[i]["Semi Major Axis / Orbital Distance Calculated"]!)
            
            if(semiMajor.isNaN || semiMajor == 0.0) {
                semiMajor = getOrbit(parseDouble(planetData[i]["Orbital Period(Observed/Estimated)"]!), parseDouble(starData["Stellar Mass(Msun) "]!))
            }
    
            
            
            
            //            print((parseDouble(planetData[i]["Orbital Period(Observed/Estimated)"]!), parseDouble(starData["Stellar Mass(Msun) "]!)))
            spawnPlanet(name: planetData[i][exoplanetName]!, parseDouble(planetData[i]["Radius (Rjup / Re)"]!)/0.0892, planetData[i][exoplanetName]!, semiMajor, i)
        }
        
        
        
        if(moonData.count > 0) {
            for i in 0...moonData.count-1 {
                var radius: Double = parseDouble(moonData[i]["Radius (Re)"]!)
                if(radius == 0.0 || radius.isNaN) {
                    radius = getRadius(parseDouble(moonData[i]["Mass (Me)"]!))
//                    radius = 1.0
                }
                spawnMoon(name: moonData[i]["Moon Name"]!, radius, moonData[i]["Moon Name"]!, parseDouble(moonData[i]["Semi Major Axis / Orbital Distance Calculated"]!), moonData[i]["Planet Name"]!)
//                        print((name: moonData[i]["Moon Name"]!, radius, moonData[i]["Moon Name"]!, parseDouble(moonData[i]["Semi Major Axis / Orbital Distance Calculated"]!), moonData[i]["Planet Name"]!))
            }
            
        }
        //Center at the star
        
        
        
        
        
        SCNTransaction.commit()
        
        
    }
    
    func getOrbit(_ m: Double, _ o: Double) -> Double {
        return cbrt(m)*pow(o,2/3)
        
    }
    
    
    func loadJson(fileName: String) -> [[String:String]]? {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let planet = try? decoder.decode([[String:String]].self, from: data)
            else {
                return nil
                
        }
        
        return planet
    }
    
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnScene.background.contents = UIColor.black
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.black
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    var defaultPos: SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    var count: Int = 0
    func getTextNode(_ x: SCNNode) -> SCNNode {
        
        var keys: [String] = [String](nodeDict.keys)
        var values: [String] = [SCNNode](nodeDict.values).map{ $0.description }
        var index: Int = values.firstIndex(of: x.description)!
        var name: String = keys[index]
        if(name.contains("Text")) {
            return nodeDict[name]!
        }
        
        var pos = nodeDict[name]!.position
        var size = geometryDict[name]!.radius
        
        var textNode: SCNNode = SCNNode()
               textNode.geometry = SCNText(string: name, extrusionDepth: 0.5)
               var scale: Double = 0.05
               textNode.scale = SCNVector3Make(Float(scale),Float(scale),Float(scale))
               textNode.position = SCNVector3(x:pos.x+2.0+pow(Float(size),2/3),y:pos.y,z:pos.z)
               scnScene.rootNode.addChildNode(textNode)
        
        return nodeDict[name + " Text"] ?? textNode
    }
    @objc

    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                self.count += 1
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                var tappNode = result.node
                var textNode = self.getTextNode(tappNode)
                let lookAtConstraint = SCNLookAtConstraint.init(target: textNode)
                lookAtConstraint.isGimbalLockEnabled = true
                scnView.pointOfView?.constraints = [lookAtConstraint]
                material.emission.contents = UIColor.black
                
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    func parseDouble(_ x: String) -> Double {
        if(Double(x.charAt(0)) ?? 1.7976931348623157e+308 == 1.7976931348623157e+308) {
            return Double(x.substr(1...x.count))!
        }  else if(Double(x) ?? 1.7976931348623157e+308 == 1.7976931348623157e+308 ) {
            return Double.nan
        } else {
            return Double(x)!
        }
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        var zFar: Double = parseDouble(planetData.last!["Semi Major Axis / Orbital Distance Calculated"]!)*70
        //cameraNode.position = SCNVector3(x: 0, y: 0, z: Float(z))
        
        //cameraNode.camera?.fieldOfView = CGFloat(80.0)
        
        
        var semiMajor: Double = Double(planetData.count*20)
        
        

        var z: Double = semiMajor*2
        if(z.isNaN) {
            z = 100
        }
        
     
    
        cameraNode.position = SCNVector3(x: 0, y: 0, z: Float(z))
        defaultPos = cameraNode.position
        cameraNode.camera?.yFov = 40
        cameraNode.camera?.zFar = 1000
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    
    func rotateObject(_ rotation: Float, _ planet: SCNNode, _ duration: Double) {
        let rotation = SCNAction.rotateBy(x: 0.0, y: CGFloat(rotation), z: 0.0, duration: TimeInterval(duration))
        planet.runAction(SCNAction.repeatForever(rotation))
    }
    
    func spawnText(_ size: Double, name: String, _ pos: SCNVector3) {
        var textNode: SCNNode = SCNNode()
        textNode.geometry = SCNText(string: name, extrusionDepth: 0.5)
        var scale: Double = 0.05
        textNode.scale = SCNVector3Make(Float(scale),Float(scale),Float(scale))
        textNode.position = SCNVector3(x:pos.x+2.0+pow(Float(size),2/3),y:pos.y,z:pos.z)
        scnScene.rootNode.addChildNode(textNode)
        nodeDict[name + " Text"] = textNode
        
    }
    func spawnPlanet(name: String, _ radius: Double, _ texture: String, _ ringSize: Double, _ index: Int) {
        var theNode: SCNNode = SCNNode()
        theNode.geometry = SCNSphere(radius: CGFloat(pow(radius,1/3)))
        var temp: Double = Double(index*20+10)
        
        
        theNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: texture)
        theNode.position = SCNVector3(x:0,y:0,z: Float(temp))
        theNode.name = name
        let ring = SCNTorus(ringRadius: CGFloat(temp), pipeRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.darkGray
        
        ring.materials = [material]
        
        let ringNode = SCNNode(geometry: ring)
        rotateObject(0.4, theNode, 0.4)
        rotateObject(0.4, ringNode, ringSize)
        spawnText(radius, name: name, theNode.position)
        
        scnScene.rootNode.addChildNode(theNode)
        scnScene.rootNode.addChildNode(ringNode)
        
        
        nodeDict[name] = theNode
        geometryDict[name] = theNode.geometry as! SCNSphere
        
        
        
        
        
    }
    
    func spawnMoon(name: String, _ radius: Double, _ texture: String, _ ringSize: Double, _ planet: String) {
        var theNode: SCNNode = SCNNode()
        theNode.geometry = SCNSphere(radius: CGFloat(2.0*pow(radius,0.4)))
        if(radius < 0.03) {
            theNode.scale = SCNVector3(x: 1, y: 1, z: 1.5)
        }
        theNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: texture)
        
        
        var ringRadius = CGFloat(ringSize/5e+4)
        if(ringSize < 5e+4) {
            ringRadius = CGFloat(pow(ringSize,0.65)/100)
        }
        
        
        theNode.position = SCNVector3(x:0,y:0,z:  nodeDict[planet]!.position.z+Float(ringRadius))
        let ring = SCNTorus(ringRadius: ringRadius, pipeRadius: 0.01)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.darkGray
        
        ring.materials = [material]
        
        
        let ringNode = SCNNode(geometry: ring)
        
        
        ringNode.position = nodeDict[planet]!.position
        
        rotateObject(0.4, theNode, 0.4)
        rotateObject(0.4, ringNode, ringSize)
        spawnText(radius, name: name, theNode.position)
        
        
        
        scnScene.rootNode.addChildNode(theNode)
        scnScene.rootNode.addChildNode(ringNode)
        
        nodeDict[name] = theNode
        geometryDict[name] = theNode.geometry as! SCNSphere
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}


