//
//  MapViewController.swift
//  BetShops
//
//  Created by Ivan Ivanušić on 27.08.2021..
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var betShopName: UILabel!
    @IBOutlet weak var betShopAddress: UILabel!
    @IBOutlet weak var betShopCityCountry: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    var initCompleated = false
    var selectedAnnotation: MKAnnotation?
    
    var viewModel: MapViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 184/255, blue: 61/255, alpha: 1)
        title = "Bet shops"
        
        viewModel = MapViewModel()
        viewModel?.delegate = self
        viewModel?.checkLocationServices()
        mapView.delegate = self
        
        mapView.register(ShopAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ShopAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: ViewModelDelegate methods
extension MapViewController: MapViewModelDelegate {
    func returnData(newBetShops: [MKPointAnnotation]) {
        mapView.addAnnotations(newBetShops)
    }
    
    func centerMapToLocation(userLocation: CLLocationCoordinate2D?) {
        var location:  CLLocationCoordinate2D?
        
        if let userLocationUnwrapped = userLocation {
            location = userLocationUnwrapped
            mapView.showsUserLocation = true
            mapView.userLocation.title = ""
        } else {
            location = CLLocationCoordinate2D(latitude: CLLocationDegrees(48.137154), longitude: CLLocationDegrees(11.576124))
        }
        
        if let location = location {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            initCompleated = true
        }
    }
}


// MARK: MKMapViewDelegate methods
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !initCompleated { return }
        
        let northEastCoordinate = MKMapPoint(x: mapView.visibleMapRect.maxX, y: mapView.visibleMapRect.minY).coordinate
        let southWestCoordinate = MKMapPoint(x: mapView.visibleMapRect.minX, y: mapView.visibleMapRect.maxY).coordinate
        
        
        viewModel?.getAndSaveShops(northEast: northEastCoordinate,
                                   southWest: southWestCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKClusterAnnotation { return }
        view.alpha = 0
        view.image = UIImage(named: "Asset 55")
        guard let annotation = view.annotation, let annotationData = viewModel?.getAnnotationData(annotation: annotation) else { return }
        selectedAnnotation = annotation
        configureBottomView(betShop: annotationData)
        

        bottomView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            view.alpha = 1
            self?.bottomView.alpha = 1
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is MKClusterAnnotation { return }
        view.alpha = 0
        view.image = UIImage(named: "Asset 54")
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            view.alpha = 1
            self?.bottomView.alpha = 0
        })
    }
}

// MARK: BottomView configuration and actions
extension MapViewController {
    @IBAction func exitTapped(_ sender: Any) {
        mapView.deselectAnnotation(selectedAnnotation, animated: true)
    }
    
    @IBAction func routeTapped(_ sender: Any) {
        guard let annotation = selectedAnnotation else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil))
        mapItem.name = annotation.title ?? ""
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func configureBottomView(betShop: BetShop) {
        betShopName.text = betShop.name
        betShopAddress.text = betShop.address
        betShopCityCountry.text = betShop.city + " - " + betShop.country
        
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour], from: date)
        guard let hour = dateComponents.hour else { return }
        let currentTime = hour
        let openTime = 8
        let closeTime = 16
        
    
        if currentTime >= openTime && currentTime <= closeTime {
            openLabel.text = "Open now until 16:00"
        } else if currentTime < openTime {
            openLabel.text = "Opens today at 8:00"
        } else {
            openLabel.text = "Opens tomorrow at 8:00"
        }
    }
}
