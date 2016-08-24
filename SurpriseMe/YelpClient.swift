//
//  YelpClient
//  SurpriseMe
//
//  Created by Evan Grossman on 8/19/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Alamofire

class YelpClient {
    
    static let YelpBaseURL = "https://api.yelp.com/v3/"
    
    
    
    
//    static func searchForLocation(latitude: Double, longitude: Double, completion: (error: Error?) -> Void) {
//        
//        var urlComponents = baseURLComponents()
//        urlComponents.path = "/v2/search"
//        let latLongString = String(format: "%f,%f", latitude, longitude)
//        urlComponents = addQueryToURLComponents(urlComponents, name: "ll", value: latLongString)
//        print(urlComponents.URL)
//        
//        Alamofire.request(.GET, urlComponents.URL!)
//            .responseJSON { (response) in
//                print(response)
//                
//                var error: Error?
//                
//                switch response.result {
//                case .Success(let data):
//                    break
//                case .Failure:
//                    error = Error.RequestFailed
//                }
//                completion(error: error)
//        }
//    }
//    
//    private static func baseURLComponents() -> NSURLComponents {
//        var urlComponents = NSURLComponents()
//        urlComponents.scheme = "https";
//        urlComponents.host = "api.foursquare.com";
//        urlComponents = addQueryToURLComponents(urlComponents, name: "client_id", value: Constants.FourSquareClientID)
//        urlComponents = addQueryToURLComponents(urlComponents, name: "client_secret", value: Constants.FourSquareClientSecret)
//        urlComponents = addQueryToURLComponents(urlComponents, name: "v", value: "20160801")
//        return urlComponents;
//    }
//    
//    private static func addQueryToURLComponents(urlComponents: NSURLComponents, name: String, value: String) -> NSURLComponents {
//        let query = NSURLQueryItem(name: name, value: value)
//        if urlComponents.queryItems == nil {
//            urlComponents.queryItems = []
//        }
//        urlComponents.queryItems?.append(query)
//        return urlComponents
//    }
}
