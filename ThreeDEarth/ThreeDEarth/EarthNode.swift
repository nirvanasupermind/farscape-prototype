//
//  EarthNode.swift
//  ThreeDEarth
//
//  Created by Nirvana Choudhury on 9/23/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import UIKit
import SceneKit

class EarthNode: SCNNode {
    override init() {
        super.init()
        self.geometry = SCNSphere(radius: 2.0)
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Diffuse")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
