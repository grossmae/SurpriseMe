//
//  Date.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/23/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation

extension Date {
    func isAfterDate(dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    func isBeforeDate(dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedAscending
    }
    
    func equalToDate(dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedSame
    }
    
}
