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
    }
}

