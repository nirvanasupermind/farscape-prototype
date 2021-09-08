//
//  ViewController.swift
//  newfarscapetabular
//
//  Created by Nirvana Choudhury on 9/7/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var names: [String] = []
    
//    var filteredNames: [String] = []
//    let searchController: UISearchController = UISearchController(searchResultsController: nil)
//
//    var isSearchBarEmpty: Bool {
//      return searchController.searchBar.text?.isEmpty ?? true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        names.append("puma")
        names.append("jaguar")
        names.append("panther")
        
//        // 1
//        searchController.searchResultsUpdater = self
//        // 2
//        searchController.obscuresBackgroundDuringPresentation = false
//        // 3
//        searchController.searchBar.placeholder = "Search Candies"
//        // 4
//        navigationItem.searchController = searchController
//        // 5
        definesPresentationContext = true
    }
    
//    func filterContentForSearchText(_ searchText: String) {
//      filteredNames = names.filter { (name: String) -> Bool in
//        return name.lowercased().contains(searchText.lowercased())
//      }
//
//      tableView.reloadData()
//    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
}

