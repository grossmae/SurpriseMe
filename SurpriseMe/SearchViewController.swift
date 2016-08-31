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

class SearchViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    let searchButton: UIButton = {
       let searchButton = UIButton()
        searchButton.setTitle("Search", forState: .Normal)
        return searchButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchButton)
        searchButton.snp_makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.center.equalTo(0)
        }
        searchButton.addTarget(self, action: #selector(searchButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    func searchButtonPressed() {

        let locManager = SMLocationManager.sharedInstance.locationManager
        locManager.startUpdatingLocation()
        
        Observable.zip(locManager.rx_didUpdateLocations, YelpAuthManager.sharedInstance.getToken()) {
            return ($0, $1)
            }
            .flatMap { (locations, token) -> Observable<[SMLocation]> in
                if let location = locations.first {
                    return YelpClient.searchForLocation(location.coordinate.latitude, longitude: location.coordinate.longitude, token: token)
                } else {
                    return Observable.error(Error.RequestFailed)
                }
            }
            .subscribeNext { [weak self] results in
                self?.fetchedSearchResults(results)
            }
            .addDisposableTo(disposeBag)
    }
    
    private func fetchedSearchResults(locations: [SMLocation]) {
        if let loc = locations.sample {
            let mapVC = MapViewController(location: loc)
            presentViewController(mapVC, animated: true, completion: nil)
        }
        
    }
}