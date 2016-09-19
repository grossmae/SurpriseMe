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

        locManager.startUpdatingLocation()
        
        Observable.zip(SMLocationManager.sharedInstance.getLocation(), YelpAuthManager.sharedInstance.getToken()) {
            return ($0, $1)
            }
            .flatMap { ( locations, token) -> Observable<[SMLocation]> in
                if let location = locations.first {
                    return YelpClient.searchForLocation(location.coordinate.latitude, longitude: location.coordinate.longitude, token: token)
                } else {
                    return Observable.error(Error.RequestFailed)
                }
            }
            .subscribe{ event in
                switch event {
                case .Next(let results):
                    print(results)
                case .Error(let errorType):
                    self.presentViewController(SMErrorAlertFactory.alertForError(errorType as? Error ?? Error.LocationUpdateFailed), animated: true, completion: nil)
                    print("Error is ", errorType)
                case .Completed:
                    print("Completed")
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func optionsButtonPressed() {
        
    }
    
    private func fetchedSearchResults(locations: [SMLocation]) {
        if let loc = locations.sample {
            let mapVC = MapViewController(location: loc)
            let navController = UINavigationController(rootViewController: mapVC)
            presentViewController(navController, animated: true, completion: nil)
        }
        
    }
}
