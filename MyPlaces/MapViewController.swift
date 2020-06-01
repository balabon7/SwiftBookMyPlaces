//
//  MapViewController.swift
//  MyPlaces
//
//  Created by mac on 01.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var place : Place!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlacemark()
    }
    
    
    @IBAction func closeVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupPlacemark() {
        
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print("Error:", error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation() // используем что бы описать точку на карте
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placemarckLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarckLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true) // что бы выделить созданую аннотацию у mapView
        }
        
    }
    
    
}
