//
//  ResultOptionView.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 10/20/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit

class ResultOptionButton: UIButton {
    
    let resultLocation: SMLocation
    
    let ratingLabel = UILabel()
    let priceLabel = UILabel()
    let distanceLabel = UILabel()
    
    init(location: SMLocation) {
        resultLocation = location
        super.init(frame: CGRect.zero)
        
        addSubview(ratingLabel)
        addSubview(priceLabel)
        addSubview(distanceLabel)
        
        _ = subviews.map { view in
            view.isUserInteractionEnabled = false
        }
        
        populateContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateContent() {
        
        ratingLabel.text = "Rating: \(resultLocation.rating)"
        priceLabel.text = "Price: \(resultLocation.price)"
        distanceLabel.text = "Distance: \(resultLocation.coordinates)"
        
        ratingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.2)
        }
        ratingLabel.backgroundColor = .red
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(0)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.2)
        }
        priceLabel.backgroundColor = .green
        
        distanceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-4)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.2)
        }
        distanceLabel.backgroundColor = .purple
    }

}
