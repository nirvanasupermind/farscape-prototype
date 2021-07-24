//
//  EarthNode.swift
//  3dEarth
//
//  Created by Nirvana Choudhury on 7/23/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import UIKit
import SceneKit

class EarthNode: SCNNode {
    override init() {
        super.init()
        self.geometry = SCNSphere(radius: 1)
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
