//
//  YelpAuthManager.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/22/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Alamofire
import SwiftyJSON

class YelpAuthManager {
    
    let authURL = "https://api.yelp.com/oauth2/token"
    let tokenKey = "yelp_token"
    let expKey = "yelp_exp"
    let authParams = ["grant_type":"",
                      "client_id":Config.yelp.appID,
                      "client_secret":Config.yelp.appSecret];
    var token: String?
    var expDate: NSDate?
    
    static let sharedInstance = YelpAuthManager()
    
    init() {
        fetchToken()
    }
    
    func fetchToken() {
        Alamofire.request(.POST, authURL, parameters: authParams, encoding: .URL, headers: nil).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
            case .Success(let data):
               
                let json = JSON(data)
                let token = json["access_token"].stringValue
                let expInterval: NSTimeInterval = json["expires_in"].doubleValue
                let expDate = NSDate(timeInterval: expInterval, sinceDate: NSDate())
                self.setToken(token, expiration: expDate)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }

        }
    }
    
    func setToken(token: String, expiration: NSDate) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(expiration, forKey: expKey)
        defaults.setObject(token, forKey: tokenKey)
    }
}
