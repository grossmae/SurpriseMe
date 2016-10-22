//
//  DistanceView.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 10/21/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit

class DistanceView: UIView {

    let unknownDistance: Float = -1.0
    
    var distance: Float {
        didSet {
            populateContent()
        }
    }
    
    init() {
        self.distance = unknownDistance
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateContent() {
        
        let distanceLabel = UILabel()
        addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        distanceLabel.textAlignment = .center
        
        switch distance {
        case 0..<0.25:
            distanceLabel.text = "🏃"
        case 0.25...0.5:
            distanceLabel.text = "🏃🏃"
        case 0.5...Float.greatestFiniteMagnitude:
            distanceLabel.text = "🏃🏃🏃"
        default:
            distanceLabel.text = "?🏃?"
        }
    }

}
