//
//  YelpLocationParser.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/31/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class YelpLocationParser {
    
    static func parseLocationsFromJSON(json: JSON) -> [SMLocation] {
        
        var locations = [SMLocation]()
        print(json)
        for (_,loc):(String, JSON) in json["businesses"] {
            
            let coordinates = parseCoordinatesFromYelpCoordinates(coordinates: loc["coordinates"])
            let yelpID = loc["id"].stringValue
            let name = loc["name"].stringValue
            let address = parseAddressFromYelpLocation(location: loc["location"])
            let phoneNumber = loc["phone"].string
            let websiteURL = loc["url"].URL
            
            let price = parsePriceFromYelpRange(dollars: loc["price"].stringValue)
            let rating = parseRatingFromYelpScale(rating: loc["rating"].doubleValue)
            let reviewCount = loc["review_count"].int ?? 0
            
            let categories = parseCategoriesFromYelpCategories(catJSON: loc["categories"])
            
            locations.append(SMLocation(coordinates: coordinates, yelpID: yelpID, name: name, address: address, phoneNumber: phoneNumber, websiteURL: websiteURL, price: price, rating: rating, reviewCount: reviewCount, categories: categories, openTimes: nil))
        }
        return locations
    }
    
    private static func parseAddressFromYelpLocation(location: JSON) -> SMAddress {
        let address1 = location["address1"].string
        let address2 = location["address2"].string
        let address3 = location["address3"].string
        
        let city = location["city"].string
        let state = location["state"].string
        let country = location["country"].string
        let zipCode = location["zip_code"].string
        
        return SMAddress(line1: address1, line2: address2, line3: address3, city: city, state: state, country: country, zip: zipCode)
    }
    
    private static func parseCoordinatesFromYelpCoordinates(coordinates: JSON) -> CLLocationCoordinate2D {
        let lat = coordinates["latitude"].doubleValue
        let long = coordinates["longitude"].doubleValue
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    private static func parsePriceFromYelpRange(dollars: String) -> SMPrice {
        switch dollars.characters.count {
        case 1:
            return SMPrice.Innexpensive
        case 2:
            return SMPrice.Moderate
        case 3:
            return SMPrice.Expensive
        case 4:
            return SMPrice.VeryExpensive
        default:
            return SMPrice.Unknown
        }
    }
    
    private static func parseRatingFromYelpScale(rating: Double) -> SMRating {
        switch rating {
        case _ where rating < 1:
            return SMRating.ExtremelyNegative
        case _ where rating < 2.2:
            return SMRating.Negative
        case _ where rating < 3.2:
            return SMRating.Neutral
        case _ where rating < 4:
            return SMRating.Positive
        case _ where rating < 5:
            return SMRating.ExtremelyPositive
        default:
            return SMRating.Unknown
        }
    }
    
    private static func parseCategoriesFromYelpCategories(catJSON: JSON) -> [SMCategory] {
        var categories = [SMCategory]()
        for (_,cat):(String, JSON) in catJSON {
            let name = cat["title"].stringValue
            let value = cat["alias"].stringValue
            categories.append(SMCategory(name: name, value: value))
        }
        return categories
    }
}
