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
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
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
                
                self.updateUI(json: weatherJSON)
            } else {
                self.notificationLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateUI(json: JSON) {
        var ifRain = false
        var hour = -1
        
        let city = json["city"]["name"].stringValue
        cityLabel.text = city
        
        for i in 0...4 {
            let weather = json["list"][i]["weather"][0]["main"]
            
            if weather == "Rain" {
                ifRain = true
                hour = i
                break
            }
        }
        
        if ifRain {
            notificationLabel.text = "Bring your umbrella"
            infoLabel.text = hour == 0 ? "It is currently raining" : "It will rain in \(hour) hours"
           
        } else {
            notificationLabel.text = "Do not bring your umbrella"
            infoLabel.text = "It will not rain for the next 12 hours"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        notificationLabel.text = "Location unavailable"
    }


}

