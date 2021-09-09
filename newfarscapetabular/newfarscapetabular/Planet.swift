//
//  Planet.swift
//  newfarscapetabular
//
//  Created by Nirvana Choudhury on 9/8/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import Foundation

struct Planet: Codable {
    var name: String
    var planet_status: String
    var discovered_in: String
    var alt_names: String
    var radius: String
    var mass: String
    var semi_major_axis: String

    func asPairs() -> [(String, String)] {
        return [
            ("name", name),
            ("planet_status", planet_status),
            ("discovered_in", discovered_in),
            ("alt_names", alt_names),
            ("radius", radius),
            ("mass", mass),
            ("semi_major_axis", semi_major_axis)
        ]
    }
}
