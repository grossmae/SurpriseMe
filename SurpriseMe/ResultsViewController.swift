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
    var servingImageViews: [UIImageView] = []
    
    var optionsPresentedFlag = false
    
    init(locations: [SMLocation]) {
        resultLocations = locations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.smBlue
        
        let menuImageView = UIImageView()
        menuImageView.image = #imageLiteral(resourceName: "Menu")
        view.addSubview(menuImageView)
        menuImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            make.width.equalTo(161)
            make.centerX.equalTo(view)
            make.height.equalTo(52)
        }
        
        let backButton = UIButton()
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(menuImageView.snp.centerY)
            make.width.height.equalTo(30)
            make.left.equalTo(18)
        }
        backButton.setImage(#imageLiteral(resourceName: "BtBack"), for: .normal)
        
        var index = 0
        
        let resultsView = UIView()
        view.addSubview(resultsView)
        resultsView.snp.makeConstraints { (make) in
            make.top.equalTo(menuImageView.snp.bottom).offset(10)
            make.right.left.equalTo(0)
            make.bottom.equalTo(-14)
        }
        
        var topView = UIView()
        resultsView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.height.equalTo(0)
        }
        
        for location in resultLocations {
            
            let resultContainerView = UIView()
            resultsView.addSubview(resultContainerView)
            resultContainerView.snp.makeConstraints({ (make) in
                make.top.equalTo(topView.snp.bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(resultsView).dividedBy(resultLocations.count)
            })
            
            
            let resultButton = ResultOptionButton(location: location)
            resultButtons.append(resultButton)
            resultContainerView.addSubview(resultButton)
            resultButton.snp.makeConstraints { (make) in
                make.width.equalTo(187)
                make.height.equalTo(120)
                make.center.equalTo(resultContainerView)
            }
            resultButton.layoutSubviews()
            
            let servingImageView = UIImageView()
            servingImageViews.append(servingImageView)
            resultContainerView.addSubview(servingImageView)
            
            
            if index % 2 == 0 {
                servingImageView.image = #imageLiteral(resourceName: "ServingHandLeft")
                servingImageView.snp.makeConstraints({ (make) in
                    make.top.equalTo(resultButton.snp.bottom).offset(-30)
                    make.right.equalTo(resultButton.snp.centerX).offset(10)
                    make.height.equalTo(52)
                    make.width.equalTo(352)
                })
            } else {
                servingImageView.image = #imageLiteral(resourceName: "ServingHandRight")
                servingImageView.snp.makeConstraints({ (make) in
                    make.top.equalTo(resultButton.snp.bottom).offset(-30)
                    make.left.equalTo(resultButton.snp.centerX).offset(-10)
                    make.height.equalTo(52)
                    make.width.equalTo(352)
                })
            }
            
            resultButton.rx.tap.asObservable().subscribe(onNext: { [weak self] event in
                let mapVC = MapViewController(location: location)
                let navController = UINavigationController(rootViewController: mapVC)
                self?.present(navController, animated: true, completion: nil)

                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
            topView = resultContainerView
            index += 1
        }
        
        backButton.rx.tap.asObservable().subscribe(onNext: { [weak self] event in
            resultsView.isHidden = true
            _ = self?.navigationController?.popViewController(animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        if !optionsPresentedFlag {
            _ = resultButtons.map { button in
                button.isHidden = true
            }
            _ = servingImageViews.map { servingHand in
                servingHand.isHidden = true
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !optionsPresentedFlag {
            animateResults()
        }
        
    }
    
    func animateResults() {
        optionsPresentedFlag = true
        var index = 0
        let moveDistance = view.bounds.width + 10
        for (button, hand) in zip(resultButtons,servingImageViews) {
            
            var move = moveDistance
            if index % 2 == 1 {
                move *= -1
            }
            
            button.center.x -= move
            button.isHidden = false
            hand.center.x -= move
            hand.isHidden = false
            
            UIView.animate(withDuration: 0.8, delay: 0.2 * Double(index), options: .curveEaseOut, animations: { 
                button.center.x += move
                hand.center.x += move
                }, completion: { (complete) in
                    UIView.animate(withDuration: 0.8, animations: {
                        hand.center.x -= move
                        }, completion: { (complete) in
                            hand.isHidden = true
                    })
                    
            })
            index += 1
        }
    }
    
}
