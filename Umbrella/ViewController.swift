//
//  ViewController.swift
//  Umbrella
//
//  Created by Dias Zhassanbay on 3/29/19.
//  Copyright © 2019 Dias Zhassanbay. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : id]
            
            getWeatherData(parameters: params)
        }
    }
    
    func getWeatherData(parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                
                self.forecastRain(json: weatherJSON)
            } else {
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func forecastRain(json: JSON) {
        var ifRain = false
        
        for i in 0...8 {
            let weather = json["list"][i]["weather"][0]["main"]

            if weather == "Rain" {
                ifRain = true
                break
            }
        }
        
        if ifRain {
            cityLabel.text = "Bring your umbrella"
        } else {
            cityLabel.text = "Do not bring your umbrella"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavailable"
    }


}

