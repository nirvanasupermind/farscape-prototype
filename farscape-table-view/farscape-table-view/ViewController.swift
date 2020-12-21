//
//  ViewController.swift
//  farscape-table-view
//
//  Created by Nirvana Choudhury on 12/1/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//



import UIKit
import Foundation

var nameBuffer = ""
var indexRowBuffer: Int = 0
var NAME = "Exoplanet Name    "
var planetDataBuffer: [[String:String]] = []
func replace(_ str: String, _ pattern: String, _ template: String) -> String {
    let regex = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
    return  regex.stringByReplacingMatches(in: str, options: [], range: NSRange(0..<str.utf16.count), withTemplate: template)
    
}

func getTags(_ planet: [String:String]) -> [String] {
    var tags = [String]()
    var mass: Double = Double(planet["Mass   (Mjup / Me)"]!)!
    var radius: Double =  Double(planet["Radius (Rjup / Re)"]!)!
    switch mass/0.0031 {
    case 0...0.00001:
        tags.append("asteroidan")
        break
    case 0.00001...0.1:
        tags.append("mercurian")
        break
    case 0.1...0.5:
        tags.append("subterran")
        break
    case 0.5...2:
        tags.append("terran")
        break
    case 2...10:
        tags.append("superterran")
        break
    case 10...50:
        tags.append("neptunian")
        break
    case 50...5000:
        tags.append("jovian")
    default:
        break
        
        
        
    }

    
    if(mass > 1) {
        tags.append("super-jupiter")
    }
    
    if(mass < 2 && radius > 1) {
           tags.append("puffy-giant")
      }
    
    if(radius/0.0892 > 2 && radius < 0.3464 && mass/0.0031 > 1 && mass/0.0031 < 20) {
           tags.append("gas-dwarf")
      }
       
       
    
    
    
    
    
    return tags
    
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
    var planetData: [[String:String]] = []
    var filteredTableData: [[String:String]] = []
    var currentData: [[String:String]] {
        if  (resultSearchController.isActive) {
                return filteredTableData
            } else {
                return planetData
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
        
        
        
        let array = planetData.filter {
            var n: String = searchController.searchBar.text!.replacingOccurrences(of: "\\s\\s", with: "", options: .regularExpression)
            
            var m: String = $0["Exoplanet Name    "]!+$0["Alternate Name    "]!

           
            

            return contains2(m,outBraces(n))
                && arrayContainsArray(list: getTags($0), findList:             inBraces(n))
            
        }
        filteredTableData = array
        
        theTableView.reloadData()
    }
    
    
    func loadJson(fileName: String) -> [[String:String]]? {
        let array2 = planetData.filter {
                    
                    outBraces($0["Exoplanet Name    "]!).contains(resultSearchController.searchBar.text!)
                        
                        && arrayContainsArray(list: getTags($0), findList:             inBraces($0["Exoplanet Name    "]!))
                    
                }
        
        
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
        
        definesPresentationContext = true

        theTableView.delegate = self
        theTableView.dataSource = self
        
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            
            controller.isActive = false
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            theTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.planetData = loadJson(fileName: "core_planet_1")!
        planetDataBuffer = self.planetData
        
    }
    
    
    
    
    
}




extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if( resultSearchController.isActive == false) {
        indexRowBuffer = planetData.map { $0[NAME] }.firstIndex(of: planetData[indexPath.row][NAME])!
            performSegue(withIdentifier: "dataSegue", sender: nil)
        } else {
            indexRowBuffer = planetData.map { $0[NAME] }.firstIndex(of: filteredTableData[indexPath.row][NAME])!
            resultSearchController.isActive = false

            performSegue(withIdentifier: "dataSegue", sender: nil)


        }
        
        
        print("You tapped me, the buffer as \(indexRowBuffer)")
        performSegue(withIdentifier: "dataSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "(\(currentData.count)) Planets"
    }
    
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return planetData.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row]["Exoplanet Name    "]
            cell.textLabel?.textColor = UIColor.white
            
            cell.detailTextLabel?.text = filteredTableData[indexPath.row]["Star Name           "]
            cell.detailTextLabel?.textColor = UIColor.white
            
            
            
        } else {
            cell.textLabel?.text = planetData[indexPath.row]["Exoplanet Name    "]
            cell.textLabel?.textColor = UIColor.white
            
            cell.detailTextLabel?.text = planetData[indexPath.row]["Star Name           "]
            cell.detailTextLabel?.textColor = UIColor.white
            
        }
        

        
        
        
        
        
        return cell
        
    }
    
    
}


