//
//  SearchTableViewController.swift
//  Food2Share_Main
//
//  Created by N M on 1/11/26.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var dataList: [Organization] = [
        Organization(
            id: "BH-FOOD-001",
            name: "Conserving Bounties (Bahrain Food Bank)",
            campaigns: [
                Campaign(
                    id: "C-RAM-26",
                    name: "Ramadan Surplus Collection",
                    progressNumber: 45000,
                    goalNumber: 60000,
                    organizedBy: "Conserving Bounties",
                    dateValue: "2026-04-15",
                    description: "Collecting surplus Iftar meals from Seef and Manama hotels."
                ),
                Campaign(
                    id: "C-WED-26",
                    name: "Wedding Food Rescue",
                    progressNumber: 120,
                    goalNumber: 500,
                    organizedBy: "Conserving Bounties",
                    dateValue: "2026-12-31",
                    description: "Rescuing untouched food from wedding halls in Riffa and Zallaq."
                )
            ],
            description: "The Kingdom's primary NGO focused on reducing food waste by redistributing surplus food.",
            address: "Building 123, Road 456, Seef District 428, Bahrain",
            communication: "info@foodbank.bh"
        ),
        
        Organization(
            id: "BH-COMM-002",
            name: "A Box of Goodness",
            campaigns: [
                Campaign(
                    id: "C-DRY-26",
                    name: "Dry Food Drive",
                    progressNumber: 85,
                    goalNumber: 150,
                    organizedBy: "A Box of Goodness",
                    dateValue: "2026-03-01",
                    description: "Essential pantry items for families in Muharraq and Sitra."
                )
            ],
            description: "A volunteer-run charity sharing blessings with those in need across the island.",
            address: "Saar/Adliya Distribution Points, Bahrain",
            communication: "@aboxofgoodness on Instagram"
        ),
        
        Organization(
            id: "BH-NGO-003",
            name: "Kaaf Humanitarian",
            campaigns: [
                Campaign(
                    id: "C-LABOR-26",
                    name: "Labor Camp Hot Meals",
                    progressNumber: 12000,
                    goalNumber: 20000,
                    organizedBy: "Kaaf",
                    dateValue: "2026-05-01",
                    description: "Distribution of cooked meals to industrial areas in Hidd and Askar."
                )
            ],
            description: "A large-scale humanitarian organization under the Al-Eslah Society.",
            address: "Busaiteen, Muharraq, Kingdom of Bahrain",
            communication: "+973 1733 3090"
        ),
        
        Organization(
            id: "BH-EDU-004",
            name: "Bahrain Schools Food Drive",
            campaigns: [
                Campaign(
                    id: "C-STUDENT-26",
                    name: "Back-to-School Canned Goods",
                    progressNumber: 300,
                    goalNumber: 1000,
                    organizedBy: "Student Council",
                    dateValue: "2026-09-10",
                    description: "Collecting non-perishables from students in Isa Town schools."
                )
            ],
            description: "A youth-led initiative to involve students in local food security.",
            address: "Educational Area, Isa Town, Bahrain",
            communication: "schools@moe.bh"
        )
    ]
    var filteredList = [Organization]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Set the search results updater
            searchController.searchResultsUpdater = self
            
            // 2. Ensure the search bar doesn't obscure the table view content
            searchController.obscuresBackgroundDuringPresentation = false
            
            // 3. Set a placeholder
            searchController.searchBar.placeholder = "Search Organizations..."
            
            // 4. Attach the search bar to the navigation bar (or table view header)
            navigationItem.searchController = searchController
            
            // 5. Ensure the search bar remains active when navigating to another view
            definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the search bar is active, use the filtered data count
            if searchController.isActive && !searchController.searchBar.text!.isEmpty {
                return filteredList.count
            }
            // Otherwise, use the original data count
            return dataList.count
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Get the search text, safely unwrapping it and making it lowercase for case-insensitive search
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        // Filter the original data based on the search text
        filteredList = dataList.filter { organization in
            return organization.name.lowercased().contains(searchText)
        }
        
        // Reload the table view to display the new data
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
            
            let org: Organization
            
            // Determine which data source to use
            if searchController.isActive && !searchController.searchBar.text!.isEmpty {
                org = filteredList[indexPath.row]
            } else {
                org = dataList[indexPath.row]
            }
            
        cell.textLabel?.text = org.name
            
            return cell
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
