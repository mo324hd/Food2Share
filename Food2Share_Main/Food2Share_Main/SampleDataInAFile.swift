//
//  SampleDataInAFile.swift
//  Food2Share_Main
//
//  Created by N M on 1/7/26.
//

import Foundation

struct Organization {
    var id: String
    var name: String
    var campaigns: [Campaign]
    var description: String
    var address: String
    var communication: String
}

struct Campaign {
    var id: String
    var name: String
    var progressNumber: Int
    var goalNumber: Int
    var organizedBy: String
    var dateValue: String
    var description: String
}

struct FoodItem {
    var id: String
    var name: String
    var category: String
    var quantity_Size: String
    var dateValue: String
    var status: String
    var usage_Condition: String
}


