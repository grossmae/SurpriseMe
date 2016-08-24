//
//  NSDate.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/23/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation

extension NSDate {
    func isAfterDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
    }
    
    func isBeforeDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedSame
    }
    
}