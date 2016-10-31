//
//  RatingView.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 10/21/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit

class RatingView: UIView {

    var rating: SMRating {
        didSet {
            populateContent()
        }
    }
    
    init() {
        self.rating = .Unknown
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateContent() {
        
        let starLabel = UILabel()
        addSubview(starLabel)
        starLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        starLabel.textAlignment = .center
        
        switch rating {
        case .ExtremelyNegative:
            starLabel.text = "⭐️"
        case .Negative:
            starLabel.text = "⭐️⭐️"
        case .Neutral:
            starLabel.text = "⭐️⭐️⭐️"
        case .Positive:
            starLabel.text = "⭐️⭐️⭐️⭐️"
        case.ExtremelyPositive:
            starLabel.text = "⭐️⭐️⭐️⭐️⭐️"
        case .Unknown:
            starLabel.text = "?⭐️?"
        }
    }
    
}
