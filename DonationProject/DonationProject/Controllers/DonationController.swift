//
//  DonationController.swift
//  DonationProject
//
//  Created by wael on 25/12/2025.
//

import UIKit

class DonationController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        
    }
    
    func configureTable() {
        let nib = UINib(nibName: "DonationCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "DonationCell")
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        
    }
    
    

    
    

}

extension DonationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell") as? DonationCell else {
            return UITableViewCell()
        }
        
        cell.onTimelineTapped = { [weak self] in
            guard let self = self else { return }
            presentVC(identifer: "MyDonation")
        }
        
        cell.onDistanceClicked = { [weak self] in
            guard let self = self else { return }
            presentVC(identifer: "MapVC")
        }
        
        cell.scanClicked = { [weak self] in
            guard let self = self else { return }
            presentSheetVC(identifer: "MapVC")
        }
        
        return cell
        
    }
    
    private func presentVC(identifer: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifer)
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.isModalInPresentation = true

        present(vc, animated: true)
    }
    
    private func presentSheetVC(identifer: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanSheet")
        
        vc.modalPresentationStyle = .formSheet
//        vc.modalTransitionStyle = .coverVertical
      //  vc.isModalInPresentation = true

        present(vc, animated: true)
    }

}
