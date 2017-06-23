//
//  ViewController.swift
//  kzPost
//
//  Created by Dosbol Duysekov on 6/12/17.
//  Copyright © 2017 Dosbol Duysekov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController {
    
    var theCode: String?
    // MARK: Don't add "s" to the end of "http"
    let url: String = "http://track.kazpost.kz/api/v2/"
    let gUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?address="
    var cities: [String] = []
    var latitudes: [String] = []
    var longitudes: [String] = []
    var coord: [CLLocationCoordinate2D] = []
    
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    
    
    func callAlamo(url: String, param: String, key: String) {
        Alamofire.request(url + param + key, method: .post).responseJSON(completionHandler: {  response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonValue = JSON(value)
                    
                    let events = jsonValue["events"].arrayValue
                    
                    for event in 0..<(events.count) {

                        self.cities.append(jsonValue["events"][event]["activity"][0]["city"].stringValue.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
//                        print("event: ", event)
                    
                    }
//                    print("cities: ", self.cities)
                    
                    for city in self.cities {
                        self.getCoord(url: self.gUrl, param: city, key: "&key=AIzaSyDgsBU36H-W6lj5FYT9EbexmLpgRyj0I38")
//                        print("city: ", city)
                    }
                }
            case .failure(let error):
                print("error: \(error)")
            }
            
        })
    }
    
    
    func getCoord(url: String, param: String, key: String) {
        Alamofire.request(url + param + key, method: .post).responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonValue = JSON(value)
                    
//                    self.latitudes.append(String(jsonValue["results"][0]["geometry"]["location"]["lat"].doubleValue))
//                    self.longitudes.append(String(jsonValue["results"][0]["geometry"]["location"]["lng"].doubleValue))
                    let lat = jsonValue["results"][0]["geometry"]["location"]["lat"].doubleValue
                    let lng = jsonValue["results"][0]["geometry"]["location"]["lng"].doubleValue

                    self.coord.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    //print("COORD: ", self.coord)
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Map") {
            if let mvc = segue.destination as? MapViewController {
            mvc.coordM = self.coord
            print("segue coordM is not empty: ", mvc.coordM)
            }
        }
    }
    
    @IBAction func getTheFuckingInfo(_ sender: Any) {
        if textField.text != nil {
        theCode = textField.text
        callAlamo(url: url, param: theCode!, key: "/events")
        }
        print("RED button was pressed")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //cities.removeAll()
        //coord.removeAll()
    }
    
    
    @IBAction func findBtn(_ sender: Any) {
        if textField.text != nil {
            theCode = textField.text
            callAlamo(url: url, param: theCode!, key: "/events")
        }
        print("BLUE button was pressed")
    }


}
