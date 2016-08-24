//
//  SMLocationManager.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/24/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation

import Foundation
import CoreLocation

class SMLocationManager: NSObject {
    
    static let LocationUpdatedNotification = "LocationUpdatedNotification"
    static let LocationUpdateFailedNotification = "LocationUpdateFailedNotification"
    static let LocationKey = "location"
    
    static let sharedInstance = SMLocationManager()
    
    let locationManager = CLLocationManager()
    var latestLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension SMLocationManager: CLLocationManagerDelegate {
    
    func locationManager( manager: CLLocationManager,
                          didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.first {
            NSNotificationCenter.defaultCenter().postNotificationName(SMLocationManager.LocationUpdatedNotification, object: self, userInfo: [SMLocationManager.LocationKey:latestLocation])
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSNotificationCenter.defaultCenter().postNotificationName(SMLocationManager.LocationUpdateFailedNotification, object: self, userInfo: nil)
    }
}