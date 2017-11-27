//
//  ViewController.swift
//  PokeFinder
//
//  Created by Руслан Акберов on 26.11.2017.
//  Copyright © 2017 Ruslan Akberov. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapCenteredOnce = false
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapCenteredOnce {
                centerMapOnLocation(location: loc)
                mapCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotataionView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotataionView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotataionView?.image = UIImage(named: "Ash")
        }
        return annotataionView
        
    }
    
    func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int) {
        geoFire.setLocation(location, forKey: "\(pokeId)")
    }
    
    func showSigthningsOnMap(location: CLLocation) {
        
    }

    @IBAction func spotRandomPokemon(_ sender: UIButton) {
    }
    
}











