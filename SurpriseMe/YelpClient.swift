//
//  YelpClient
//  SurpriseMe
//
//  Created by Evan Grossman on 8/19/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Alamofire
import RxSwift
import SwiftyJSON

class YelpClient {
    
    static let YelpBaseURL = "https://api.yelp.com/v3/"
    
    static func searchForLocation(latitude: Double, longitude: Double, token: String, options: SMSearchOptions) -> Observable<[SMLocation]> {
        
        return Observable.create { o in
            var urlComponents = baseURLComponents()
            urlComponents.path = "/v3/businesses/search"
            urlComponents = addQuery(urlComponents: urlComponents, name: "latitude", value: String(latitude))
            urlComponents = addQuery(urlComponents: urlComponents, name: "longitude", value: String(longitude))
            urlComponents = addQuery(urlComponents: urlComponents, name: "term", value: options.term)
            let sortOption = options.sort
            urlComponents = addQuery(urlComponents: urlComponents, name: "sort", value: sortOption.rawValue)
            if sortOption == .HighestRated || sortOption == .Closest {
                urlComponents = addQuery(urlComponents: urlComponents, name: "limit", value: "10")
            }
            urlComponents = addQuery(urlComponents: urlComponents, name: "radius", value: options.radius.rawValue)
            
            Alamofire.request(urlComponents.url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(token)"])
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let data):
                        let statusCode = (response.response?.statusCode)!
                        print(statusCode)
                        switch statusCode {
                        case 200:
                            let json = JSON(data)
                            let locations = YelpLocationParser.parseLocationsFromJSON(json: json)
                            o.onNext(locations)
                            o.onCompleted()
                        case 401:
                            o.onError(SMError.YelpAuthFailed)
                        default:
                            o.onError(SMError.RequestFailed)
                        }
                    case .failure(let error):
                        print(error)
                        o.onError(SMError.RequestFailed)
                    }
            }
            return Disposables.create { }
        }
        
    }

    private static func baseURLComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "api.yelp.com";
        return urlComponents;
    }
    
    private static func addQuery(urlComponents: URLComponents, name: String, value: String) -> URLComponents {
        let query = URLQueryItem(name: name, value: value)
        var components = urlComponents
        if components.queryItems == nil {
            components.queryItems = []
        }
        components.queryItems?.append(query)
        return components
    }
    
}
