//
//  MapViewController.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 8/31/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {
    
    let RegionRadius: CLLocationDistance = 1000
    
    let disposeBag = DisposeBag()
    let locManager = SMLocationManager.sharedInstance.locationManager
    
    let mapView = MKMapView()
    
    let finishLocation: SMLocation
    
    init(location: SMLocation) {
        self.finishLocation = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.translucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "close".localized, style: .Plain, target: self, action: #selector(MapViewController.closePressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open_in_maps".localized, style: .Plain, target: self, action: #selector(MapViewController.openInMapsPressed))
        
        view.addSubview(mapView)
        mapView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        drawMapAtLocation(finishLocation.clLoc)
        fetchCurrentLocation()
    }
    
    func closePressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func openInMapsPressed() {
        locManager.startUpdatingLocation()
        locManager.rx_didUpdateLocations
        .take(1)
        .subscribe{ event in
            switch event {
            case .Next(let locations):
                if let location = locations.first {
                    let mapURL = MapHelper.mapURLFromLocation(location.coordinate, toLocation: self.finishLocation.coordinates)
                    UIApplication.sharedApplication().openURL(mapURL)
                }
            case .Error(let error):
                self.presentViewController(SMErrorAlertFactory.alertForError(error as? Error ?? Error.LocationUpdateFailed), animated: true, completion: nil)
            case .Completed:
                break
            }
        }
        .addDisposableTo(disposeBag)
    }
    
    func fetchCurrentLocation() {
        
        
        locManager.startUpdatingLocation()
        
        locManager.rx_didUpdateLocations
        .take(1)
        .subscribe { [weak self] event in
            switch event {
            case .Next(let locations):
                if let location = locations.first {
                    self?.drawMapAtLocation(location)
                    self?.drawDirectionsFrom(location)
                }
            case .Error(let error):
                self?.presentViewController(SMErrorAlertFactory.alertForError(error as? Error ?? Error.LocationUpdateFailed), animated: true, completion: nil)
            case .Completed:
                break
            }
        }
        .addDisposableTo(disposeBag)
    }
    
    func drawMapAtLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, RegionRadius, RegionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func drawDirectionsFrom(startLocation: CLLocation) {
        
        let startPlacemark = MKPlacemark(coordinate: startLocation.coordinate, addressDictionary: nil)
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startLocation.coordinate
        startAnnotation.title = "start".localized
        
        let finishPlacemark = MKPlacemark(coordinate: finishLocation.coordinates, addressDictionary: nil)
        let finishMapItem = MKMapItem(placemark: finishPlacemark)
        let finishAnnotation = MKPointAnnotation()
        finishAnnotation.coordinate = finishLocation.coordinates
        finishAnnotation.title = "finish".localized
        
        mapView.showAnnotations([finishAnnotation], animated: false)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = startMapItem
        directionsRequest.destination = finishMapItem
        directionsRequest.transportType = .Walking
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler {[weak self] (response, error) in
            if let _ = error {
                return
            }
            
            if let response = response {
                let route = response.routes[0]
                self?.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
                
                let routeRect = route.polyline.boundingMapRect
                let mapRect = MKMapRect(origin: MKMapPoint(x: routeRect.origin.x - 2500, y: routeRect.origin.y - 2500), size: MKMapSize(width: routeRect.size.width + 5000, height: routeRect.size.height + 5000))
                self?.mapView.setRegion(MKCoordinateRegionForMapRect(mapRect), animated: true)
            }
        }
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.cyanColor()
        renderer.lineWidth = 5.0
        
        return renderer
    }
}
