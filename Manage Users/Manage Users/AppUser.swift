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

    init?(document: DocumentSnapshot) {
        let data = document.data() ?? [:]

        self.id = document.documentID
        self.firstName = data["firstName"] as? String ?? "Unknown"
        self.lastName = data["lastName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.role = data["role"] as? String ?? "user"
        self.age = data["age"] as? Int ?? 0
        self.isActive = data["isActive"] as? Bool ?? false
    }
}



