//
//  ViewController.swift
//  table-view-exp
//
//  Created by Nirvana Choudhury on 3/21/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import UIKit

struct PlanetData: Codable {
    var mass: Double?
    var radius: Double?
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!


    let data: [PlanetData] = ViewController.loadJson("planet_catalog")!
    let names: [String] = []

    static func loadJson(_ fileName: String) -> [PlanetData]? {
           
           
           let decoder = JSONDecoder()
           guard
               let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let planet = try? decoder.decode([PlanetData].self, from: data)
               else {
                   return nil
                   
                   
                   
           }
           
           
           
           
           
           return planet
       }
       
    
    func runTests() {
        print(data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        self.runTests()
        
    }
    


}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        cell.textLabel?.text = names[indexPath.row % names.count]
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
  
}
