//
//  DetailViewController.swift
//  newfarscapetabular
//
//  Created by Nirvana Choudhury on 9/8/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var planet: Planet?
    
    var data: [(String, String)] = []
    
    let fieldNames: [String: String] = [
        "name": "Name",
        "planet_status": "Planet status",
        "discovered_in": "Discovered in",
        "alt_names": "Alternate names",
        "radius": "Radius (Rjup)",
        "mass": "Mass (Mjup)",
        "semi_major_axis": "Semi-major axis (AU)",
        "eccentricity": "Eccentricity",
        "inclination": "Inclination (deg)",
        "orbital_period": "Orbital period (day)",
        "surface_gravity": "Surface gravity (g)",
        "calc_temp": "Calculated temperature (K)",
        "measured_temp": "Measured temperature (K)",
        "detection_type": "Detection type",
        "star_name": "Star name",
        "star_alt_names": "Star alternate names",
        "star_distance":"Star distance (ly)",
        "star_radius": "Star radius (Rsun)",
        "star_mass": "Star mass (Msun)",
        "star_age": "Star age (Gy)",
        "star_temp": "Star temperature (K)",
        "star_spec_type": "Star spectral type",
        "star_ra": "Star right ascension (deg)",
        "star_dec": "Star declination (deg)"
    ]
     
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        for (k, v) in (planet?.asPairs())! {
            data.append(("\(fieldNames[k] ?? k): ", "\(v)"))
        }
    }
    
    func setPlanet(planet: Planet) {
        self.planet = planet
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("you tapped me!")
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail_cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].0
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.adjustsFontSizeToFitWidth = true

        cell.detailTextLabel?.text = data[indexPath.row].1 == "" ? "–" :  data[indexPath.row].1
        cell.detailTextLabel?.textColor = UIColor.white
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true

        return cell
    }

}


