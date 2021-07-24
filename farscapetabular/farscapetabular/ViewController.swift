import UIKit
class ViewController:
    UIViewController,
UITableViewDelegate, UITableViewDataSource {
    
    // Data model: These strings will be the data for the table view cells
    //    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    //
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    //    let data: [String]
    var data: [[String]] = []
    var names: [String] = []
    var filteredNames: [String] = []

    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    func readDataFromFile(_ fileName: String)-> String {
        let path = Bundle.main.path(forResource: fileName, ofType: "csv")
        let text = try! String(contentsOfFile: path!)
        return text
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        

        let text = readDataFromFile("farscape_core_database_2021_07_23")
        let columns: [String] = text.components(separatedBy: "\n") as [String]
        var myData: [[String]] = []
        
        for column in columns {
            let values = column.components(separatedBy: ",")
            myData.append(values)
        }
        
        myData = Array(myData[1...])
        
        self.data = myData
        self.names = myData.map { $0.first! }
        self.filteredNames = self.names
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredNames.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell)
            
        // set the text from the data model
        cell.textLabel?.text = self.filteredNames[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.white
    
        
        cell.backgroundColor = UIColor.black
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if isSearchBarEmpty {
            filteredNames = self.names
        } else {
            filteredNames = self.names.filter {
                $0.lowercased().contains(searchText.lowercased())
            }
        }
        
        
      
      tableView.reloadData()
    }
}


extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

