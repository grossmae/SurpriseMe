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
import RxSwift
import RxCocoa

class SMLocationManager: NSObject {
    
    static let LocationUpdatedNotification = "LocationUpdatedNotification"
    static let LocationUpdateFailedNotification = "LocationUpdateFailedNotification"
    static let LocationKey = "location"
    
    static let sharedInstance = SMLocationManager()
    
    let locationManager = CLLocationManager()
    var latestLocation: Variable<CLLocation?> = Variable(nil)
    
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
}