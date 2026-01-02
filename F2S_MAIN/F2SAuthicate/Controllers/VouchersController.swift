//
//  VouchersController.swift
//  F2SAuthicate
//
//  Created by abdulaziz on 19/12/2025.
//

import UIKit

class VouchersController: UIViewController {
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var activeButt: UIButton!
    @IBOutlet weak var usedButt: UIButton!
    @IBOutlet weak var expiredButt: UIButton!
    
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet weak var usedlbl: UILabel!
    @IBOutlet weak var expiredLbl: UILabel!
    
    
    private var currentState: VoucherState = .active
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CouponCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "CouponCell")
        table.delegate = self
        table.dataSource = self
        
        configureInitialUI()
    }
    
    private func configureInitialUI() {
        updateUI(for: .active)
    }
    
    @IBAction func activeTapped(_ sender: UIButton) {
        updateUI(for: .active)
    }

    @IBAction func usedTapped(_ sender: UIButton) {
        updateUI(for: .used)
    }

    @IBAction func expiredTapped(_ sender: UIButton) {
        updateUI(for: .expired)
    }

    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    private func updateUI(for state: VoucherState) {
        currentState = state

        // Reset buttons
        let buttons = [activeButt, usedButt, expiredButt]
        buttons.forEach {
            $0?.backgroundColor = .white
        }

        // Reset underline labels (unselected = white)
        let labels = [activeLbl, usedlbl, expiredLbl]
        labels.forEach {
            $0?.backgroundColor = .white
        }

        // Apply selected state
        switch state {
        case .active:
            activeButt.backgroundColor = .clear
            activeLbl.backgroundColor = .black

        case .used:
            usedButt.backgroundColor = .clear
            usedlbl.backgroundColor = .black

        case .expired:
            expiredButt.backgroundColor = .clear
            expiredLbl.backgroundColor = .black
        }

        table.reloadData()
    }

    
}

extension VouchersController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentState {
        case .active:
            return 4
        case .used:
            return 2
        case .expired:
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell") as? CouponCell else {
            return UITableViewCell()
        }
        
        
        
        return cell
        
    }
    
}

enum VoucherState {
    case active
    case used
    case expired
}
