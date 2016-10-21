//
//  PriceView.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 10/21/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit

class PriceView: UIView {

    var price: SMPrice {
        didSet {
            populateContent()
        }
    }
    
    init() {
        self.price = .Unknown
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateContent() {
        
        let priceLabel = UILabel()
        addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        priceLabel.textAlignment = .center
        
        switch price {
        case .Innexpensive:
            priceLabel.text = "💸"
        case .Moderate:
            priceLabel.text = "💸💸"
        case .Expensive:
            priceLabel.text = "💸💸💸"
        case .VeryExpensive:
            priceLabel.text = "💸💸💸💸"
        case .Unknown:
            priceLabel.text = "?💸?"
        }
        
    }

}
