//
//  YelpClient
//  SurpriseMe
//
//  Created by Evan Grossman on 8/19/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Alamofire
import RxSwift

class YelpClient {
    
    static let YelpBaseURL = "https://api.yelp.com/v3/"
    
    static func searchForLocation(latitude: Double, longitude: Double, token: String) -> Observable<[String]> {
        
        return Observable.create { o in
            var urlComponents = baseURLComponents()
            urlComponents.path = "/v3/businesses/search"
            urlComponents = addQueryToURLComponents(urlComponents, name: "latitude", value: String(latitude))
            urlComponents = addQueryToURLComponents(urlComponents, name: "longitude", value: String(longitude))
            
            Alamofire.request(.GET, urlComponents.URL!, headers: ["Authorization": "Bearer \(token)"])
                .responseJSON { (response) in
                    print(response)
                    
                    switch response.result {
                    case .Success(let data):
                        o.onNext(["Got it"])
                        o.onCompleted()
                        break
                    case .Failure:
                        o.onError(Error.RequestFailed)
                    }
            }
            return AnonymousDisposable { }
        }
        
    }

    private static func baseURLComponents() -> NSURLComponents {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "api.yelp.com";
        return urlComponents;
    }
    
    private static func addQueryToURLComponents(urlComponents: NSURLComponents, name: String, value: String) -> NSURLComponents {
        let query = NSURLQueryItem(name: name, value: value)
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = []
        }
        urlComponents.queryItems?.append(query)
        return urlComponents
    }
}
