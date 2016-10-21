//
//  ResultsViewController.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/31/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResultsViewController: SMViewController {
    
    let disposeBag = DisposeBag()
    
    var resultLocations: [SMLocation] = []
    
    init(locations: [SMLocation]) {
        resultLocations = locations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resultsLabel = UILabel()
        view.addSubview(resultsLabel)
        resultsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            make.width.equalTo(view)
            make.centerX.equalTo(view)
            make.height.equalTo(30)
        }
        resultsLabel.text = "Results"
        
        var topView: UIView = resultsLabel
        
        for location in resultLocations {
            let resultButton = ResultOptionButton(location: location)
            view.addSubview(resultButton)
            resultButton.snp.makeConstraints { (make) in
                make.top.equalTo(topView.snp.bottom).offset(30)
                make.right.equalTo(-30)
                make.left.equalTo(30)
                make.height.equalTo(90)
            }
            resultButton.backgroundColor = UIColor.lightGray
            resultButton.layoutSubviews()
            
            resultButton.rx.tap.asObservable().subscribe(onNext: { [weak self] event in
                let mapVC = MapViewController(location: location)
                let navController = UINavigationController(rootViewController: mapVC)
                self?.present(navController, animated: true, completion: nil)

                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
            topView = resultButton
        }
    }
    
}
