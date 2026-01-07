//
//  AppUser.swift
//  Admin Manage Users
//
//  Created by BP-36-201-10 on 07/12/2025.
//

import Foundation
import FirebaseFirestore


struct AppUser {
    let id: String
    let fullname: String
    let email: String
    let location: String
    let phone: Int
    let userType: String
    let isDeleted: Bool
    let createdAt: Date
}

extension AppUser {
    init?(document: DocumentSnapshot) {
        let data = document.data()
        
        guard
            let fullname = data?["fullname"] as? String,
            let email = data?["email"] as? String,
            let location = data?["location"] as? String,
            let phone = data?["phone"] as? Int,
            let userType = data?["userType"] as? String,
            let isDeleted = data?["isDeleted"] as? Bool,
            let timestamp = data?["createdAt"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.fullname = fullname
        self.email = email
        self.location = location
        self.phone = phone
        self.userType = userType
        self.isDeleted = isDeleted
        self.createdAt = timestamp.dateValue()
    }
}



