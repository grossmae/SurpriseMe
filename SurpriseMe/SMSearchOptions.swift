//
//  SMSearchOptions.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/31/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

struct SMSearchOptions {
    
    var term: String = "restaurant"
    var sort: SMSortOption = .BestMatch
    var radius: SMRadiusOption = .Walkable
}

enum SMSortOption: String {
    case BestMatch = "0"
    case HighestRated = "2"
    case Closest = "1"
}

enum SMRadiusOption: String {
    case Walkable = "500"
    case Drivable = "3000"
}
