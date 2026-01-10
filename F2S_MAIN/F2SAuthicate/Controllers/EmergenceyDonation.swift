//
//  EmergenceyDonation.swift
//  DonationTask
//
//  Created by wael on 06/01/2026.
//

import UIKit

class EmergenceyDonation: UIViewController {
    
    
    @IBOutlet weak var dateLbl: UILabel!
    private var selectedDate: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        // Optional: placeholder
        dateLbl.text = "Select date"
        hideKeyboardWhenTappedAround()
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction private func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func selectDateClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Select Date", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.frame = CGRect(x: 0, y: 30, width: alert.view.bounds.width - 20, height: 180)
        alert.view.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            self.selectedDate = datePicker.date
            self.dateLbl.text = formatter.string(from: datePicker.date)
        }))
        
        present(alert, animated: true)
    }
    
    
}

