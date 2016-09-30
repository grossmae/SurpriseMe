//
//  SMLocationManager.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/24/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation
import CoreLocation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
class SMLocationManager {
    
    static let sharedInstance = SMLocationManager()
    
    let locationManager = CLLocationManager()
    var latestLocation: Variable<CLLocation?> = Variable(nil)
    
    private init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func getLocation() -> Observable<[CLLocation]> {
        
        return locationManager.rx.didUpdateLocations
            .timeout(2, scheduler: MainScheduler.instance)
    }
}
