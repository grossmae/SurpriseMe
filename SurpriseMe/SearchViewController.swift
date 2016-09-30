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
    
    let searchButton: UIButton = {
       let searchButton = UIButton()
        searchButton.setTitle("search".localized, for: .normal)
        searchButton.setTitleColor(UIColor.black, for: .normal)
        return searchButton
    }()
    
    let locManager = SMLocationManager.sharedInstance.locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.center.equalTo(0)
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
                    self?.present(SMErrorAlertFactory.alertForError(error: errorType as? SMError ?? SMError.LocationUpdateFailed), animated: true, completion: nil)
                    print("Error is ", errorType)
                case .completed:
                    print("Completed")
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func fetchedSearchResults(locations: [SMLocation]) {
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
