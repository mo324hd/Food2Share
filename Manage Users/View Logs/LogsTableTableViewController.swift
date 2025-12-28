//
//  LogsTableTableViewController.swift
//  ViewLogs
//
//  Created by BP-19-114-19 on 25/12/2025.
//

import UIKit
import FirebaseFirestore

class LogsTableViewController: UITableViewController, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        applyFilters()
    }
    
    private let db = Firestore.firestore()
    private var allLogs: [AppLog] = []
    private var filteredLogs: [AppLog] = []
    private var selectedAction: String? = nil
    private var startDate: Date? = nil
    private var endDate: Date? = nil
    
    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short   // "5 min ago", "2 hrs ago"
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func colorForLog(_ log: AppLog) -> UIColor {
        switch log.action {
        case "USER_DELETED":
            return .systemRed
        case "USER_RESTORED":
            return .systemGreen
        case "ROLE_CHANGED":
            return .systemOrange
        case "LOGIN":
            return .systemBlue
        case "LOGOUT":
            return .systemPurple
        default:
            // System logs or unknown actions
            return log.type == "system" ? .secondaryLabel : .label
        }
    }

    override func viewDidLoad() {
            super.viewDidLoad()
            title = "Activity Logs"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: "Action",
                style: .plain,
                target: self,
                action: #selector(showActionFilter)
            )
        ]
        navigationItem.rightBarButtonItems = [
        UIBarButtonItem(
              title: "Start Date",
              style: .plain,
              target: self,
              action: #selector(pickStartDate)
          ),
          UIBarButtonItem(
              title: "End Date",
              style: .plain,
              target: self,
              action: #selector(pickEndDate)
          )
        ]
            listenForLogs()
            setupSearch()
        }
    
    @objc private func pickStartDate() {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels

        let alert = UIAlertController(title: "Start Date", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(picker)

        picker.frame = CGRect(x: 0, y: 40, width: 270, height: 160)

        alert.addAction(UIAlertAction(title: "Apply", style: .default) { _ in
            self.startDate = picker.date
            self.applyFilters()
        })

        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.startDate = nil
            self.applyFilters()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func pickEndDate() {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels

        let alert = UIAlertController(title: "End Date", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(picker)

        picker.frame = CGRect(x: 0, y: 40, width: 270, height: 160)

        alert.addAction(UIAlertAction(title: "Apply", style: .default) { _ in
            self.endDate = picker.date
            self.applyFilters()
        })

        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.endDate = nil
            self.applyFilters()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func showActionFilter() {
        let alert = UIAlertController(
            title: "Filter by Action",
            message: nil,
            preferredStyle: .actionSheet
        )

        let actions = [
            "All",
            "USER_DELETED",
            "USER_RESTORED",
            "ROLE_CHANGED",
            "LOGIN",
            "LOGOUT",
            "SYSTEM"
        ]

        actions.forEach { action in
            alert.addAction(UIAlertAction(title: action, style: .default) { _ in
                self.selectedAction = action == "All" ? nil : action
                self.applyFilters()
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func listenForLogs() {
        db.collection("Logs")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                print("📦 snapshot count:", snapshot?.documents.count ?? -1)
                if let error = error {
                    print("❌ Log error:", error)
                    return
                }

                self?.allLogs = snapshot?.documents.compactMap {
                    AppLog(document: $0)
                } ?? []

                self?.applyFilters()
            }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)

    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search by User ID"
        navigationItem.searchController = searchController
    }
    
    private func applyFilters() {
        var results = allLogs
        
        // 🧰 Filter by action type
        if let action = selectedAction {
            if action == "SYSTEM" {
                results = results.filter { $0.type == "system" }
            } else {
                results = results.filter { $0.action == action }
            }
        }

        // 🔍 Search by userId
        if let query = searchController.searchBar.text,
           !query.isEmpty {
            results = results.filter {
                $0.userId?.lowercased().contains(query.lowercased()) == true
            }
        }

        // 🧰 Filter by log type
        switch currentFilter {
        case .user:
            results = results.filter { $0.type == "user" }
        case .system:
            results = results.filter { $0.type == "system" }
        case .all:
            break
        }
        
        // 📅 Date range filter
        if let start = startDate {
            results = results.filter {
                $0.timestamp >= start
            }
        }

        if let end = endDate {
            results = results.filter {
                $0.timestamp <= end
            }
        }

        filteredLogs = results
        tableView.reloadData()
    }
    enum LogFilter {
        case all, user, system
    }

    private var currentFilter: LogFilter = .all

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        filteredLogs.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "LogCell")

        let log = filteredLogs[indexPath.row]

        // 🔹 Title (action)
        cell.textLabel?.text = log.action
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        cell.textLabel?.textColor = colorForLog(log)

        // 🔹 Subtitle (source • user • time)
        let source = log.type.uppercased()
        let user = log.userId ?? "SYSTEM"
        let time = timeAgo(from: log.timestamp)

        cell.detailTextLabel?.text = "\(source) • \(user) • \(time)"
        cell.detailTextLabel?.textColor = .secondaryLabel

        // 🔹 LEFT INDICATOR DOT (ADD THIS HERE 👇)
        cell.imageView?.image = UIImage(systemName: "circle.fill")
        cell.imageView?.tintColor = colorForLog(log)

        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
