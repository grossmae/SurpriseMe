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
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.bottom.equalTo(-3)
            make.left.equalTo(5)
            make.right.equalTo(-5)
        }
        
        contentView.addSubview(distanceView)
        contentView.addSubview(ratingView)
        contentView.addSubview(priceView)
        
        _ = subviews.map { view in
            view.isUserInteractionEnabled = false
        }
        
        populateContent()
        
        setBackgroundImage(#imageLiteral(resourceName: "BtCloche"), for: .normal)
        
//        backgroundColor = .smBlue
//        layer.cornerRadius = 10
//        layer.shadowOffset = CGSize(width: 4, height: 4)
//        layer.shadowOpacity = 0.8
//        layer.shadowRadius = 0
//        layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateContent() {
        
        ratingView.rating = resultLocation.rating
        priceView.price = resultLocation.price
        distanceView.distance = Float(SMLocationManager.sharedInstance.distanceTo(location: resultLocation.clLoc) ?? -1)
        
        distanceView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.35)
        }
        
        
        priceView.snp.makeConstraints { (make) in
            make.centerY.equalTo(0)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.35)
        }
        
        
        ratingView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.width.equalTo(self).offset(-8)
            make.centerX.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.35)
        }
    }

}
