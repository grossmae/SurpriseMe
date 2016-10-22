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
    
    let ratingView = RatingView()
    let priceView = PriceView()
    let distanceView = DistanceView()
    
    init(location: SMLocation) {
        resultLocation = location
        super.init(frame: CGRect.zero)
        
        addSubview(ratingView)
        addSubview(priceView)
        addSubview(distanceView)
        
        _ = subviews.map { view in
            view.isUserInteractionEnabled = false
        }
        
        populateContent()
        
        backgroundColor = .smBlue
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 0
        layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateContent() {
        
        ratingView.rating = resultLocation.rating
        ratingView.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.35)
        }
        
        priceView.price = resultLocation.price
        priceView.snp.makeConstraints { (make) in
            make.centerY.equalTo(0)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.35)
        }
        
        distanceView.distance = Float(SMLocationManager.sharedInstance.distanceTo(location: resultLocation.clLoc) ?? -1)
        distanceView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-2)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.35)
        }
    }

}
