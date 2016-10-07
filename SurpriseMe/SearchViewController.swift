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
        logoImageView.image = UIImage(named: "SMLogoBlue")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    let descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.text = "intro_description".localized
        descriptionTextView.font = UIFont(name: "AvenirNext-Medium", size: 20)
        descriptionTextView.textAlignment = .center
        descriptionTextView.textColor = UIColor.smDarkText
        descriptionTextView.backgroundColor = .clear
        return descriptionTextView
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
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(logoImageView)
        view.addSubview(descriptionTextView)
        view.addSubview(searchButton)
        
        logoImageView.snp.makeConstraints { (make) in
            
            make.width.equalTo(290)
            make.height.equalTo(110)
            make.top.equalTo(65)
            make.centerX.equalTo(0)
        }
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.top.equalTo(logoImageView.snp.bottom).offset(23)
            make.bottom.equalTo(searchButton.snp.top).offset(10)
        }
        
        searchButton.snp.makeConstraints { (make) in
            make.height.equalTo(120)
            make.width.equalTo(120)
            make.centerX.equalTo(0)
            make.bottom.equalTo(-40)
        }
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
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
        } else if let loc = locations.sample {
            let mapVC = MapViewController(location: loc)
            let navController = UINavigationController(rootViewController: mapVC)
            present(navController, animated: true, completion: nil)
        }
        
    }
}
