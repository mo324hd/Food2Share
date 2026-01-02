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

/*let CollectorDataset: [BaseCollector] = [
    BaseCollector(ID: 1, logo: UIImage(named: "flowerRose")!, isVerified: true, name: "Manama Food Bank", about: "We are the official Food Bank for the city of manama.", location: CLLocation(latitude:26.233975990984423, longitude: 50.57563725144137)),
    
    BaseCollector(ID: 2, logo: UIImage(named: "flowerRose")!, isVerified: false, name: "Manama Community Project", about: "We are a community project helping people get their food and reduce food waste.", location: CLLocation(latitude: 26.228289222589364, longitude: 50.584214634552914)),
    
    BaseCollector(ID: 3, logo: UIImage(named: "flowerRose")!, isVerified: true, name: "AL-ta'i Charity", about: "Like Hatim AL-ta'i, we are blessing the food insecure people with our generosity. Giving them enough high-quality food to enjoy.", location: CLLocation(latitude: 26.21913898120827, longitude: 50.58984712764015)),
    
    BaseCollector(ID: 4, logo: UIImage(named: "flowerRose")!, isVerified: true, name: "Scrooge Food Bank", about: "", location: CLLocation(latitude: 26.22120081950636, longitude: 50.57587156895715)),
    
    BaseCollector(ID: 5, logo: UIImage(named: "flowerRose")!, isVerified: false, name: "Manama Donation Team", about: "We are a group of people wanting to help food insecure groups.", location: CLLocation(latitude: 26.21037973947748, longitude: 50.587159755640705)),
    
    BaseCollector(ID: 6, logo: UIImage(named: "flowerRose")!, isVerified: false, name: "Manama Food Collecting", about: "I collect food to distrubute.", location: CLLocation(latitude: 26.217283091972956, longitude: 50.612991709920735)),
    
    BaseCollector(ID: 7, logo: UIImage(named: "colorful-background")!, isVerified: true, name: "Isa Town Food Bank", about: "The official Food Bank for Isa Town.", location: CLLocation(latitude: 26.1677087061629, longitude: 50.56203954614422)),
    
    BaseCollector(ID: 8, logo: UIImage(named: "colorful-background")!, isVerified: true, name: "Isa Town Groceries", about: "A groceries shop that collect food and distrbute it to vunruble groups.", location: CLLocation(latitude: 26.169812075584275, longitude: 50.55555316585335)),
    
    BaseCollector(ID: 9, logo: UIImage(named: "colorful-background")!, isVerified: false, name: "Helpsquad team", about: "", location: CLLocation(latitude: 26.16263035884549, longitude: 50.563846473248816)),
    
    BaseCollector(ID: 10, logo: UIImage(named: "colorful-background")!, isVerified: true, name: "Mohammed and Sons Warehouse", about: "A warehouse to collect large amounts of food.", location: CLLocation(latitude: 26.179426670186707, longitude: 50.54605223165239)),
    
    BaseCollector(ID: 11, logo: UIImage(named: "Hyrule-Map")!, isVerified: true, name: "Aali charity", about: "The official Food Charity for Aali.", location: CLLocation(latitude: 26.16337763478622, longitude: 50.515322909924336)),
    
    BaseCollector(ID: 12, logo: UIImage(named: "Hyrule-Map")!, isVerified: false, name: "Al-aali Warehouse", about: "Official warehouse for Aali.", location: CLLocation(latitude: 26.158682709035997, longitude: 50.51908368050695)),
    
    BaseCollector(ID: 13, logo: UIImage(named: "Hyrule-Map")!, isVerified: true, name: "Al-Sadah Food Bank", about: "", location: CLLocation(latitude: 26.156287810266054, longitude: 50.51946773478495)),
    
    BaseCollector(ID: 14, logo: UIImage(named: "Hyrule-Map")!, isVerified: false, name: "Aali Community Project", about: "", location: CLLocation(latitude: 26.153683705641942, longitude: 50.527548550772224))
]*/
