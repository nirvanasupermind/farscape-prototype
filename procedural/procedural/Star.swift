//
//  Star.swift
//  procedural
//
//  Created by Nirvana Choudhury on 1/8/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import Foundation

enum TempUnit {
    case C
    case K
}

enum TempType {
    case M
    case K
    case G
    case F
    case A
    case B
}

enum MassType: String {
    case giant = "giant"
    case dwarf = "dwarf"
}


struct StarType: CustomStringConvertible {
    var description: String {
        return "\(x) \(y.rawValue)"
    }
    var x: TempType
    var y: MassType
}

class Star: AstronomicalObject {
    var luminosity: Double {
        return pow(self.temp,3.5)
    }
    

    
    //Factory methods
    func randomMDwarf() {
        
    }
  
    
}
