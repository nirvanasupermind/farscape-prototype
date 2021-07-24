//
//  SolarSystem.swift
//  procedural-universe
//
//  Created by Nirvana Choudhury on 2/13/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import Foundation

class SolarSystem: Equatable, Hashable, CustomStringConvertible {
    static func == (lhs: SolarSystem, rhs: SolarSystem) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
    
    var description: String {
        var t1 = self.star.description.components(separatedBy:"\n").map { "\t\t"+$0 }.joined(separator: "\n")
        return """
        \(type(of: self))
        Star:
        \(t1)
        Planets:
        \(self.planets.map { $0.description.components(separatedBy:"\n").map { "\t\t"+$0 }.joined(separator: "\n") } .joined(separator: "\n"))
        """
    }
    
    var star: Star = Star()
    var planets: [Planet] = []
    var uuid: String = UUID().uuidString
    
    static func rand(_ star: Star = Star.randHost()) -> SolarSystem {
        var result: SolarSystem = SolarSystem()
        result.star = star
        result.planets.append(Planet.rand(result.star,-1.0,"\(star.name) 1"))
        
        let innerLimit: Double = 0.1*result.star.mass
        let outerLimit: Double = 40.0*result.star.mass
        let len: Int = random(1,7)
        
        var i: Int = 0
        var dist: Double = result.planets[0].distance
        
        while(i < len && dist <= outerLimit) {
            i += 1
            dist *= random(1.4,2)
        result.planets.append(Planet.rand(result.star,dist,"\(star.name) \(i+1)"))
        }
        
        return result
    }
    
    
    
    
    
    
    
    
    
    
}
