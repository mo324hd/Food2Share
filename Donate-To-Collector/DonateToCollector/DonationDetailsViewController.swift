//
//  DonationDetailsViewController.swift
//  DonateToCollector
//
//  Created by JAGmer J on 02/01/2026.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class DonationDetailsViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtFoodType: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtNotes: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    @IBAction func btnRecordData()
    {
        view.endEditing(true)
        
        let foodType: String = self.txtFoodType.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let quantityString: String = self.txtQuantity.text?.trimmingCharacters(in: .whitespaces) ?? "0"
        
        if(foodType.isEmpty)
        {
            let alert = UIAlertController(title: "Empty Food Type!", message: "Please Fill \"Food Type\" Text box", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            txtFoodType.layer.borderColor = UIColor.red.cgColor
            txtFoodType.layer.borderWidth = 1.0
            return
        }
        if(quantityString.isEmpty)
        {
            let alert = UIAlertController(title: "Empty Quantity!", message: "Please Fill \"Quantity\" Text box", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            txtQuantity.layer.borderColor = UIColor.red.cgColor
            txtQuantity.layer.borderWidth = 1.0
            return
        }
        
        let quantityInt: Int = Int(quantityString) ?? 1
        let notes: String = self.txtNotes.text ?? ""
        let selectedDate: Date = self.DatePicker.date
        
        let logEntry: [String: Any] = [
            "Role": "donor",
            "Details": [
                "Food_Type": foodType,
                "Quantity": quantityInt,
                "Notes": notes,
                "Scheduled_Time": selectedDate,
                "timestamp": FieldValue.serverTimestamp()
            ]
        ]
        
        let db = Firestore.firestore()
        
        db.collection("DonorSubmissions").addDocument(data: logEntry) { error in
            
            if error == nil
            {
                let alert = UIAlertController(title: "Success!", message: "Your Data has been saved!", preferredStyle: .alert)
                let btnOKAction = UIAlertAction(title: "OK", style: .default) { _ in self.dismiss(animated: true, completion: nil) }
                alert.addAction(btnOKAction)
                self.present(alert, animated: true, completion: nil)
                print("Donor Food Info saved!")
            }
            else
            {
                print("Database error: \(error!.localizedDescription)")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFoodType.delegate = self
        txtQuantity.delegate = self
        txtNotes.delegate = self
        
        let customCGColor = UIColor(red: 74.0/255.0, green: 36.0/255.0, blue: 157.0/255.0, alpha: 1.0).cgColor
        setIcon(to: txtFoodType, systemName: "fork.knife.circle")
        addUnderline(to: txtFoodType, using: customCGColor)
        
        setIcon(to: txtQuantity, systemName: "numbers")
        addUnderline(to: txtQuantity, using: customCGColor)
        
        setIcon(to: txtNotes, systemName: "pencil.and.list.clipboard")
        addUnderline(to: txtNotes, using: customCGColor)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard when Enter is pressed
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func addUnderline(to textField: UITextField, using color: CGColor)
    {
        let underline = CALayer()
        underline.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        underline.backgroundColor = color
        
        textField.layer.addSublayer(underline)
        textField.borderStyle = .none
    }
    
    func setIcon(to textfield: UITextField, systemName: String)
    {
        let iconImageView = UIImageView(image: UIImage(systemName: systemName))
        iconImageView.tintColor = .systemGray
        iconImageView.contentMode = .scaleAspectFit
        
        let containerSize: CGFloat = 30
        let container = UIView(frame: CGRect(x: 0, y: 0, width: containerSize, height: containerSize))
        
        let iconSize: CGFloat = 25
        iconImageView.frame = CGRect(x: (containerSize - iconSize) / 2, y: (containerSize - iconSize) / 2, width: iconSize, height: iconSize)
        
        iconImageView.center = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        
        container.addSubview(iconImageView)
        textfield.leftView = container
        textfield.leftViewMode = .always
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
