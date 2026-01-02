//
//  appLogs.swift
//  ViewLogs
//
//  Created by BP-19-114-19 on 25/12/2025.
//

import Foundation
import FirebaseFirestore

struct AppLog {
    let id: String
    let timestamp: Date
    let type: String        // user | system
    let action: String
    let userId: String?
    let userRole: String?
    let message: String

    init?(document: DocumentSnapshot) {
        let data = document.data() ?? [:]

        guard
            let timestamp = data["timestamp"] as? Timestamp,
            let type = data["type"] as? String,
            let action = data["action"] as? String,
            let message = data["message"] as? String
        else {
            return nil
        }

        self.id = document.documentID
        self.timestamp = timestamp.dateValue()
        self.type = type
        self.action = action
        self.userId = data["userId"] as? String
        self.userRole = data["userRole"] as? String
        self.message = message
    }
}
