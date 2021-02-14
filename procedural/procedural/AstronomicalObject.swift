//
//  AstronomiocalObject.swift
//  procedural
//
//  Created by Nirvana Choudhury on 1/8/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import Foundation

enum DistanceUnit: Double {
    typealias RawValue = Double
    
    case km = 1.0
    case Re = 6371.0
    case Rj = 69911.0
    case Rsol = 702098.0
    case ly = 9460730472580.8
}

enum MassUnit: Double {
    typealias RawValue = Double
    
    case kg = 1.0
    case Me = 5.976E+24
    case Mjup = 1.900368E+27
    case Msol = 1.99036656E+30
}




class AstronomicalObject: Equatable, Hashable, CustomStringConvertible {
    static func == (lhs: AstronomicalObject, rhs: AstronomicalObject) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    var description: String {
        return "\(type(of: self)) '\(self.name)'\n\tRadius: \(self.radius) \(self.radiusUnit)\n\tMass: \(self.mass) \(self.massUnit)\n\tTemperature: \(self.temp) \(self.tempUnit)\n\t"
    }
    
    var json: String {
        return "\(type(of: self)) {\"name\":'\(self.name)',\"radius\":\(self.radius),\"mass\":\(self.mass),\"radiusUnit\":\(self.radiusUnit),\"massUnit\":\(self.massUnit),\"texture\":\(self.texture),\"uuid\":'\(self.uuid)',\"hashValue\":\(self.hashValue)}"
    }
    
    var short: String {
        return "<\(type(of: self)) '\(self.name)'>"
    }
    
    var name: String = ""
    var radius: Double = 0.0
    var mass: Double = 0.0
    var radiusUnit: DistanceUnit = .Re
    var massUnit: MassUnit = .Me
    var temp: Double = 0.0
    var tempUnit: TempUnit = .K
    var uuid: String
    var texture: String { return "" }
    
    init() {
        self.uuid = UUID().uuidString
    }
    
}

