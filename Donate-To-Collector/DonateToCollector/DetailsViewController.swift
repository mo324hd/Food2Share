//
//  DetailsViewController.swift
//  DonateToCollector
//
//  Created by 202300470 on 17/12/2025.
//

import UIKit
import MapKit
import FirebaseFirestore

protocol distanceUpdaterDelegate: AnyObject
{
    func updateDistance(_ text: String)
}

class DetailsViewController: UIViewController {

    @IBOutlet weak var imgCollectorLogo: UIImageView!
    @IBOutlet weak var lblCollectorName: UILabel!
    @IBOutlet weak var lblCollectorLocation: UILabel!
    @IBOutlet weak var lblCollectorAboutMe: UILabel!
    
    var userLocation: CLLocation?
    var activeLog: String?
    var collectorDetails: BaseCollector?
    weak var delegate: distanceUpdaterDelegate?
    
    @IBAction func btnConfirmDonation(_ sender: UIButton)
    {
        let db = Firestore.firestore()
        db.collection("DonorSubmissions").whereField("Role", isEqualTo: "donor").order(by: "Details.timestamp", descending: true).limit(to: 1).getDocuments { (snapshot, error) in
            
            if let document = snapshot?.documents.first
            {
                let docID = document.documentID
                
                db.collection("DonorSubmissions").document(docID).updateData(["Selected Collector": self.lblCollectorName.text!]) { err in
                    
                    DispatchQueue.main.async
                    {
                        if err == nil
                        {
                            self.presentSuccessAlert(for: self.lblCollectorName.text!)
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
    
    func presentSuccessAlert(for collector: String) {
        let alert = UIAlertController(title: "Success!", message: "Your have been assignd to Collector: \(collector)",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Optional: Send them back to the main screen after clicking OK
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectorInfo = collectorDetails
        {
            imgCollectorLogo.image = UIImage(named: collectorInfo.logoName)
            lblCollectorName.text = collectorInfo.name
            if(collectorInfo.about == "")
            {
                lblCollectorAboutMe.text = "\"About Me\" is empty"
            }
            else
            {
                lblCollectorAboutMe.text = collectorInfo.about
            }
        }
        if let collectorDetails = collectorDetails, let userLocation = userLocation
        {
            let distanceMeters = userLocation.distance(from: collectorDetails.clLocation)
            let distanceText = distanceMeters > 1000 ? String(format: "%.2fKm", distanceMeters / 1000)
                                                     : String(format: "%.0fm", distanceMeters)
            lblCollectorLocation.text = distanceText
        }
        
        // Do any additional setup after loading the view.
    }
    
    func refreshDistance(_ text: String)
    {
        lblCollectorLocation.text = text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
