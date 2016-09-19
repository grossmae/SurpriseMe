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
        searchButton.setTitle("search".localized, forState: .Normal)
        searchButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        return searchButton
    }()
    
    let locManager = SMLocationManager.sharedInstance.locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        view.addSubview(searchButton)
        searchButton.snp_makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.center.equalTo(0)
        }
        searchButton.addTarget(self, action: #selector(searchButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    func searchButtonPressed() {
        runSearch(SMSearchOptions())
    }
    
    func runExpandedSearch() {
        var expandedOptions = SMSearchOptions()
        expandedOptions.radius = .Drivable
        runSearch(expandedOptions)
    }
    
    func runSearch(options: SMSearchOptions) {
        
        locManager.startUpdatingLocation()
        
        Observable.zip(SMLocationManager.sharedInstance.getLocation(), YelpAuthManager.sharedInstance.getToken()) {
            return ($0, $1)
            }
            .flatMap { ( locations, token) -> Observable<[SMLocation]> in
                if let location = locations.first {
                    return YelpClient.searchForLocation(location.coordinate.latitude, longitude: location.coordinate.longitude, token: token, options: options)
                } else {
                    return Observable.error(Error.RequestFailed)
                }
            }
            .subscribe{ [weak self] event in
                switch event {
                case .Next(let results):
                    self?.fetchedSearchResults(results)
                case .Error(let errorType):
                    self?.presentViewController(SMErrorAlertFactory.alertForError(errorType as? Error ?? Error.LocationUpdateFailed), animated: true, completion: nil)
                    print("Error is ", errorType)
                case .Completed:
                    print("Completed")
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func fetchedSearchResults(locations: [SMLocation]) {
        if locations.count == 0 {
            let retryAction = UIAlertAction(title: "retry".localized, style: .Default, handler: { [weak self] action in
                self?.runExpandedSearch()
            })
            let cancelAction = UIAlertAction(title: "cancel".localized, style: .Default, handler: nil)
            self.presentViewController(SMErrorAlertFactory.alertForError(.NoLocationsFound, actions: retryAction, cancelAction), animated: true, completion: nil)
        } else if let loc = locations.sample {
            let mapVC = MapViewController(location: loc)
            let navController = UINavigationController(rootViewController: mapVC)
            presentViewController(navController, animated: true, completion: nil)
        }
        
    }
}
