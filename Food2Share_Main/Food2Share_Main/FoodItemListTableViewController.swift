//
//  FoodItemListTableViewController.swift
//  Food2Share_Main
//
//  Created by N M on 1/10/26.
//

import UIKit

class FoodItemListTableViewController: UITableViewController {
    
    @IBOutlet var FoodList: UITableView!
    
    var foodItems: [FoodItem] = [
        FoodItem(id: "F001", name: "Bananas", category: "Fruits", quantity_Size: "1.2 kg", dateValue: "2026-01-10", status: "Fresh", usage_Condition: "Ready to eat"),
        FoodItem(id: "F002", name: "Whole Milk", category: "Dairy", quantity_Size: "1 L", dateValue: "2026-01-15", status: "Cold Storage", usage_Condition: "Keep refrigerated"),
        FoodItem(id: "F003", name: "Cheddar Cheese", category: "Dairy", quantity_Size: "200 g", dateValue: "2026-03-01", status: "Fresh", usage_Condition: "Keep sealed"),
        FoodItem(id: "F004", name: "Brown Rice", category: "Grains", quantity_Size: "5 kg", dateValue: "2027-04-10", status: "Dry", usage_Condition: "Store in cool, dry place"),
        FoodItem(id: "F005", name: "Chicken Breast", category: "Meat", quantity_Size: "2 pieces", dateValue: "2026-01-12", status: "Frozen", usage_Condition: "Cook before end date"),
        FoodItem(id: "F006", name: "Salmon Fillet", category: "Seafood", quantity_Size: "400 g", dateValue: "2026-01-11", status: "Frozen", usage_Condition: "Defrost before cooking"),
        FoodItem(id: "F007", name: "Broccoli", category: "Vegetables", quantity_Size: "500 g", dateValue: "2026-01-09", status: "Fresh", usage_Condition: "Use within 2 days"),
        FoodItem(id: "F008", name: "Olive Oil", category: "Pantry", quantity_Size: "750 ml", dateValue: "2027-06-30", status: "Pantry", usage_Condition: "Store away from heat"),
        FoodItem(id: "F009", name: "Greek Yogurt", category: "Dairy", quantity_Size: "1 cup (200 g)", dateValue: "2026-01-14", status: "Chilled", usage_Condition: "Consume soon after opening"),
        FoodItem(id: "F010", name: "Strawberries", category: "Fruits", quantity_Size: "250 g", dateValue: "2026-01-08", status: "Fresh", usage_Condition: "Wash before eating"),
        FoodItem(id: "F011", name: "Eggs", category: "Dairy", quantity_Size: "12 pcs", dateValue: "2026-02-01", status: "Refrigerated", usage_Condition: "Keep refrigerated"),
        FoodItem(id: "F012", name: "Tomato Sauce", category: "Pantry", quantity_Size: "500 ml", dateValue: "2027-07-21", status: "Unopened", usage_Condition: "Refrigerate after opening"),
        FoodItem(id: "F013", name: "Lettuce", category: "Vegetables", quantity_Size: "1 head", dateValue: "2026-01-09", status: "Fresh", usage_Condition: "Keep in crisper"),
        FoodItem(id: "F014", name: "Ground Beef", category: "Meat", quantity_Size: "1 lb", dateValue: "2026-01-11", status: "Frozen", usage_Condition: "Cook thoroughly"),
        FoodItem(id: "F015", name: "Orange Juice", category: "Beverages", quantity_Size: "1 L", dateValue: "2026-01-25", status: "Fresh", usage_Condition: "Shake well before use"),
        FoodItem(id: "F016", name: "Canned Tuna", category: "Seafood", quantity_Size: "185 g", dateValue: "2028-02-18", status: "Canned", usage_Condition: "Store in pantry"),
        FoodItem(id: "F017", name: "Almond Butter", category: "Pantry", quantity_Size: "340 g", dateValue: "2027-03-05", status: "Unopened", usage_Condition: "Store away from sunlight"),
        FoodItem(id: "F018", name: "Spinach", category: "Vegetables", quantity_Size: "250 g", dateValue: "2026-01-09", status: "Fresh", usage_Condition: "Keep chilled"),
        FoodItem(id: "F019", name: "Pasta (Fusilli)", category: "Grains", quantity_Size: "1 kg", dateValue: "2027-12-01", status: "Dry", usage_Condition: "Store in airtight container"),
        FoodItem(id: "F020", name: "Butter", category: "Dairy", quantity_Size: "250 g", dateValue: "2026-02-20", status: "Chilled", usage_Condition: "Keep refrigerated")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        FoodList.dataSource = self
        FoodList.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath)
        let foodItem = foodItems[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = foodItem.name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ToFoodItemInfo", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFoodItemInfo" {
            if let destination = segue.destination as? FoodItemInfoViewController {
                if let indexPath = FoodList.indexPathForSelectedRow {
                    destination.receivedFoodItem = foodItems[indexPath.row]
                }
            }
        }
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            foodItems.remove(at: indexPath.row)
            FoodList.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            print("hello")
            //performSegue(withIdentifier: "ToAddFoodItem", sender: self)
        }
    }

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
