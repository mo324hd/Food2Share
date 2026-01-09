//
//  ViewController.swift
//  Smart Donation Matching
//
//  Created by 202300470 on 04/01/2026.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var collectorList: UICollectionView!
    
    var groupedCollectors: [String: [String: [Collector]]] = [:]
    var cityName: String?
    var donorCoordinate: CLLocationCoordinate2D?
    var selectedType: String?
    var Collectors: [Collector] = []
    var groupedCities: [String] = []
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectorList.layer.cornerRadius = 20
        collectorList.layer.masksToBounds = true
        collectorList.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.1)
        collectorList.delegate = self
        collectorList.dataSource = self
        collectorList.register(UINib(nibName: "CollectionHeaderUICollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        
        if let donorCoordinate = donorCoordinate
        {
            let donorLocation = CLLocation(latitude: donorCoordinate.latitude, longitude: donorCoordinate.longitude)
            sortCollectors(by: donorLocation) { sortedCollectors in
                self.Collectors = sortedCollectors
                self.sections = self.buildSections(from: self.Collectors, selectedType: self.selectedType)
                self.collectorList.reloadData()
            }
        }
        
        fetchCollectors
        {
            [weak self] collectors in
            self?.sections = self?.buildSections(from: collectors, selectedType: self!.selectedType) ?? []
            
            DispatchQueue.main.async
            {
                print("Reloading collectionView")
                self?.collectorList.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    func fetchCollectors(completion: @escaping([Collector]) -> Void)
    {
        let db = Firestore.firestore()
        
        let collectorPath = db.collection("users").document("3crcHBEDlkiB4XFyUFnn").collection("collector")
        collectorPath.getDocuments { snapshot, error in
            if let error = error
            {
                print("Firestore error: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let documents = snapshot?.documents, error == nil else { completion([]); return }
            
            self.Collectors = documents.compactMap { doc in let data = doc.data()
                guard
                      let id = data["ID"] as? Int,
                      let name = data["Full_Name"] as? String,
                      let isVerified = data["isVerified"] as? Bool,
                      let geoLocation = data["location"] as? GeoPoint,
                      let acceptedTypes = data["Accepted_Food_Types"] as? [String]
                else { return nil }
                
                let location = CLLocation(latitude: geoLocation.latitude, longitude: geoLocation.longitude)
                let logoName = (data["LogoName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                let safeLogoName = (logoName?.isEmpty == false) ? logoName! : "default-logo"
                
                return Collector(documentID: doc.documentID, internalID: id, collectorName: name, isVerified: isVerified, logoName: safeLogoName, acceptedTypes: acceptedTypes, location: location, city: "Loading...")
            }
            
            let group = DispatchGroup()
            
            for(index, collector) in self.Collectors.enumerated()
            {
                group.enter()
                collectorCityName(for: collector.location) { city in
                    self.Collectors[index].city = city ?? "Unknown"
                    group.leave()
                }
            }
            
            group.notify(queue: .main)
            {
                self.sections = self.buildSections(from: self.Collectors, selectedType: self.selectedType)
                self.collectorList.reloadData()
            }
            
            completion(self.Collectors)
        }
    }
    
    
    func isCloser(_ c1: Collector, _ c2: Collector, donorLocation: CLLocation) -> Bool
    {
        let d1 = donorLocation.distance(from: c1.location)
        let d2 = donorLocation.distance(from: c2.location)
        return d1 < d2
    }
    
    
    func groupCollectors(_ collectors: [Collector])
    {
        groupedCollectors = Dictionary(grouping: collectors, by: { $0.city }).mapValues { cityGroup in
            Dictionary(grouping: cityGroup, by: { $0.acceptedTypes.joined(separator: ", ") })
        }
        groupedCities = Array(groupedCollectors.keys).sorted()
    }
    
    func buildSections(from collectors: [Collector], selectedType: String?) -> [Section]
    {
        var resultSection: [Section] = []
        let groupedByCity = Dictionary(grouping: collectors, by: { $0.city })
        var cityOrder: [String] = []
        
        for c in collectors
        {
            if !cityOrder.contains(c.city)
            {
                cityOrder.append(c.city)
            }
        }
        
        for(city, cityCollectors) in groupedByCity
        {
            let allTypes = Set(cityCollectors.flatMap { $0.acceptedTypes })
            
            let sortedTypes = allTypes.sorted { type1, type2 in
                
                if type1 == selectedType
                {
                    return true;
                }
                if type2 == selectedType
                {
                    return false;
                }
                return type1 < type2
            }
            
            for type in sortedTypes
            {
                let typeCollectors = cityCollectors.filter { $0.acceptedTypes.contains(type) }.sorted { c1, c2 in
                    let donorLocation = CLLocation(latitude: donorCoordinate!.latitude, longitude: donorCoordinate!.longitude)
                    
                    return isCloser(c1, c2, donorLocation: donorLocation)
                }
                resultSection.append(Section(city: city, foodType: type, collectors: typeCollectors))
            }
        }
        return resultSection
    }
    
    func sortCollectors(by donorLocation: CLLocation, completion: @escaping ([Collector]) -> Void)
    {
        let sorted = Collectors.sorted { (c1: Collector, c2: Collector) in
            let d1 = donorLocation.distance(from: CLLocation(latitude: c1.location.coordinate.latitude, longitude: c1.location.coordinate.longitude))
            let d2 = donorLocation.distance(from: CLLocation(latitude: c2.location.coordinate.latitude, longitude: c2.location.coordinate.longitude))
            return d1 < d2
        }
        completion(sorted)
    }
    
    func ConfirmDonation(with collectorName: String)
    {
        let db = Firestore.firestore()
        db.collection("DonorSubmissions").document("Recommended").collection("Submitted_Donations").whereField("Role", isEqualTo: "donor").order(by: "Details.timestamp", descending: true).limit(to: 1).getDocuments { (snapshot, error) in
            
            if let document = snapshot?.documents.first
            {
                let docID = document.documentID
                
                print("updating document: \(docID) with collector: \(collectorName)")
                db.collection("DonorSubmissions").document("Recommended").collection("Submitted_Donations").document(docID).updateData(["Selected Collector": collectorName]) { err in
                    
                    DispatchQueue.main.async
                    {
                        if err == nil
                        {
                            self.presentSuccessAlert(for: collectorName)
                        }
                        else
                        {
                            print("No recent requests found: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
            }
        }
    }
    func presentSuccessAlert(for collector: String)
    {
        let alert = UIAlertController(title: "Success!", message: "Your have been assignd to Collector: \(collector)",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Optional: Send them back to the main screen after clicking OK
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].collectors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectorList.dequeueReusableCell(withReuseIdentifier: "CollectorInfo", for: indexPath) as! CollectorCollectionViewCell
        
        guard indexPath.section < sections.count else { return UICollectionViewCell() }
        
        let collector = sections[indexPath.section].collectors[indexPath.item]
        cell.lblCollectorName.text = collector.collectorName
        
        print("✅ Populating cell with collector: \(collector.collectorName)")
        cell.populateCell(image: UIImage(named: collector.logoName)!, verified: collector.isVerified, name: collector.collectorName)
        
        cell.onDonate = { [weak self] collectorName in
            self?.ConfirmDonation(with: collectorName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if(kind == UICollectionView.elementKindSectionHeader)
        {
            let header = collectorList.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CollectionHeaderUICollectionReusableView
            
            let section = sections[indexPath.section]
            header.headerLabel.text = "\(section.city) - \(section.foodType)"
            
            return header
        }

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    
}
