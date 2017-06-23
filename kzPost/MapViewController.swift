//
//  MapViewController.swift
//  
//
//  Created by Dosbol Duysekov on 6/16/17.
//
//

import Foundation
import MapKit
import UIKit
import CoreLocation

class MapViewController: ViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let locationManager = CLLocationManager()
    let CN = CLLocation(latitude: 26.0613900, longitude: 119.3061100)
    let middle = CLLocation(latitude: 43.8009600, longitude: 87.6004600)
    let ALA = CLLocation(latitude: 43.238949, longitude: 76.889709)
    var citiesM: [String] = []
//    var latitudesM: [String] = []
//    var longitudesM: [String] = []
    var coordM: [CLLocationCoordinate2D] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        map.showsScale = true
        map.showsCompass = true
        map.isZoomEnabled = true
        map.delegate = self
        locationManager.delegate = self
        
        //MARK: I was trying to Make new CLLocation called "coord" and put it to the map. But I got some prolems with types
    
        
//        var coordinates = [ALA.coordinate]
        
       
        if !(coordM.isEmpty) {
            print("coord.isEmpty: ", coordM.isEmpty)
            activityIndicator.stopAnimating()
            let geodesicPolyline = MKGeodesicPolyline(coordinates: coordM, count: coordM.count)
            map.add(geodesicPolyline)
        }
        
    
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        renderer.alpha = 0.5
        
        return renderer
    }
}
