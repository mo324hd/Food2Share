//
//  DonationDetailsViewController.swift
//  Smart Donation Matching
//
//  Created by 202300470 on 04/01/2026.
//

import UIKit
import MapKit
import FirebaseCore
import FirebaseFirestore

class SmartDonationMatchingDonationDetailsViewController: UIViewController {

    @IBOutlet weak var foodTypePicker: UIPickerView!
    @IBOutlet weak var txtCity: UITextField!
    let foodTypes: [String] = ["Fruit", "Vegetable", "Grains", "Protein Food", "Diary"]
    var selectedFoodType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTypePicker.delegate = self
        foodTypePicker.dataSource = self
        txtCity.delegate = self
        
        setIcon(to: txtCity, systemName: "globe")
        addUnderline(to: txtCity, using: UIColor(red: 74.0/255.0, green: 36.0/255.0, blue: 157.0/255.0, alpha: 1.0).cgColor)
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    @IBAction func btnRecordData()
    {
        view.endEditing(true)
        
        let city: String = self.txtCity.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard let foodType = selectedFoodType else { print("⚠️ No food type selected"); return }
        
        print("City text raw:", txtCity.text ?? "nil")
        if(city.isEmpty)
        {
            let alert = UIAlertController(title: "Empty City!", message: "Please Fill \"City\" Text box", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            txtCity.layer.borderColor = UIColor.red.cgColor
            txtCity.layer.borderWidth = 1.0
            return
        }
        
        let logEntry: [String: Any] = [
            "Role": "donor",
            "Details": [
                "Food_Type": foodType,
                "City": city,
                "timestamp": FieldValue.serverTimestamp()
            ]
        ]
        
        let db = Firestore.firestore()
        
        db.collection("DonorSubmissions").document("Recommended").collection("Submitted_Donations").addDocument(data: logEntry) { error in
            
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
        searchLocation(txtCity.text!) { coordinate in guard let coordinate = coordinate
            else
            {
                return
            }
            self.performSegue(withIdentifier: "showCollectorsSegue", sender: coordinate)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showCollectorsSegue", let destinationVC = segue.destination as? SmartDonationMatchingViewController, let donorCoordinate = sender as? CLLocationCoordinate2D
        {
            destinationVC.cityName = txtCity.text
            destinationVC.donorCoordinate = donorCoordinate
            destinationVC.selectedType = selectedFoodType
        }
    }
}

extension SmartDonationMatchingDonationDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return foodTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return foodTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFoodType = foodTypes[row]
    }
    
}

extension SmartDonationMatchingDonationDetailsViewController: UITextFieldDelegate, UITextViewDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
