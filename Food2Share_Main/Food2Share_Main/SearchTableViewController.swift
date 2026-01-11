//
//  SearchTableViewController.swift
//  Food2Share_Main
//
//  Created by N M on 1/10/26.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    @IBOutlet weak var ResultList: UITableView!
    var originalData: [Organization]
    var filteredData = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ResultList.dataSource = self
        ResultList.delegate = self
        
        searchController.searchResultsUpdating = self
        searchController.obscuresBackgroundDuringPresentation = false // Don't hide the main view
        searchController.searchBar.placeholder = "Search Organizations/Campaigns"
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isFiltering ? filteredData.count : originalData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let fruit: String
               
               // Determine which data source to use
            if isFiltering {
                   fruit = filteredData[indexPath.row]
               } else {
                   fruit = originalData[indexPath.row]
               }
               
        cell.textLabel?.text = fruit
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            filterContentForSearchText(searchBar.text!)
        }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredData = originalData.filter { (fruit: String) -> Bool in
            // Check if the fruit name contains the search text (case-insensitive)
            return fruit.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    var isFiltering: Bool {
            return searchController.isActive && !searchController.searchBar.text!.isEmpty
        }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
