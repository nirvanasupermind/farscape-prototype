//
//  PlanetNode.swift
//  farscape-prototype-scn
//
//  Created by Nirvana Choudhury on 9/24/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import UIKit
import SceneKit

class PlanetNode: SCNNode {
    init(_ texture: String, _ radius: CGFloat, pos: SCNVector3) {
        super.init()
        self.geometry = SCNSphere(radius: radius)
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named: texture)
        self.position = pos
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
