//
//  DatabaseService.swift
//  DonateToCollector
//
//  Created by 202300470 on 01/01/2026.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class DonateToCollectorDatabaseService {
    static let sharedDatabase = DonateToCollectorDatabaseService()
    private let db = Firestore.firestore()
    private init() { }
    
    func fetchGroup(firstTable usersTableID: String, Completion: @escaping([BaseCollector]) -> Void)
    {
        let collectionPath = db.collection(usersTableID).whereField("userType", isEqualTo: "collector")
        
        collectionPath.getDocuments
        {
            snapshot, error in
            guard let documents = snapshot?.documents, error == nil else
            {
                Completion([]);
                return
            }
            if documents.isEmpty
            {
                Completion([])
                return
            }
            
            let rawDoc = snapshot?.documents ?? []
            
            if let rawFirst = rawDoc.first { print("first document data: \(rawFirst.data())") }
            
            let collectors: [BaseCollector] = snapshot?.documents.compactMap { doc -> BaseCollector? in return BaseCollector(id: doc.documentID, dict: doc.data()) } ?? []
            
            DispatchQueue.main.async { Completion(collectors) }
        }
    }
}
