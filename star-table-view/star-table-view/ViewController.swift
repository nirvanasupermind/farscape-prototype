//
//  ViewController.swift
//  farscape-table-view
//
//  Created by Nirvana Choudhury on 12/1/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//


import UIKit
import Foundation
func replace(_ str: String, _ pattern: String, _ template: String) -> String {
    let regex = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
    return  regex.stringByReplacingMatches(in: str, options: [], range: NSRange(0..<str.utf16.count), withTemplate: template)
    
}
func getTags(_ planet: [String:String]) -> [String] {
   return []
}
//
//protocol NormalType: Equatable {}
//
//extension Double: NormalType {}
//extension Int: NormalType {}
//extension String: NormalType {}
//extension Bool: NormalType {}


func arrayContainsArray(list:[String],findList:[String]) -> Bool {
    let notFoundList = findList.filter( { list.contains($0) == false })
    return notFoundList.count == 0
}

func matchesForRegexInText(regex: String!, text: String!) -> [String] {
    
    do {
        
        let regex = try NSRegularExpression(pattern: regex, options: [])
        let nsString = text as NSString
        
        let results = regex.matches(in: text,
                                    options: [], range: NSMakeRange(0, nsString.length))
        return results.map { nsString.substring(with: $0.range)}
        
    } catch let error as NSError {
        
        print("invalid regex: \(error.localizedDescription)")
        
        return []
    }
}
func inBraces(_ n: String) -> [String] {
    let regex = "\\[(.*?)\\]"
    return matchesForRegexInText(regex: regex, text: n).map { $0.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")}
}

func outBraces(_ n: String) -> String {
    return replace(n, "\\[(.*?)\\]", "")
}



class ViewController: UIViewController,UISearchResultsUpdating {
    
    @IBOutlet weak var theTableView: UITableView!
    var starData: [[String:String]] = []
    var filteredTableData: [[String:String]] = []
    var currentData: [[String:String]] {
        if  (resultSearchController.isActive) {
                return filteredTableData
            } else {
                return starData
        }
    }
    var resultSearchController = UISearchController()
    
    
         
        
    func contains2(_ x: String, _ y: String) -> Bool {
        var a = x.lowercased()
        var b = y.lowercased()
        if(b == "") {
            return true
        } else {
            return a.contains(b)
        }
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        
        
        let array = starData.filter {
            var n: String = searchController.searchBar.text!.replacingOccurrences(of: "\\s\\s", with: "", options: .regularExpression)
            
            var m: String = $0["Star Name           "]!

           
            

            return contains2(m,outBraces(n))
                && arrayContainsArray(list: getTags($0), findList:             inBraces(n))
            
        }
        filteredTableData = array
        
        theTableView.reloadData()
    }
    
    
    func loadJson(fileName: String) -> [[String:String]]? {
  
        
        
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let planet = try? decoder.decode([[String:String]].self, from: data)
            else {
                return nil
                
                
                
        }
        
        
        
        
        
        return planet
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        theTableView.delegate = self
        theTableView.dataSource = self
        
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            theTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.starData = loadJson(fileName: "core_star_1")!
        
        
    }
    
    
    
    
}




extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "(\(currentData.count)) Stars"
    }
    
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return starData.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
     
            cell.textLabel?.text = currentData[indexPath.row]["Star Name           "]!
            cell.textLabel?.textColor = UIColor.white
            
            cell.detailTextLabel?.text = "\(currentData[indexPath.row]["Stellar Mass(Msun) "]!) Msun"
            cell.detailTextLabel?.textColor = UIColor.white
            
        
        

        
        
        
        
        return cell
        
    }
    
    
}


