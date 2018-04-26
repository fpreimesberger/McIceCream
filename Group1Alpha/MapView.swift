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

class MapView: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
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
        
        
        self.title = "Map"
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        fetchNearbyPlaces(coordinate: (location?.coordinate)!)
    }
    
    // Custom view for each marker selected. Offers info, segue, update info
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 40, height: 15))
        lbl1.text = "Ice cream machine status:" // update here from database
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "<status>"
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        let lbl3 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 23, width: view.frame.size.width - -16, height: 15))
        lbl3.text = "Tap for more!"
        lbl3.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl3)
        
        return view
    }
    
    // Segues to comments if info window is pressed
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker){
        print("Marker window pressed!")
        performSegue(withIdentifier: "comments", sender: marker)
    }
    
    // Segue to comments table if the user presses the icon for a particular location
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comments" {
            var nextVC = segue.destination as! CommentsStuffViewController
            if let marker = sender as? GMSMarker {
                // pull from database for this location
                print("Switched to comments view controller")
            }
            
        }
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
                            marker.title = "Ice cream machine status: <status>"
                            marker.snippet = "Tap for comments or to update"
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
