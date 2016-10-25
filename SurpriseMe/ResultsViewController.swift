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
    
    var resultButtons: [ResultOptionButton] = []
    
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
            make.height.equalTo(45)
        }
        
        resultsLabel.text = "Results"
        resultsLabel.font = UIFont(name: "AvenirNext-Medium", size: 40)
        resultsLabel.textAlignment = .center
        resultsLabel.textColor = UIColor.smDarkText
        resultsLabel.backgroundColor = .clear
        
        
        var topView: UIView = resultsLabel
        var index = 0
        
        for location in resultLocations {
            let resultButton = ResultOptionButton(location: location)
            resultButtons.append(resultButton)
            view.addSubview(resultButton)
            resultButton.snp.makeConstraints { (make) in
                make.top.equalTo(topView.snp.bottom).offset(30)
                make.width.equalTo(187)
                make.height.equalTo(120)
                make.centerX.equalTo(view)
            }
            resultButton.layoutSubviews()
            
            resultButton.rx.tap.asObservable().subscribe(onNext: { [weak self] event in
                let mapVC = MapViewController(location: location)
                let navController = UINavigationController(rootViewController: mapVC)
                self?.present(navController, animated: true, completion: nil)

                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
            topView = resultButton
            index += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        _ = resultButtons.map { button in
            button.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateOptions()
    }
    
    func animateOptions() {
        var index = 0
        let moveDistance = view.bounds.width + 10
        for button in resultButtons {
            button.center.x -= moveDistance
            button.isHidden = false
            UIView.animate(withDuration: 0.8, delay: 0.2 * Double(index), options: .curveEaseOut, animations: {
                button.center.x += moveDistance
                }, completion: nil)
            index += 1
        }
    }
    
}
