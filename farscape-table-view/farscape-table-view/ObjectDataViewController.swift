//
//  ObjectDataViewController.swift
//  farscape-table-view
//
//  Created by Nirvana Choudhury on 12/20/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import Foundation
import UIKit


var unitDict: [String:String] = [
    "Mass": "(Mjup)",
    "Blackbody T 0.7(K)": "(K)",
    "Blackbody T 0.1(K)": "(K)",
    "Measured Temperature(K)":"(K)",
    "Orbital Period(Yrs)": "(years)",
    "Stellar Mass(Msun)": "(Msun)",
    "Stellar Radius(Rsun) ":"(Rsun)",
    "Semi Major Axis / Orbital Distance Calculated": "(AU)",
    "Orbital Period(Observed/Estimated)": "(d)",
    "Blackbody T 0.3(K)": "(K)",
    "Star Age     ": "(gigayears)",
    "Tidally Locked Blackbody T 0.1(K)": "(K)",
    "Temperature   ": "(K)",
    "Radius (Rjup / Re)": "(Rjup)"
    
]

func cleanPropertyName(_ a: String) -> String {
    switch(a) {
    case "Blackbody T 0.7(K)":
        return "Temperature (albedo 0.7)"
    case "Blackbody T 0.1(K)":
        return "Temperature (albedo 0.1)"
    case "Temperature   ":
        return "Stellar Temperature"
    default:
        return a.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "(")[0].components(separatedBy: ":")[0]
    }
}
class ObjectDataViewController: UIViewController {
    var planet: [String:String] = [:]
    @IBOutlet weak var objectDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var idx = indexRowBuffer
        
        
        //        print(planetDataBuffer.map { $0["name"] ?? "\($0)"})
        if(idx == -1) {
            self.planet = [:]
        } else {
            self.planet = planetDataBuffer[idx]
        }
        
    
//        print(self.planet)
        
        self.objectDataTableView.sectionHeaderHeight = UITableView.automaticDimension

        self.objectDataTableView.rowHeight = UITableView.automaticDimension
        self.objectDataTableView.estimatedRowHeight = 600

        
        
        definesPresentationContext = true
        
        objectDataTableView.delegate = self
        objectDataTableView.dataSource = self
        
        
        
    }
}

extension ObjectDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Data for \"\(planetDataBuffer[indexRowBuffer][NAME]!)\""
    }
    
}


extension ObjectDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planetDataBuffer[0].count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_2", for: indexPath)
        
        let boldText = "\(cleanPropertyName(Array(planet.keys)[indexPath.row])): "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = "\(Array(planet.values)[indexPath.row]) \(unitDict[Array(planet.keys)[indexPath.row]] ?? "")"
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
            
        
        cell.textLabel?.attributedText = attributedString
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        
        
//        cell.textLabel?.adjustsFontForContentSizeCategory = true
//
//        cell.textLabel?.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
//        cell.textLabel?.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true

        return cell
        
    }
    
    
}


