//
//  FoodDetailViewController.swift
//  Food2Share_Main
//
//  Created by BP-36-224-17 on 02/01/2026.
//

import UIKit
import FirebaseDatabase

class FoodDetailViewController: UIViewController {

    var foodItem: FoodItem!
        private var ref: DatabaseReference!
        
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var categoryLabel: UILabel!
        @IBOutlet weak var quantityLabel: UILabel!
        @IBOutlet weak var usageLabel: UILabel!
        @IBOutlet weak var conditionLabel: UILabel!
        @IBOutlet weak var statusLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Item Info"
            ref = Database.database().reference().child("food_item")
            setupNavigationBar()
            displayInfo()
        }
        
        func setupNavigationBar() {
            let editMenu = UIMenu(title: "Manage Item", children: [
                UIAction(title: "Update", image: UIImage(systemName: "square.and.pencil")) { _ in
                    self.updateItem()
                },
                UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.confirmDelete()
                }
            ])
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                                image: UIImage(systemName: "ellipsis.circle"),
                                                                primaryAction: nil,
                                                                menu: editMenu)
        }
        
        func displayInfo() {
            nameLabel.text = foodItem.name
            categoryLabel.text = foodItem.category
            quantityLabel.text = foodItem.quantity_Size
            usageLabel.text = foodItem.usage
            conditionLabel.text = foodItem.condition
            statusLabel.text = foodItem.status
        }
        
        func updateItem() {
            let vc = AddFoodItemViewController()
            vc.isEditingItem = true
            vc.foodItemToEdit = foodItem
            navigationController?.pushViewController(vc, animated: true)
        }
        
        func confirmDelete() {
            let alert = UIAlertController(title: "Delete Item?",
                                          message: "Are you sure you want to permanently delete this food item?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.ref.child(self.foodItem.id).removeValue()
                self.navigationController?.popViewController(animated: true)
            })
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
