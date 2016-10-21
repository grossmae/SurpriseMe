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
class SMLocationManager: NSObject {
    
    static let sharedInstance = SMLocationManager()
    
    let locationManager = CLLocationManager()
    var latestLocation: Variable<CLLocation?> = Variable(nil)
    
    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func getLocation() -> Observable<[CLLocation]> {
        
        return locationManager.rx.didUpdateLocations
            .timeout(2, scheduler: MainScheduler.instance)
    }
    
    func distanceTo(location: CLLocation) -> CLLocationDistance? {
        return latestLocation.value?.distance(from: location)
    }
}

extension SMLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latestLocation.value = locations.first
    }
}
