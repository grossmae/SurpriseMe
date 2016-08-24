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
    
    lazy var token: String? = { [unowned self] in
        return NSUserDefaults.standardUserDefaults().stringForKey(self.tokenKey)
    }()
    
    lazy var expDate: NSDate? = { [unowned self] in
        return NSUserDefaults.standardUserDefaults().objectForKey(self.expKey) as? NSDate
    }()
    
    static let sharedInstance = YelpAuthManager()
    
    func fetchToken(completion: ((token: String?) -> Void)?) {
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
                self.clearToken()
            }
            
            if let completion = completion {
                completion(token: self.token)
            }
        }
    }
    
    func setToken(token: String, expiration: NSDate) {
        if tokenDateValid(expiration) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(expiration, forKey: expKey)
            defaults.setObject(token, forKey: tokenKey)
            defaults.synchronize()
            self.token = token
            self.expDate = expiration
        } else {
            clearToken()
        }
    }
    
    func clearToken() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: expKey)
        defaults.setObject(nil, forKey: tokenKey)
        defaults.synchronize()
        token = nil
        expDate = nil
    }
    
    func getToken(completion: (token: String?) -> Void) {
        if let token = self.token {
            if tokenDateValid(self.expDate) {
                completion(token: token)
                return
            }
        }
        fetchToken(completion)
    }
    
    func tokenDateValid(date: NSDate?) -> Bool {
        if let date = date {
            return date.isAfterDate(NSDate())
        }
        return false
    }
}
