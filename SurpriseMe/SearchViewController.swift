//
//  SearchViewController.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/19/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

class SearchViewController: UIViewController {

    let searchButton: UIButton = {
       let searchButton = UIButton()
        searchButton.setTitle("Search", forState: .Normal)
        return searchButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchButton)
        searchButton.snp_makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.center.equalTo(0)
        }
        searchButton.addTarget(self, action: #selector(searchButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    func searchButtonPressed() {
        SMLocationManager.sharedInstance.locationManager.requestWhenInUseAuthorization()
        SMLocationManager.sharedInstance.locationManager.startUpdatingLocation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(locationUpdated), name: SMLocationManager.LocationUpdatedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(locationUpdateFailed), name: SMLocationManager.LocationUpdateFailedNotification, object: nil)
    }
    
    func locationUpdated(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if let location = notification.userInfo?[SMLocationManager.LocationKey] as? CLLocation {
//            goToMapWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationUpdateFailed(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

