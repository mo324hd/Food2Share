//
//  AddFoodItemViewController.swift
//  Food2Share_Main
//
//  Created by BP-36-224-17 on 02/01/2026.
//

import UIKit
import FirebaseDatabase

class AddFoodItemViewController: UIViewController {

    var isEditingItem = false
        var foodItemToEdit: FoodItem?
        private var ref: DatabaseReference!
        
        @IBOutlet weak var nameField: UITextField!
        @IBOutlet weak var categoryField: UITextField!
        @IBOutlet weak var quantityField: UITextField!
        @IBOutlet weak var productionDateField: UITextField!
        @IBOutlet weak var expiryDateField: UITextField!
        @IBOutlet weak var usageField: UITextField!
        @IBOutlet weak var conditionField: UITextField!
        @IBOutlet weak var statusField: UITextField!
        @IBOutlet weak var actionButton: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            ref = Database.database().reference().child("food_item")
            
            title = isEditingItem ? "Update Food Item" : "Add Food Item"
            actionButton.setTitle(isEditingItem ? "Update" : "Add", for: .normal)
            
            if isEditingItem {
                populateFields()
                actionButton.isEnabled = false
                actionButton.alpha = 0.5
            }
            
            setupFieldChangeObservation()
        }
        
        func populateFields() {
            guard let item = foodItemToEdit else { return }
            nameField.text = item.name
            categoryField.text = item.category
            quantityField.text = item.quantity_Size
            productionDateField.text = item.production_Date
            expiryDateField.text = item.expiry_Date
            usageField.text = item.usage
            conditionField.text = item.condition
            statusField.text = item.status
        }
        
        func setupFieldChangeObservation() {
            [nameField, categoryField, quantityField, productionDateField,
             expiryDateField, usageField, conditionField, statusField].forEach {
                $0?.addTarget(self, action: #selector(fieldsDidChange), for: .editingChanged)
            }
        }
        
        @objc func fieldsDidChange() {
            guard isEditingItem, let original = foodItemToEdit else {
                actionButton.isEnabled = true
                actionButton.alpha = 1.0
                return
            }
            
            let current = FoodItem(
                id: original.id,
                name: nameField.text ?? "",
                category: categoryField.text ?? "",
                quantity_Size: quantityField.text ?? "",
                production_Date: productionDateField.text ?? "",
                expiry_Date: expiryDateField.text ?? "",
                usage: usageField.text ?? "",
                condition: conditionField.text ?? "",
                status: statusField.text ?? ""
            )
            let hasChanged = current != original
            actionButton.isEnabled = hasChanged
            actionButton.alpha = hasChanged ? 1.0 : 0.5
        }
        
        @IBAction func actionButtonTapped(_ sender: UIButton) {
            guard validateFields() else { return }
            
            let alert = UIAlertController(title: isEditingItem ? "Confirm Update" : "Confirm Add",
                                          message: isEditingItem ? "Apply changes to this food item?" : "Add this new food item?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                self.isEditingItem ? self.updateItem() : self.addItem()
            })
            present(alert, animated: true)
        }
        
        func validateFields() -> Bool {
            let fields = [nameField, categoryField, quantityField, productionDateField, expiryDateField, usageField, conditionField, statusField]
            for field in fields {
                if (field?.text ?? "").isEmpty {
                    showAlert(title: "Missing Field", message: "Please fill all fields before proceeding.")
                    return false
                }
            }
            return true
        }
        
        func addItem() {
            let id = ref.childByAutoId().key ?? UUID().uuidString
            let item = FoodItem(id: id,
                                name: nameField.text ?? "",
                                category: categoryField.text ?? "",
                                quantity_Size: quantityField.text ?? "",
                                production_Date: productionDateField.text ?? "",
                                expiry_Date: expiryDateField.text ?? "",
                                usage: usageField.text ?? "",
                                condition: conditionField.text ?? "",
                                status: statusField.text ?? "")
            ref.child(id).setValue(try? item.asDictionary())
            navigationController?.popViewController(animated: true)
        }
        
        func updateItem() {
            guard let id = foodItemToEdit?.id else { return }
            let updated = [
                "name": nameField.text ?? "",
                "category": categoryField.text ?? "",
                "quantitySize": quantityField.text ?? "",
                "productionDate": productionDateField.text ?? "",
                "expiryDate": expiryDateField.text ?? "",
                "usageState": usageField.text ?? "",
                "condition": conditionField.text ?? "",
                "status": statusField.text ?? ""
            ]
            ref.child(id).updateChildValues(updated)
            navigationController?.popViewController(animated: true)
        }

        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
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
