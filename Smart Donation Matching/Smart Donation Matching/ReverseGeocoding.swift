//
//  ReverseGeocoding.swift
//  Smart Donation Matching
//
//  Created by 202300470 on 07/01/2026.
//
import UIKit
import MapKit

func searchLocation(_ cityName: String, completion: @escaping(CLLocationCoordinate2D?) -> Void)
{
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = cityName
    request.resultTypes = .address
    
    let search = MKLocalSearch(request: request)
    
    search.start { response, error in guard let mapItem = response?.mapItems.first, error == nil
        else
        {
            completion(nil)
            return
        }
        completion(mapItem.placemark.coordinate)
    }
}
func collectorCityName(for location: CLLocation, completion: @escaping(String?) -> Void)
{
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
        if let error = error
        {
            print("❌ Reverse geocoding failed: \(error.localizedDescription)")
            completion(nil)
            return
        }
        guard let placemark = placemarks?.first else { completion(nil); return }

        let city = placemark.locality ?? placemark.subLocality ?? placemark.administrativeArea ?? placemark.country ?? "Unknown"
        completion(city)
    }
}
