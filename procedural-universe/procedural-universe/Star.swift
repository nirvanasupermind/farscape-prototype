//
//  Star.swift
//  procedural-universe
//
//  Created by Nirvana Choudhury on 2/10/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import Foundation

func weightedRandomElement<T>(items: [(T, Double)]) -> T {

    let total = items.map { $0.1 }.reduce(0, +)
    let rand = random(0,total)
    var sum = 0.0
    for (element, weight) in items {
        sum += weight
        if rand < sum {
            return element
        }
    }

    return items[0].0
}

func giantProbs(_ items: [(Star,Double)], _ a: Double = 1) -> [(Star,Double)] {
    let total = items.map { $0.1 }.reduce(0, +)
    return items.map { ($0.0,(a*$0.1)/total) }
}


enum StarType: String {
    typealias RawValue = String
    
    case m_main = "M-type main-sequence star"
    case k_main = "K-type main-sequence star"
    case g_main = "G-type main-sequence star"
    case f_main = "F-type main-sequence star"
    case a_main = "A-type main-sequence star"
    case b_main = "B-type main-sequence star"
    case o_main = "O-type main-sequence star"
    case m_giant = "M-type giant"
    case k_giant = "K-type giant"
    case g_giant = "G-type giant"
    case f_giant = "F-type giant"
    case a_giant = "A-type giant"
    case b_giant = "B-type giant"
    case o_giant = "O-type giant"
    case white_dwarf = "White dwarf"
    case neutron_star = "Neutron star"
    case black_hole = "Black hole"
    
    
}
class Star: Body {
    override var description: String {
        return super.description+"""
        
            Luminosity: \(myRound(self.luminosity)) Lsun
            Type: \(self.type.rawValue)
        """
        
    }
    
    var luminosity: Double {
        if(self.type == .white_dwarf) {
            return self.mass*0.001
        } else if(self.type == .neutron_star) {
            return self.mass/7e5
        } else if(self.type == .black_hole) {
            return 0.0
        } else {
            return pow(self.mass,3.5)
        }
    }
    
    var type: StarType = .m_main
    
    override init() {
        super.init()
        self.radiusUnit = DistUnit.Rsun
        self.massUnit = MassUnit.Msun
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    static func randMMain() -> Star {
        let mass: Double = random(0.08,0.45)
        let radius: Double = pow(mass,0.8)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = pow(luminosity/(radius*radius),1/4)*5778
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .m_main
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
        
    }
    
    static func randKMain() -> Star {
        let mass: Double = random(0.45,0.8)
        let radius: Double = pow(mass,0.8)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = pow(luminosity/(radius*radius),1/4)*5778
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .k_main
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
        
    }
    
    static func randGMain() -> Star {
        let mass: Double = random(0.8,1.04)
        var radius: Double = pow(mass,0.8)
        if(mass > 1) {
            radius = pow(mass,0.5)
        }
        
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = pow(luminosity/(radius*radius),1/4)*5778
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .g_main
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randFMain() -> Star {
        let mass: Double = random(1.04,1.4)
        let radius: Double = pow(mass,0.5)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = pow(luminosity/(radius*radius),1/4)*5778
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .f_main
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randAMain() -> Star {
        let mass: Double = random(1.4,2.1)
        let radius: Double = pow(mass,0.5)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = pow(luminosity/(radius*radius),1/4)*5778
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .a_main
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randBMain() -> Star {
        let mass: Double = random(2.1,16)
        let radius: Double = pow(mass,0.5)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = pow(luminosity/(radius*radius),1/4)*5778
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .b_main
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randOMain() -> Star {
        let mass: Double = random(16,50)
        let radius: Double = pow(mass,0.5)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = pow(luminosity/(radius*radius),1/4)*5778
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .o_main
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    
    static func randMGiant() -> Star {
        let mass: Double = random(0.6,3)
        let radius: Double = random(0.08,180)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = random(3000,4000)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .m_giant
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randKGiant() -> Star {
        let mass: Double = random(1.1,4)
        let radius: Double = random(8.5,67)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = random(3778,5012)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .k_giant
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randGGiant() -> Star {
        let mass: Double = random(1.05,5.25)
        let radius: Double = random(0.981,38.2)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = random(4600,5950)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .g_giant
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randFGiant() -> Star {
        let mass: Double = random(1.25,2.48)
        let radius: Double = random(1.72,78)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = random(6231,7559)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .f_giant
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randAGiant() -> Star {
        let mass: Double = random(1.65,3.5)
        let radius: Double = random(1.4,15)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = random(5058,11588)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .a_giant
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randBGiant() -> Star {
        let mass: Double = random(1.25,33)
        let radius: Double = random(1.3,20)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = random(6231,7559)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .b_giant
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randOGiant() -> Star {
        let mass: Double = random(9,130)
        let radius: Double = random(6,22.65)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = random(11683,57000)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .b_giant
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randWhiteDwarf() -> Star {
        let mass: Double = random(0.17,1.4)
        let radius: Double = pow(mass,-1/3)*(DistUnit.Rearth.rawValue/DistUnit.Rsun.rawValue)
        let luminosity: Double = pow(mass,3.5)
        let temp: Double = random(12000,100000)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .white_dwarf
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randNeutronStar() -> Star {
        let mass: Double = random(1.4,3)
        let radius: Double = random(1.4374e-5,1.8686e-5)
        let temp: Double = random(2e6/3,4e6/3)
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .neutron_star
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    static func randBlackHole() -> Star {
        let mass: Double = random(5,10)
        let radius: Double = 2.95*mass*(DistUnit.km.rawValue/DistUnit.Rsun.rawValue)
        let temp: Double = 0.0
        let name: String = randomName()
        
        var result: Star = Star()
        result.type = .black_hole
        result.mass = mass
        result.radius = radius
        result.temp = temp
        result.name = name
        
        return result
    }
    
    
    

    static func randOld() -> Star {
        return weightedRandomElement(items: [
            (Star.randMMain(),301),
            (Star.randKMain(),239),
            (Star.randGMain(),425),
            (Star.randFMain(),419),
            (Star.randAMain(),489),
            (Star.randBMain(),406),
            (Star.randOMain(),37)
        ])
    }
    
    static func rand() -> Star {
        return weightedRandomElement(items: [
            (Star.randOMain(),1.0),
            (Star.randBMain(),1.0),
            (Star.randAMain(),5.0),
            (Star.randFMain(),30.0),
            (Star.randGMain(),70.0),
            (Star.randKMain(),100.0),
            (Star.randMMain(),700.0),
            (Star.randWhiteDwarf(),100.0),
            (Star.randNeutronStar(),1.0),
            (Star.randBlackHole(),1.0)
        ]+giantProbs([
            (Star.randMGiant(),301.0),
            (Star.randKGiant(),587.0),
            (Star.randGGiant(),254.0),
            (Star.randFGiant(),78.0),
            (Star.randAGiant(),76.0),
            (Star.randBGiant(),154.0),
            (Star.randOGiant(),20.0)
        ],4.0))
    }
    
    static func randHost() -> Star {
        return weightedRandomElement(items: [
            (Star.randOMain(),1.0),
            (Star.randBMain(),1.0),
            (Star.randAMain(),5.0),
            (Star.randFMain(),30.0),
            (Star.randGMain(),70.0),
            (Star.randKMain(),100.0),
            (Star.randMMain(),700.0),
            (Star.randNeutronStar(),1.0)
        ])
    }
    
   
    
    
    
    
    
    
}
