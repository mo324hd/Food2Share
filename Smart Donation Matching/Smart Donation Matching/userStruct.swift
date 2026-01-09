//
//  userStruct.swift
//  Smart Donation Matching
//
//  Created by 202300470 on 05/01/2026.
//
import CoreLocation

struct Donor
{
    var documentID: String
    var internalID: Int
    var donorName: String
    var foodType: String
    var region: String
}

struct Collector
{
    var documentID: String
    var internalID: Int
    var collectorName: String
    var isVerified: Bool
    var logoName: String
    var acceptedTypes: [String]
    var location: CLLocation
    var city: String
}

struct Section
{
    let city: String
    let foodType: String
    let collectors: [Collector]
}
