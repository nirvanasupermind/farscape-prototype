//
//  Planet.swift
//  newfarscapetabular
//
//  Created by Nirvana Choudhury on 9/8/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import Foundation


struct Planet: Codable {
    static let decimalPlaces: Int = 5
    
    var name: String
    var planet_status: String
    var discovered_in: String
    var alt_names: String
    var radius: String
    var mass: String
    var semi_major_axis: String
    var eccentricity: String
    var inclination: String
    var orbital_period: String
    var surface_gravity: String
    var calc_temp: String {
        let sigma: Double = 5.670367e-8
        let solLum: Double = 3.828e26
        let au: Double = 149597870700.0
        
        let lum: Double = pow(Double(star_mass) ?? 0, 3.5)
        let bondAlbedo: Double = 0.3
        let dist: Double = Double(semi_major_axis) ?? 0
        
        let temp: Double = lum * solLum * (1 - bondAlbedo) / (16 * Double.pi * dist * dist * au * au * sigma)
        
        return "\(pow(temp, 1/4))"
    }
    
    var measured_temp: String
    var detection_type: String
    var star_name: String
    var star_alt_names: String
    var star_distance: String
    var star_radius: String
    var star_mass: String
    var star_age: String
    var star_temp: String
    var star_spec_type: String
    var star_ra: String
    var star_dec: String

    func asPairs() -> [(String, String)] {
        return [
            ("name", name),
            ("planet_status", planet_status),
            ("discovered_in", discovered_in),
            ("alt_names", alt_names),
            ("radius", radius.toPrecision(Planet.decimalPlaces)),
            ("mass", mass.toPrecision(Planet.decimalPlaces)),
            ("semi_major_axis", semi_major_axis.toPrecision(Planet.decimalPlaces)),
            ("eccentricity", eccentricity.toPrecision(Planet.decimalPlaces)),
            ("inclination", inclination.toPrecision(Planet.decimalPlaces)),
            ("orbital_period", orbital_period.toPrecision(Planet.decimalPlaces)),
            ("surface_gravity", surface_gravity.toPrecision(Planet.decimalPlaces)),
            ("calc_temp", calc_temp.toPrecision(Planet.decimalPlaces)),
            ("measured_temp", measured_temp.toPrecision(Planet.decimalPlaces)),
            ("detection_type", detection_type.toPrecision(Planet.decimalPlaces)),
            ("star_name", star_name.toPrecision(Planet.decimalPlaces)),
            ("star_alt_names", star_alt_names.toPrecision(Planet.decimalPlaces)),
            ("star_distance", star_distance.toPrecision(Planet.decimalPlaces)),
            ("star_radius", star_radius.toPrecision(Planet.decimalPlaces)),
            ("star_mass", star_mass.toPrecision(Planet.decimalPlaces)),
            ("star_age", star_age.toPrecision(Planet.decimalPlaces)),
            ("star_temp", star_temp.toPrecision(Planet.decimalPlaces)),
            ("star_spec_type", star_spec_type.toPrecision(Planet.decimalPlaces)),
            ("star_ra", star_ra.toPrecision(Planet.decimalPlaces)),
            ("star_dec", star_dec.toPrecision(Planet.decimalPlaces))
        ]
    }
}

extension String {
    /// Rounds the double to decimal places value
    func toPrecision(_ places: Int) -> String {
        if(Double(self) != nil) {
            let num: Double = Double(self)!
            if(num < 0) {
                return "-\("\(-num)".toPrecision(places))"
            }
            if(num == 0) {
                return "0.0"
            }
            
            let tmp = pow(10, -floor(log10(num)) + Double(places) - 1.0);
            return "\(floor(num * tmp) / tmp)"
        } else {
            return self
        }
    }
}
