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
            Alamofire.request( SMRouter.search(lat: latitude, lon: longitude, options: options))
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
}
