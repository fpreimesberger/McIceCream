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
import Firebase

class MapView: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var ref = Database.database().reference()
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
                let place = $0
                let marker = GMSMarker(position: place.coordinate)
                self.createAddress(place: place){ success in
                    if success{
                        self.checkStatus(place:place){ isOn in
                            if( isOn == 1 ){
                                marker.icon = GMSMarker.markerImage(with: .green)
                            }else if ( isOn == 0 ){
                                marker.icon = GMSMarker.markerImage(with: .red)
                            }else if ( isOn == -1){
                                marker.icon = GMSMarker.markerImage(with: .yellow)
                            }
                            marker.map = self.mapView
                        }
                    }else{
                        print("Failed to check address")
                    }
                }
            }
        }
    }
    func createAddress(place: GooglePlace, completion: @escaping (Bool) -> Void){
        self.ref.child("places").observeSingleEvent(of: .value, with: {(snapshot) in
            if(snapshot.hasChild(place.address) == false) {
                self.ref.child("places").child(place.address).setValue(["isOn": -1])
            }
            completion(true)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func checkStatus(place: GooglePlace, completion: @escaping (Int64) -> Void){
        var isOn: Int64?
        self.ref.child("places").child(place.address).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            isOn = value?["isOn"] as? Int64
            if isOn != nil{
                completion(isOn!)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
