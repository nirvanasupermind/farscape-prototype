//
//  Body.swift
//  procedural-universe
//
//  Created by Nirvana Choudhury on 2/10/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import Foundation
func random(_ min: Double = 0, _ max: Double = 1) -> Double {
    return Double.random(in: min...max)
}

func toJSON<T:Codable>(_ n: T) -> String {
    let pear = n
    let encoder = JSONEncoder()
    let data = try! encoder.encode(pear)
    return String(data: data, encoding: .utf8)!
}



func random(_ min: Int = 0, _ max: Int = 1) -> Int {
    return Int.random(in: min...max)
}

func logRandom(_ min: Double = 0, _ max: Double = 1) -> Double {
    return pow(10,random(log10(min),log10(max)))
}


var vowels: [String] = "aeiou".map { String($0) }
var consonants: [String] = "bcdfghjklmnpqrstvwxyz".map { String($0) }

func randomVowel() -> String {
    return vowels.randomElement()!
}

func randomConsonant() -> String {
    return consonants.randomElement()!
}

func randomSyllable() -> String {
    return "\(randomVowel())\(randomConsonant())"
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


func randomName() -> String {
    return "\(randomSyllable())\(randomSyllable())\(randomSyllable())".capitalizingFirstLetter()
}



enum DistUnit: Double, Codable {
    typealias RawValue = Double
    case km = 1.0
    case Rearth = 6371.0088
    case Rjup = 71492.0
    case Rsun = 695700.0
}

enum MassUnit: Double, Codable {
    typealias RawValue = Double
    case kg = 1.0
    case Mearth = 5.9722e24
    case Mjup = 1.89813e27
    case Msun = 1.98847e30
}

enum TempUnit: String, Codable {
    case K = "K"
    case C = "C"
}



class PropertyNames
{
    func propertyNames(_ mirror: Mirror? = nil) -> [String] {
        var theMirror = mirror ?? Mirror(reflecting: self)
        return theMirror.children.compactMap { $0.label }
    }
}



var prec: Double = 100000.0

func myRound(_ x: Double) -> Double {
    if(abs(x) < 10/prec) {
        return x
    } else {
        return Double(round(prec*x)/prec)
    }
}


protocol PropertyReflectable {
    func get(key: String, _m: Mirror?) -> Any?
}

extension PropertyReflectable {
    func get(key: String, _m: Mirror? = nil) -> Any? {
        let m = _m ?? Mirror(reflecting:self)
        for child in m.children {
            if child.label == key { return child.value }
        }
        return nil
    }
}


extension Mirror {

    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()

        // Properties of this instance:
        for attr in self.children {
            if let propertyName = attr.label {
                dict[propertyName] = attr.value as? AnyObject
            }
        }

        // Add properties of superclass:
        if let parent = self.superclassMirror {
            for (propertyName, value) in parent.toDictionary() {
                dict[propertyName] = value
            }
        }

        return dict
    }
}


class Body: PropertyNames, PropertyReflectable, Equatable, Hashable, CustomStringConvertible {
    
    static func == (lhs: Body, rhs: Body) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    enum CodingKeys: CodingKey {
        case mass, radius
    }
    
//    public required init(from decoder: Decoder) throws {
//           super.init()
//
//           let container = try decoder.container(keyedBy: CodingKeys.self)
//           mass = try container.decode(Double.self, forKey: .title)
//           radius = try container.decode(Double.self, forKey: .subtitle)
//
//
//       }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mass, forKey: .mass)
        try container.encode(radius, forKey: .radius)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
    
    func toDictionary() -> [String:AnyObject] {
        return Mirror(reflecting:self).toDictionary()
    }
    
    
    
    
    
    

    public var description: String {
        return """
        \(type(of: self)) '\(self.name)'
            Radius: \(myRound(self.radius)) \(self.radiusUnit)
            Mass: \(myRound(self.mass)) \(self.massUnit)
            Temperature: \(myRound(self.temp)) \(self.tempUnit)
        """
    }
    
    public var shortDesc: String {
        return "\(type(of: self)) '\(self.name)' (\(myRound(self.mass)) \(self.massUnit))"
    }
    
   
    var radius: Double = 0.0
    var radiusUnit: DistUnit = .km
    var mass: Double = 0.0
    var name: String = ""
    var massUnit: MassUnit = .Mearth
    var temp: Double = 0.0
    var tempUnit: TempUnit = .K
    var uuid: String = UUID().uuidString
    
    
    

    
}



//extension Body : PropertyReflectable {}
