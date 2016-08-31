//
//  SMLocationManager.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/24/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class SMLocationManager {
    
    static let sharedInstance = SMLocationManager()
    
    let locationManager = CLLocationManager()
    var latestLocation: Variable<CLLocation?> = Variable(nil)
    
    private init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}