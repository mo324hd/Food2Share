//
//  Notifications.swift
//  DonationProject
//
//  Created by wael on 25/12/2025.
//

import UIKit

class Notifications: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        
    }
    
    func configureTable() {
        
        let nib = UINib(nibName: "NotCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "NotCell")
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        
    }
    
    

}

extension Notifications: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotCell") as? NotCell else {
            return UITableViewCell()
        }
        
        
        
        return cell
        
    }
    
}
