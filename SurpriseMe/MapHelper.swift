//
//  MapHelper.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 9/10/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation
import MapKit

class MapHelper {
    
    static func mapURLFromLocation(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) -> URL {
        let urlString = String(format: "http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f&dirflg=w",fromLocation.latitude, fromLocation.longitude, toLocation.latitude, toLocation.longitude)
        return URL(string: urlString)!
    }
    
}
