//
//  SMErrorAlertFactory.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 9/16/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit

class SMErrorAlertFactory {
    
    static let dismissAction = UIAlertAction(title: "ok".localized, style: .Default) { (action) in
        
    }
    
    static func alertForError(error: SMError, actions: UIAlertAction...) -> UIAlertController {
        
        let alertTitle: String!
        let alertMessage: String!
        
        switch error {
        case .LocationUpdateFailed:
            alertTitle = "location_update_failed_title".localized
            alertMessage = "location_update_failed_message".localized
        case .RequestFailed:
            alertTitle = "request_failed_title".localized
            alertMessage = "request_failed_message".localized
            break
        case .YelpAuthFailed:
            alertTitle = "yelp_auth_failed_title".localized
            alertMessage = "yelp_auth_failed_message".localized
            break
        case .NoLocationsFound:
            alertTitle = "no_locations_found_title".localized
            alertMessage = "no_locations_found_message".localized
        }
        
        let errorAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        if actions.count > 0 {
           _ = actions.map( {errorAlert.addAction($0)} )
        } else {
            errorAlert.addAction(dismissAction)
        }

        return errorAlert
    }

}
