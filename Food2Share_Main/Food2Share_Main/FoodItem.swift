//
//  FoodItem.swift
//  Food2Share_Main
//
//  Created by BP-36-224-17 on 02/01/2026.
//

import Foundation

struct FoodItem: Equatable, Codable {
    
    var id: String
    var name: String
    var category: String
    var quantity_Size: String
    var production_Date: String
    var expiry_Date: String
    var usage: String
    var condition: String
    var status: String
}
