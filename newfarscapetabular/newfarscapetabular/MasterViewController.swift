//
//  MasterViewController.swift
//  newfarscapetabular
//
//  Created by Nirvana Choudhury on 9/7/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [Planet] = []
    
    var names: [String] = []
    
    var filteredNames: [String] = []
    
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        searchBar.placeholder = "Search"

        tableView.delegate = self
        tableView.dataSource = self
        
        data =  loadJson("core_data")!
        names = data.map { $0.name }
        filteredNames = names
        
        definesPresentationContext = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(isSearchBarEmpty) {
            filteredNames = names
            tableView.reloadData()
        } else {
            self.filterContentForSearchText(searchText)
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
      filteredNames = names.filter { (name: String) -> Bool in
        return name.lowercased().contains(searchText.lowercased())
      }

      tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        let target = segue.destination as! DetailViewController
        target.planet = data[selectedPath.row]
    }
    
    func loadJson(_ fileName: String) -> [Planet]? {
       let decoder = JSONDecoder()
       guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let person = try? decoder.decode([Planet].self, from: data)
       else {
            return nil
       }

       return person
    }
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("you tapped me!")
//        self.performSegue(withIdentifier: "master_detail", sender: self)
    }
}

extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = filteredNames[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
}
