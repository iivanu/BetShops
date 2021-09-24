//
//  MapViewModel.swift
//  BetShops
//
//  Created by Ivan Ivanušić on 27.08.2021..
//

import Foundation
import CoreLocation
import MapKit

// MARK: Delegate methods
protocol MapViewModelDelegate: AnyObject {
    func centerMapToLocation(userLocation: CLLocationCoordinate2D?)
    func returnData(newBetShops: [MKPointAnnotation])
}

class MapViewModel: NSObject {
    weak var delegate: MapViewModelDelegate?
    private let locationManager = CLLocationManager()
    private var shopLocations: Set<BetShop> = []
    private var lastNorthEastCoordinate: CLLocationCoordinate2D?
    private var lastSouthWestCoordinate: CLLocationCoordinate2D?

    override init() {
        super.init()
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        }
    }
    
    func getAndSaveShops(northEast: CLLocationCoordinate2D,
                         southWest: CLLocationCoordinate2D) {
        
        if needsFetching(northEast: northEast, southWest: southWest) {
            NetworkApiClient.client.getBetShops(north: northEast.latitude, east: northEast.longitude, south: southWest.latitude, west: southWest.longitude) { [weak self] (result) in
                guard let self = self else { return }
                if let responseData = result {
                    let dataSet = Set(responseData.betshops)
                    
                    let newLocations = dataSet.subtracting(self.shopLocations)
                    self.shopLocations = self.shopLocations.union(dataSet)
                    let annotations = self.generateAnnotations(newLocations: newLocations)
                    
                    self.delegate?.returnData(newBetShops: annotations)
                }
            }
        }
        lastNorthEastCoordinate = northEast
        lastSouthWestCoordinate = southWest
    }
    
    func getAnnotationData(annotation: MKAnnotation) -> BetShop? {
        return shopLocations.first(where: { $0.name == annotation.title && $0.location.lat == annotation.coordinate.latitude && $0.location.lng == annotation.coordinate.longitude})
    }
}

// MARK: Private methods
extension MapViewModel {
    private func needsFetching(northEast: CLLocationCoordinate2D,
                               southWest: CLLocationCoordinate2D) -> Bool {
        
        guard let lastNorthEast = lastNorthEastCoordinate, let lastSouthWest = lastSouthWestCoordinate else {
            return true
        }
        
        if northEast.latitude > lastNorthEast.latitude {
            return true
        }
        
        if northEast.longitude > lastNorthEast.longitude {
            return true
        }
        
        if southWest.latitude < lastSouthWest.latitude {
            return true
        }
        
        if southWest.longitude < lastSouthWest.longitude {
            return true
        }
        
        return false
    }
    
    private func generateAnnotations(newLocations: Set<BetShop>) -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = []
        for betShop in newLocations {
            let annotation = MKPointAnnotation()
            annotation.title = betShop.name
            annotation.subtitle = betShop.address
            annotation.coordinate = CLLocationCoordinate2D(latitude: betShop.location.lat, longitude: betShop.location.lng)
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: CLLocationManagerDelegate methods
extension MapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            delegate?.centerMapToLocation(userLocation: nil)
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.centerMapToLocation(userLocation: locationManager.location?.coordinate)
        @unknown default:
            break
        }
    }
}
