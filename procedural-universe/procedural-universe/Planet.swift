//
//  Planet.swift
//  procedural-universe
//
//  Created by Nirvana Choudhury on 2/11/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import Foundation

enum PlanetType: String {
    case terrestrial = "Terrestrial planet"
    //    case waterworld = "Waterworld"
    case iceGiant = "Ice giant"
    case gasGiant = "Gas giant"
}


class Planet: Body {
    override var description: String {
        return super.description+"""
        
            Type: \(self.type.rawValue)
            Orbital Distance: \(myRound(self.distance)) AU
            Gravity: \(myRound(self.gravity)) G
            Star: \(self.star.shortDesc)
            Density: \(myRound(self.density)) g/cm^3
        """
    }
    
    //    var pressure: Double = 0.0
    var type: PlanetType = .terrestrial
    var star: Star = Star()
    var distance: Double = 0.0
    var gravity: Double {
        return self.mass/(self.radius*self.radius)
    }
    
    var density: Double {
        return 5.514*(self.mass/(self.radius*self.radius*self.radius))
    }
    
    var computedRadius: Double {
        let L: Double = star.luminosity
        let frostLine: Double = 4.85*sqrt(L)
        let m: Double = self.mass
        if(self.distance < frostLine) {
            return (1.527)*pow(m,0.3374)
        } else {
            return (1.023)*pow(m,0.3159)
        }
    }
    
    var computedTemp: Double {
        let L: Double = star.luminosity
        let D: Double = self.distance
        return 288*(pow(L,1/4)/pow(D,1/2))
    }
    
    
    override init() {
        super.init()
        self.radiusUnit = .Rearth
        self.massUnit = .Mearth
    }
    
    
    
    static func randTerrestrial(_ star: Star =  Star.rand(), _ dist: Double = -1.0, _ name: String = randomName()) -> Planet {
        let result = Planet()
        result.star = star
        result.mass = logRandom(0.002,10)
        result.name = name
        
        var myDist: Double = dist
        if(myDist == -1.0) {
            let innerLimit: Double = 0.1*star.mass
            let outerLimit: Double = 40.0*star.mass
            myDist = logRandom(innerLimit,outerLimit)
        }
        
        
        result.distance = myDist
        result.radius = result.computedRadius
        result.temp = result.computedTemp
        result.type = .terrestrial
        
        return result
    }
    
    
    static func randIceGiant(_ star: Star =  Star.rand(), _ dist: Double = -1.0, _ name: String = randomName()) -> Planet {
        let result = Planet()
        result.star = star
        result.mass = random(4.0,62.5)
        result.name = name
        var myDist: Double = dist
        if(myDist == -1.0) {
            let innerLimit: Double = 0.1*star.mass
            let outerLimit: Double = 40.0*star.mass
            myDist = logRandom(innerLimit, outerLimit)
        }
        
        
        result.distance = myDist
        result.radius = result.computedRadius
        result.temp = result.computedTemp
        result.type = .iceGiant
        
        return result
    }
    
    static func randGasGiant(_ star: Star =  Star.rand(), _ dist: Double = -1.0, _ name: String = randomName()) -> Planet {
        let result = Planet()
        result.star = star
        result.mass = random(0.2,10.0)*(MassUnit.Mjup.rawValue/MassUnit.Mearth.rawValue)
        result.name = name
        var myDist: Double = dist
        if(myDist == -1.0) {
            let innerLimit: Double = 0.1*star.mass
            let outerLimit: Double = 40.0*star.mass
            myDist = logRandom(innerLimit, outerLimit)
        }
        
        
        result.distance = myDist
        result.radius = result.computedRadius
        result.temp = result.computedTemp
        result.type = .gasGiant
        
        return result
    }
    
    static func rand(_ star: Star = Star.rand(), _ dist: Double = -1.0, _ name: String = randomName()) -> Planet {
        return weightedRandomElement(items: [
            (Planet.randTerrestrial(star,dist,name),4.0),
            (Planet.randIceGiant(star,dist,name),2.0),
            (Planet.randGasGiant(star,dist,name),2.0)
        ])
    }
    
}
    
    
    
    
    
    

