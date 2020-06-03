//
//  MapManager.swift
//  MyPlaces
//
//  Created by mac on 04.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit
import MapKit

class MapManager {
    
    let locationManager = CLLocationManager()
    private let regionInMeters: Double = 1000.00
    private var directionsArray: [MKDirections] = []
    private var placeCoordinate: CLLocationCoordinate2D?
    
    // Метод отвечающий за отображающего маркера заведения на карте
    func setupPlacemark(place: Place, mapView: MKMapView) {
        
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
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarckLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarckLocation.coordinate
            self.placeCoordinate = placemarckLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true) // что бы выделить созданую аннотацию у mapView
        }
    }
    
    //Проверка доступности сервисов геолокации
     func checkLocationServices(mapView: MKMapView, segueIdentifire: String, closure: ()->()) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAutorization(mapView: mapView, segueIdentifire: segueIdentifire)
            closure()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showLocationAlert()
            }
        }
    }
    
    // Проверка авторизации приложения для использования сервисов геолокации
     func checkLocationAutorization(mapView: MKMapView, segueIdentifire: String) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if segueIdentifire == "getAddress" {
                showUserLocation(mapView: mapView)
            }
            break
        case .denied:
            showLocationAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            showLocationAlert()
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is available")
        }
    }
    
    // Фокус карты на местоположении пользователя
     func showUserLocation(mapView: MKMapView) {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //  Строим маршрут от местоположения пользователя до заведения
     func getDirections(for mapView: MKMapView, previousLocation: (CLLocation)->()) {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        // создаем маршрут на основе всех сведеней
        let directions = MKDirections(request: request)
        
        resetMapView(withNew: directions, mapView: mapView) // удаляем текущие маршруты
        
        // запускаем расчет маршрута
        directions.calculate { (response, error) in
            if let error = error {
                print("Error:", error)
                return
            }
            
            guard let response = response else {
                self.showAlert(title: "Error", message: "Directions is not available")
                return
            }
            
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true) // маршрут виден полностью
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime
                
                print("distance: \(distance) km")
                print("timeInterval: \(timeInterval) sec")
            }
        }
    }
    
    // Метод для настройки запроcа построения (расчета) маршрута
     func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate) // начальная точка
        let destination = MKPlacemark(coordinate: destinationCoordinate) // конечная точка маршрута
        
        let requst = MKDirections.Request()
        requst.source = MKMapItem(placemark: startingLocation)
        requst.destination = MKMapItem(placemark: destination)
        requst.transportType = .automobile // задаем тип транспорта
        requst.requestsAlternateRoutes = true
        
        return requst
    }
    
    //Меняем отображаемую зону области карты в сообветствии с перемещением пользователя
     func startTrackingUserLocation(for mapView: MKMapView, and location: CLLocation?, closure: (_ currentLocation: CLLocation)-> ()) {
        
        guard let location = location else { return }
        let center = getCenterLocation(for: mapView)
        
        guard center.distance(from: location) > 50 else { return }
        
        closure(center)
    }
    
    // Сброс всех ранее построеных маршрутов перед построением нового
     func resetMapView(withNew directions: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map{ $0.cancel() }
        directionsArray.removeAll()
    }
    
    // Определение центра отображаемой области карты
     func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    // MARK: - Alert
     func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
     func showLocationAlert() {
        let alertController = UIAlertController(title: "Location Services Disabled", message: "To enable it go: Settings -> Privacy -> Location Services and turn On", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
