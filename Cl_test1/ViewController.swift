//
//  ViewController.swift
//  Cl_test1
//
//  Created by Admin on 25.09.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ViewController - делегат протокола MKMapViewDelegate
        mapView.delegate = self
        
        
        //Установите широту и долготу местоположения
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let destinitionLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        //Создает объекты - метки, содержащие метки координаты местоположения
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinitionPlacemark = MKPlacemark(coordinate: destinitionLocation, addressDictionary: nil)
        
        //MKMapItems используется для маршрутизации, инкапсулирует информацию о конкретной точке на карте
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinitionMapItem = MKMapItem(placemark: destinitionPlacemark)
        
        //Добавляются Аннотации, которые отображают название меток
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinitionAnnotation = MKPointAnnotation()
        destinitionAnnotation.title = "Empire State Building"
        
        if let location = destinitionPlacemark.location {
            destinitionAnnotation.coordinate = location.coordinate
        }
        //Аннотации отображаются на карте
        self.mapView.showAnnotations([sourceAnnotation,destinitionAnnotation], animated: true)
        
        //Класс MKDitecrionRequest используется для вычисление маршрута
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinitionMapItem
        directionRequest.transportType = .automobile
        
        
        let direction = MKDirections(request: directionRequest)
        // Маршрут рисутеся с использованием полилиний
        direction.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
   // Возвращает объект рендера, который будет использоваться для рисования маршрута на карте
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay:overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
}

