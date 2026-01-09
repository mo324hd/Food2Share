//
//  ViewController.swift
//  DonateToCollector
//
//  Created by 202300470 on 16/12/2025.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseFirestore

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var CollectorList: UICollectionView!
    
    var name: String = ""
    var isVerified: Bool = false
    var about: String = ""
    var arrCollectors = [BaseCollector]()
    let locationManager = CLLocationManager()
    var userCurrentLocation: CLLocation?
    weak var delegate: distanceUpdaterDelegate?
    let loadingIcon = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIcon.center = CGPoint(x: CollectorList.center.x, y: CollectorList.center.y - 150)
        loadingIcon.hidesWhenStopped = true
        CollectorList.addSubview(loadingIcon)
        loadingIcon.startAnimating()
        
        CollectorList.delegate = self
        CollectorList.dataSource = self
        locationManager.delegate = self
        
        CollectorList.layer.cornerRadius = 20
        CollectorList.layer.masksToBounds = true
        CollectorList.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.1)
        CollectorList.delegate = self
        CollectorList.dataSource = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        loadFirebaseData(userID: "3crcHBEDlkiB4XFyUFnn", collectorID: "collector")
        // Do any additional setup after loading the view.
    }
    
    func loadFirebaseData(userID: String, collectorID: String)
    {
        DatabaseService.sharedDatabase.fetchGroup(firstTable: "users", collectiongroupID: userID, collectorgroupID: collectorID)
        {
            [weak self] fetchedCollectors in self?.arrCollectors = fetchedCollectors
            
            self!.sortCollectorList()
            DispatchQueue.main.async
            {
                self?.CollectorList.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrCollectors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = CollectorList.dequeueReusableCell(withReuseIdentifier: "CollectorInfo", for: indexPath) as! CollectorCollectionViewCell
        
        let collector = arrCollectors[indexPath.row]
        cell.collector = collector
        
        cell.delegate = self
        cell.btnShowDetails.tag = collector.internalID
        
        cell.populateCell(image: UIImage(named: collector.logoName)!, verified: collector.isVerified, name: collector.name)
        
        return cell
    }
    
    func sortCollectorList()
    {
        guard !arrCollectors.isEmpty else { print("Waiting for Database"); return }
        guard let userLocation = userCurrentLocation else { print("Waiting for GPS"); return }
        
        arrCollectors.sort
        {
            let distance1 = userLocation.distance(from: $0.clLocation)
            let distance2 = userLocation.distance(from: $1.clLocation)
            
            return distance1 < distance2
        }
        
        DispatchQueue.main.async
        {
            self.CollectorList.reloadData()
            print("DEBUG: stopping loading animation")
            self.loadingIcon.stopAnimating()
        }
    }
}

extension ViewController: CollectorCollectionViewCellDelegate {
    
    func didTapDetails(for ID: Int)
    {
        if let selectedCollector = arrCollectors.first(where: {$0.internalID == ID})
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            
            detailsVC.collectorDetails = selectedCollector
            detailsVC.userLocation = userCurrentLocation
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension ViewController: distanceUpdaterDelegate
{
    func updateDistance(_ text: String) { }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    {
        switch manager.authorizationStatus
        {
            case .notDetermined:
                print("When user did not yet determined")
            case .restricted:
                print("Restricted by parental control")
            case .denied:
                print("When user select option Dont't Allow")
        case .authorizedAlways:
                    print("When user select option Change to Always Allow")
            case .authorizedWhenInUse:
                print("When user select option Allow While Using App or Allow Once")
                locationManager.requestAlwaysAuthorization()
            default:
                print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let userLocation = locations.first else {return}
        var distanceText: String = ""
        userCurrentLocation = userLocation
        
        arrCollectors.forEach { BaseCollector in
            let distanceMeters = userCurrentLocation!.distance(from: BaseCollector.clLocation)
            distanceText = distanceMeters > 1000 ? String(format: "%.2fKm", distanceMeters / 1000)
                                                     : String(format: "%.0fm", distanceMeters)
        }
        sortCollectorList()
        DispatchQueue.main.async
        {
            self.delegate?.updateDistance(distanceText)
            self.sortCollectorList()
        }
    }
}
