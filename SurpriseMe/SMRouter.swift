//
//  SMRouter.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 11/22/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Alamofire

enum SMRouter: URLRequestConvertible {
    
    case search(lat: Double, lon: Double, options: SMSearchOptions)
    
    static let baseURL = "https://api.yelp.com/v3"
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try SMRouter.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.path))
        urlRequest.httpMethod = self.method.rawValue
        
        
        guard let token = YelpAuthManager.sharedInstance.token
            else { throw SMError.YelpAuthFailed }
        
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return try URLEncoding.default.encode(urlRequest, with: self.params)
    }
    
    var method: Alamofire.HTTPMethod {
        
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .search:
            return "/businesses/search"
        }
    }
    
    var params: Parameters {
        switch self {
        case let .search(lat, lon, options):
            var params = processOptions(options)
            params["latitude"] = lat
            params["longitude"] = lon
            return params
        }
    }
    
    func processOptions(_ options: SMSearchOptions) -> Parameters {
        
        var params = [String : Any]()
        params["term"] = options.term
        params["sort"] = options.sort.rawValue
        if options.sort == .HighestRated || options.sort == .Closest {
            params["limit"] = "10"
        }
        params["radiums"] = options.radius.rawValue
        
        return params
    }
    
    
}
