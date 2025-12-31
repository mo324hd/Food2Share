//
//  AuditLogger.swift
//  Manage Users
//
//  Created by BP-19-114-19 on 27/12/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct AuditLogger {

    private static let db = Firestore.firestore()

    static func log(
        action: String,
        message: String,
        targetUserId: String? = nil
    ) {
        print("🧾 Attempting to write log:", action)

        let userId = Auth.auth().currentUser?.uid ?? "SYSTEM_ADMIN"

        let logData: [String: Any] = [
            "timestamp": Timestamp(),
            "type": "admin",
            "action": action,
            "userId": userId,
            "userRole": "admin",
            "message": message
        ]

        db.collection("Logs").addDocument(data: logData) { error in
            if let error = error {
                print("❌ Log write failed:", error)
            } else {
                print("✅ Log written successfully")
            }
        }
    }
}
