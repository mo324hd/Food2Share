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
    let phone: String
    let userType: String
    let isDeleted: Bool
    let createdAt: Date
}

extension AppUser {
    init?(document: DocumentSnapshot) {
        let data = document.data() ?? [:]

        // Required fields
        guard
            let email = data["email"] as? String,
            let phone = data["phone"] as? String
        else {
            print("❌ Critical fields missing:", document.documentID)
            return nil
        }

        // Flexible field names
        let fullname =
            data["fullname"] as? String ??
            data["fullName"] as? String ??
            "Unknown"

        let location =
            data["location"] as? String ?? "N/A"

        let userType =
            data["userType"] as? String ??
            data["role"] as? String ??
            "unknown"

        let isDeleted =
            data["isDeleted"] as? Bool ?? false

        let createdAt =
            (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()

        self.id = document.documentID
        self.fullname = fullname
        self.email = email
        self.location = location
        self.phone = phone
        self.userType = userType
        self.isDeleted = isDeleted
        self.createdAt = createdAt
    }

}



