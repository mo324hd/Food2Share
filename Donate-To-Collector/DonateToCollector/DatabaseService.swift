//
//  DatabaseService.swift
//  DonateToCollector
//
//  Created by 202300470 on 01/01/2026.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class DatabaseService {
    static let sharedDatabase = DatabaseService()
    private let db = Firestore.firestore()
    private init() { }
    
    func fetchGroup(firstTable usersTableID: String, collectiongroupID collectionID: String, collectorgroupID collectorID: String, Completion: @escaping([BaseCollector]) -> Void)
    {
        let collectionPath = db.collection(usersTableID).document(collectionID).collection(collectorID)
        
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
