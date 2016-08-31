//
//  YelpAuthManager.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/22/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Locksmith
import RxSwift

class YelpAuthManager {
    
    static let sharedInstance = YelpAuthManager()
    
    private init() { }
    
    let authURL = "https://api.yelp.com/oauth2/token"
    let yelpAccount = "yelp_credentials"
    let tokenKey = "yelp_token"
    let expKey = "yelp_exp"
    let authParams = ["grant_type":"",
                      "client_id":Config.yelp.appID,
                      "client_secret":Config.yelp.appSecret];
    
    lazy var lockDic: [String:AnyObject?] = { [unowned self] in
        return Locksmith.loadDataForUserAccount(self.yelpAccount) ?? [:]
    }()
    
    lazy var token: String? = { [unowned self] in
        return self.lockDic[self.tokenKey] as? String
    }()
    
    lazy var expDate: NSDate? = { [unowned self] in
        return self.lockDic[self.expKey] as? NSDate
    }()
    
    func getToken() -> Observable<String> {
        return Observable.create { [unowned self] o in
            self.fetchToken { token in
                if let token = token {
                    o.onNext(token)
                    o.onCompleted()
                } else {
                    o.onError(Error.RequestFailed)
                }
            }
            
            return AnonymousDisposable { }
        }
    }
    
    func fetchToken(completion: (token: String?) -> Void) {
        if let token = self.token {
            if tokenDateValid(self.expDate) {
                completion(token: token)
                return
            }
        }
        requestToken(completion)
    }
    
    func requestToken(completion: ((token: String?) -> Void)?) {
        Alamofire.request(.POST, authURL, parameters: authParams, encoding: .URL, headers: nil).responseJSON { (response) in
            
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
            do {
                try Locksmith.updateData([expKey: expiration, tokenKey: token], forUserAccount: yelpAccount)
            } catch {
                print ("error")
            }
            
            self.token = token
            self.expDate = expiration
        } else {
            clearToken()
        }
    }
    
    func clearToken() {
        do {
            try Locksmith.deleteDataForUserAccount(yelpAccount)
        } catch {
            
        }
        
        token = nil
        expDate = nil
    }
    
    func tokenDateValid(date: NSDate?) -> Bool {
        if let date = date {
            return date.isAfterDate(NSDate())
        }
        return false
    }
}
