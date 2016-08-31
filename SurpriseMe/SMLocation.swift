//
//  SMLocation.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/31/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//
import CoreLocation

struct SMLocation {
    
    let coordinates: CLLocationCoordinate2D
    let yelpID: String
    let name: String
    let address: SMAddress
    let phoneNumber: String?
    let websiteURL: NSURL?
    
    let price: SMPrice
    let rating: SMRating
    let reviewCount: Int
    
    
    let categories: [SMCategory]
    var openTimes: [SMHours]?
}