//
//  Array.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/31/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit

extension Array {
    
    var sample: Element? {
        let size = self.count
        if size == 0 {
            return nil
        }
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}
