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
    let firstName: String
    let lastName: String
    let email: String
    let role: String
    let age: Int
    let isActive: Bool

    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    let isDeleted: Bool
    let deletedAt: Date?

    init?(document: DocumentSnapshot) {
        let data = document.data()
        guard
            let firstName = data?["firstName"] as? String,
            let lastName = data?["lastName"] as? String,
            let email = data?["email"] as? String,
            let role = data?["role"] as? String,
            let age = data?["age"] as? Int,
            let isActive = data?["isActive"] as? Bool
        else { return nil }

        self.id = document.documentID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.role = role
        self.age = age
        self.isActive = isActive

        self.isDeleted = data?["isDeleted"] as? Bool ?? false
        self.deletedAt = (data?["deletedAt"] as? Timestamp)?.dateValue()
    }
}



