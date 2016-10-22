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
    
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    
    @discardableResult
    mutating func shuffle() -> Array {
        indices.dropLast().forEach { a in
            guard case let b = Int(arc4random_uniform(UInt32(self.count - a))) + a, b != a else { return }
            swap(&self[a], &self[b])
        }
        return self
    }
    
    func sample(size: Int) -> Array {
        if size <= 0 {
            return []
        } else if size > self.count {
            return shuffled
        } else {
            return Array(shuffled.prefix(upTo: size))
        }
    }
}
