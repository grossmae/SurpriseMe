//
//  String.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 9/10/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(interpolatedArguments: [CVarArg]) -> String {
        return String(format: self.localized, arguments: interpolatedArguments)
    }
}
