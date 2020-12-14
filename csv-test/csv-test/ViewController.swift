//
//  PlanetViewController.swift
//  csv-test
//
//  Created by Nirvana Choudhury on 9/28/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import UIKit
//
//struct Planet : Codable {
//    var exoplanet_name:String
//    var alternate_name:String
//    var radius:String
//    var mass:String
//    var semi_major_axis_orbital_distance_calculated:String
//    var eccentricity:String
//    var orbital_period:String
//    var star_radiation_at_atmospheric_boundary:String
//    var measured_temperature:String
//    var blackbody_t_0_1:String
//    var blackbody_t_0_3:String
//    var blackbody_t_0_7:String
//    var tidally_locked_blackbody_t_0_1:String
//    var tidally_locked_blackbody_t_0_3:String
//    var size_class:String
//    var mass_class:String
//    var detection_type:String
//    var mass_detection:String
//    var radius_detection:String
//    var habitability_by_solar_eq_astronomical_unit:String
//    var habitability_by_kopparapu:String
//    var star_name:String
//    var star_distance:String
//    var stellar_radius:String
//    var stellar_mass:String
//    var star_age:String
//    var temperature:String
//    var spectral_type:String
//    var metalicity:String
//    var absolute_magnitude:String
//    var apparent_magnitude:String
//    var right_ascension:String
//    var declination:String
//}

extension Array: Codable {
    
}
class PlanetViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        var(item) = ""
        if(indexPath.row < self.json.count) {
            item = self.json[indexPath.row]
        }
        cell.textLabel?.text = item
        return cell
    }
    
    var json: [String] = []
    
    func loadJson(fileName: String) -> [[String]]? {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let person = try? decoder.decode([[String]].self, from: data)
            else {
                return nil
        }
        
        return person
    }
    
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.json = loadJson(fileName: "exo-kyoto")!.map { $0.first!}
        //        self.json = ["a","b"]
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.json.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json[0].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath as IndexPath) as UITableViewCell?
        
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,
                                   reuseIdentifier: "myCell")
        }
        
        cell?.textLabel?.text = self.json[indexPath.row]
        
        return cell!
    }
    
    //    @IBOutlet var myTableView: UITableView! {
    //        didSet {
    //            myTableView.dataSource = self
    //        }
    //    }
    
    
    
    
    
    
    
    
    
    
}

