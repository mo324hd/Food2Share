//
//  collectorStruct.swift
//  DonateToCollector
//
//  Created by 202300470 on 16/12/2025.
//

import Foundation
import UIKit
import MapKit
import FirebaseFirestore

struct BaseCollector: Identifiable, Codable
{
    var id: String
    var internalID: Int
    var isVerified: Bool
    var name: String
    var logoName: String
    var about: String
    var location: GeoPoint
    var clLocation: CLLocation { CLLocation(latitude: location.latitude, longitude: location.longitude) }
    
    init?(id: String, dict: [String: Any]) {
        guard let name = dict["Full_Name"] as? String,
              let logoName = dict["LogoName"] as? String,
              let internalID = dict["ID"] as? Int,
              let about = dict["About_Me"] as? String,
              let isVerified = dict["isVerified"] as? Bool,
              let location = dict["location"] as? GeoPoint else { return nil }
        
        if(logoName.isEmpty == true)
        {
            self.logoName = "default-logo"
        }
        else
        {
            self.logoName = logoName
        }
                
        self.id = id
        self.internalID = internalID
        self.name = name
        self.about = about
        self.isVerified = isVerified
        self.location = location
    }
}
