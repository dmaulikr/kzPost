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
import Alamofire
import SwiftyJSON

class MapViewController: ViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let locationManager = CLLocationManager()
    
    var theCode: String?
    // MARK: Don't add "s" to the end of "http"
    let url: String = "http://track.kazpost.kz/api/v2/"
    let gUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?address="
    var cities: [String] = []
    var latitudes: [String] = []
    var longitudes: [String] = []
    var coord: [CLLocationCoordinate2D] = []
    
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
        
        if theCode != nil { callAlamo(url: url, param: theCode!, key: "/events") }
    }
    
    
    // MARK: Sending Track Number and Getting Cities and Other Info
    func callAlamo(url: String, param: String, key: String) {
        Alamofire.request(url + param + key, method: .post).responseJSON(completionHandler: {  response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonValue = JSON(value)
                    let events = jsonValue["events"].arrayValue
                    for event in 0..<(events.count) {
                        self.cities.append(jsonValue["events"][event]["activity"][0]["city"].stringValue.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
                    }
                    for city in self.cities {
                        self.getCoord(url: self.gUrl, param: city, key: "&key=AIzaSyDgsBU36H-W6lj5FYT9EbexmLpgRyj0I38")
                    }
                }
            case .failure(let error):
                print("error: \(error)")
            }
            
        })
    }

    
    // MARK: Sending Cities and Getting Coordinates From Google
    func getCoord(url: String, param: String, key: String) {
        Alamofire.request(url + param + key, method: .post).responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonValue = JSON(value)
                    let lat = jsonValue["results"][0]["geometry"]["location"]["lat"].doubleValue
                    let lng = jsonValue["results"][0]["geometry"]["location"]["lng"].doubleValue
                    self.coord.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
//                    print("self.coord in getCoord(func): ", self.coord)
                    self.activityIndicator.stopAnimating()
                    let geodesicPolyline = MKGeodesicPolyline(coordinates: self.coord, count: self.coord.count)
                    self.map.add(geodesicPolyline)
                }
            case .failure(let error):
                print(error)
            }
        })
    }

    
    // MARK: Rendering the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        renderer.alpha = 0.5
        
        return renderer
    }
}
