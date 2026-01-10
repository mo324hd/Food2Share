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
        targetUserId: String? = nil
    ) {
        print("🧾 Attempting to write log:", action)

        let adminId = Auth.auth().currentUser?.uid ?? "SYSTEM_ADMIN"


        let actionWithTarget: String
        if let targetUserId = targetUserId {
            actionWithTarget = "\(action) - \(targetUserId)"
        } else {
            actionWithTarget = action
        }

        let logData: [String: Any] = [
            "timestamp": Timestamp(),
            "type": "admin",
            "action": actionWithTarget,
            "userId": adminId,
            "userRole": "admin",
            "message": actionWithTarget  
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
