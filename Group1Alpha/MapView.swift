//
//  MapView.swift
//  Group1Alpha
//
//  Created by Davis Owen on 4/8/18.
//  Copyright © 2018 Preimesberger, Freya M. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapView: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 5000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        mapView.frame = view.bounds
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
        fetchNearbyPlaces(coordinate: (location?.coordinate)!)
        
    }
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius) { places in
            places.forEach {
                let marker = GMSMarker(position: $0.coordinate)
                marker.icon = GMSMarker.markerImage(with: .green)
                marker.map = self.mapView
            }
        }
    }
}
