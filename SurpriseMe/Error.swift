//
//  ErrorCode.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/19/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

enum SMError : Error {
    case RequestFailed;
    case YelpAuthFailed;
    case LocationUpdateFailed;
    case NoLocationsFound;
}

