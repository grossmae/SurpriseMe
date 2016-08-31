//
//  MapViewController.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/31/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let mapView = MKMapView()
    
    let location: SMLocation
    
    init(location: SMLocation) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        mapView.showsUserLocation = true
    }
}