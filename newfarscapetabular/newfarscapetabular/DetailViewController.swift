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
        "discovered_in": "Discoverd in",
        "alt_names": "Alternate names",
        "radius": "Radius (Rjup)",
        "mass": "Mass (Mjup)",
        "semi_major_axis": "Semi-major axis (AU)"
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

        cell.detailTextLabel?.text = data[indexPath.row].1 == "" ? "–" :  data[indexPath.row].1
        cell.detailTextLabel?.textColor = UIColor.white

        
        return cell
    }
}


