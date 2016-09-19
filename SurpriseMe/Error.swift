//
//  ErrorCode.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/19/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

enum Error : ErrorType {
    case RequestFailed;
    case YelpAuthFailed;
    case LocationUpdateFailed;
    case NoLocationsFound;
}

