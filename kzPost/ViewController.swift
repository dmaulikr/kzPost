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
    
    var trackNumber: String?
    
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMap") {
            if let mvc = segue.destination as? MapViewController {
                // send theCode
                mvc.theCode = self.trackNumber
                print("mvc.theCode: ", mvc.theCode ?? "mvc is   nil")
                print("trackNumber: ", self.trackNumber ?? "trackNumber is   nil")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //cities.removeAll()
        //coord.removeAll()
    }
    
    
    @IBAction func findBtn(_ sender: Any) {
        if textField.text != nil {
            trackNumber = textField.text
        }
        print("BLUE button was pressed")
    }


}
