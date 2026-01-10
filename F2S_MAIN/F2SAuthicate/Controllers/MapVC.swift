//
//  MapVC.swift
//  DonationProject
//
//  Created by wael on 26/12/2025.
//


import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!       // <- Add label below map in Storyboard

    private let locationManager = CLLocationManager()
    private var userCoordinate: CLLocationCoordinate2D?
    private var destinationCoordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        setupLocationManager()

        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        checkAuthorization()
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: Location Access
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationDeniedAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default: break
        }
    }

    private func showLocationDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Disabled",
            message: "Enable location access in Settings to show directions.",
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Open Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true)
    }

    // MARK: Build Route
    private func configureMap() {
        guard let userCoord = userCoordinate else { return }

        let meters: Double = 2000
        let destCoord = CLLocationCoordinate2D(
            latitude: userCoord.latitude + (meters / 111_000.0),
            longitude: userCoord.longitude
        )
        self.destinationCoordinate = destCoord

        let userPin = MKPointAnnotation()
        userPin.title = "You"
        userPin.coordinate = userCoord

        let destPin = MKPointAnnotation()
        destPin.title = "Driver"
        destPin.coordinate = destCoord

        mapView.addAnnotations([userPin, destPin])

        drawRoute(from: userCoord, to: destCoord)
    }

    private func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: source))
        request.destination = MKMapItem(placemark: .init(coordinate: destination))
        request.transportType = .walking     // change to .automobile for driving

        MKDirections(request: request).calculate { [weak self] response, error in
            guard let self = self else { return }
            guard error == nil, let route = response?.routes.first else {
                print("route error:", error?.localizedDescription ?? "unknown")
                return
            }

            // draw polyline
            self.mapView.addOverlay(route.polyline)

            // fit map to show full route
            self.mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 80, left: 20, bottom: 80, right: 20),
                animated: true
            )

            // update label: Distance + ETA
            let km = route.distance / 1000
            let minutes = Int(route.expectedTravelTime / 60)
            self.distanceLabel.text = String(format: "Distance: %.2f km — ETA: %d min", km, minutes)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapVC: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        userCoordinate = loc.coordinate
        locationManager.stopUpdatingLocation()
        configureMap()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location err:", error)
    }
}

// MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let r = MKPolylineRenderer(polyline: polyline)
            r.strokeColor = UIColor.systemPurple
            r.lineWidth = 4
            r.lineCap = .round
            return r
        }
        return MKOverlayRenderer()
    }
}
