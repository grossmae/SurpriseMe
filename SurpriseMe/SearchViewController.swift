//
//  SearchViewController.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/19/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
import RxSwift

class SearchViewController: SMViewController {

    let disposeBag = DisposeBag()
    
    let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "SMLogo")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "intro_description".localized
        descriptionLabel.font = UIFont(name: "AvenirNext-Medium", size: 24)
        descriptionLabel.textAlignment = .center
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.textColor = UIColor.smDarkText
        descriptionLabel.backgroundColor = .clear
        return descriptionLabel
    }()
    
    let searchButton: UIButton = {
       let searchButton = UIButton()
        searchButton.contentVerticalAlignment = .fill
        searchButton.contentHorizontalAlignment = .fill
        searchButton.setImage(UIImage(named: "BtSearch"), for: .normal)
        return searchButton
    }()
    
    let locManager = SMLocationManager.sharedInstance.locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(searchButton)
        
        logoImageView.snp.makeConstraints { (make) in
            
            make.width.equalTo(290)
            make.height.equalTo(110)
            make.top.equalTo(65)
            make.centerX.equalTo(0)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(logoImageView.snp.bottom).offset(0)
            make.bottom.equalTo(searchButton.snp.top).offset(-10)
        }
        
        searchButton.snp.makeConstraints { (make) in
            make.height.equalTo(120)
            make.width.equalTo(120)
            make.centerX.equalTo(0)
            make.bottom.equalTo(-53)
        }
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SMLocationManager.sharedInstance.locationManager.requestWhenInUseAuthorization()
    }
    
    func searchButtonPressed() {
        runSearch(options: SMSearchOptions())
    }
    
    func runExpandedSearch() {
        var expandedOptions = SMSearchOptions()
        expandedOptions.radius = .Drivable
        runSearch(options: expandedOptions)
    }
    
    func runSearch(options: SMSearchOptions) {
        
        startLoading()
        
        locManager.startUpdatingLocation()
        
        Observable.zip(SMLocationManager.sharedInstance.getLocation(), YelpAuthManager.sharedInstance.getToken()) {
            return ($0, $1)
            }
            .flatMap { ( locations, token) -> Observable<[SMLocation]> in
                if let location = locations.first {
                    return YelpClient.searchForLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, token: token, options: options)
                } else {
                    return Observable.error(SMError.RequestFailed)
                }
            }
            .subscribe{ [weak self] event in
                switch event {
                case .next(let results):
                    self?.fetchedSearchResults(locations: results)
                case .error(let errorType):
                    self?.stopLoading()
self?.present(SMErrorAlertFactory.alertForError(error: errorType as? SMError ?? SMError.LocationUpdateFailed), animated: true, completion: nil)
                    print("Error is ", errorType)
                case .completed:
                    self?.stopLoading()
                    print("Completed")
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func fetchedSearchResults(locations: [SMLocation]) {
        self.stopLoading()
        if locations.count == 0 {
            let retryAction = UIAlertAction(title: "retry".localized, style: .default, handler: { [weak self] action in
                self?.runExpandedSearch()
            })
            let cancelAction = UIAlertAction(title: "cancel".localized, style: .default, handler: nil)
            self.present(SMErrorAlertFactory.alertForError(error: SMError.NoLocationsFound, actions: retryAction, cancelAction), animated: true, completion: nil)
        } else if locations.count < 3 {
            let mapVC = MapViewController(location: locations.sample!)
            let navController = UINavigationController(rootViewController: mapVC)
            present(navController, animated: true, completion: nil)
        } else {
            let resultsVC = ResultsViewController(locations:locations.sample(size: 3))
            self.navigationController?.pushViewController(resultsVC, animated: true)
        }
    }
    
}
