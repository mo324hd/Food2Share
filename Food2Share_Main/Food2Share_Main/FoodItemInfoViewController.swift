//
//  FoodItemInfoViewController.swift
//  Food2Share_Main
//
//  Created by N M on 1/11/26.
//

import UIKit

class FoodItemInfoViewController: UIViewController {

    var receivedFoodItem: FoodItem?
    
    @IBOutlet weak var UsageConditionText: UITextView!
    @IBOutlet weak var StatusText: UITextView!
    @IBOutlet weak var DateText: UITextView!
    @IBOutlet weak var QuantitySizeText: UITextView!
    @IBOutlet weak var categoryText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let foodItem = receivedFoodItem {
            UsageConditionText.text = foodItem.usage_Condition
            StatusText.text = foodItem.status
            DateText.text = foodItem.dateValue
            QuantitySizeText.text = foodItem.quantity_Size
            categoryText.text = foodItem.category
            self.title = foodItem.name
        }
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
