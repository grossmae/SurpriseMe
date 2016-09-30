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
    
    lazy var lockDic: [String:Any] = { [unowned self] in
        return Locksmith.loadDataForUserAccount(userAccount: self.yelpAccount) ?? [:]
    }()
    
    lazy var token: String? = { [unowned self] in
        return self.lockDic[self.tokenKey] as? String
    }()
    
    lazy var expDate: Date? = { [unowned self] in
        return self.lockDic[self.expKey] as? Date
    }()
    
    func getToken() -> Observable<String> {
        return Observable.create { [unowned self] o in
            self.fetchToken { token in
                if let token = token {
                    o.onNext(token)
                    o.onCompleted()
                } else {
                    o.onError(SMError.YelpAuthFailed)
                }
            }
            
            return Disposables.create { }
        }
    }
    
    func fetchToken(completion: @escaping (_ token: String?) -> Void) {
        if let token = self.token {
            if tokenDateValid(date: self.expDate) {
                completion(token)
                return
            }
        }
        requestToken(completion: completion)
    }
    
    func requestToken(completion: ((_ token: String?) -> Void)?) {
        Alamofire.request(authURL, method: .post, parameters: authParams, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
               
                let json = JSON(data)
                let token = json["access_token"].stringValue
                let expInterval: TimeInterval = json["expires_in"].doubleValue
                let expDate = Date(timeInterval: expInterval, since: Date())
                self.setToken(token, expiration: expDate)
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                self.clearToken()
            }
            
            if let completion = completion {
                completion(self.token)
            }
        }
    }
    
    func setToken(_ token: String, expiration: Date) {
        if tokenDateValid(date: expiration) {
            do {
                try Locksmith.updateData(data: [expKey: expiration, tokenKey: token], forUserAccount: yelpAccount)
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
            try Locksmith.deleteDataForUserAccount(userAccount: yelpAccount)
        } catch {
            
        }
        
        token = nil
        expDate = nil
    }
    
    func tokenDateValid(date: Date?) -> Bool {
        if let date = date {
            return date.isAfterDate(dateToCompare: Date())
        }
        return false
    }
}
