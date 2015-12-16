//
//  MapVC.swift
//  locator
//
//  Created by Michael Knoch on 15/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

class MapVC: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    var lastLocation: CLLocation!
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = self.view as! GMSMapView
        mapView.camera = GMSCameraPosition.cameraWithLatitude(47.66492492654014, longitude: 9.199697971343934, zoom: 10)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation? = locations.last
        print(location?.coordinate.latitude, location?.coordinate.longitude)
        locationManager.stopUpdatingLocation()
        
        let lat = location?.coordinate.latitude
        let long = location?.coordinate.longitude
        
        print("gps")
        
        showMarker(lat!, long: long!)
        mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(lat!, longitude: long!, zoom: 10))
    }
    


    @IBAction func buttonUp(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }

    func showMarker(lat:Double, long:Double) {
        
        print("lat", lat)
        print("long", long)
        
        let marker = GMSMarker()
        print("creater marker")
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        self.view = mapView
        
        
        getNearby(lat, long: long, maxDistance: 2, limit: 5)
    }
    
    func getNearby(lat: Double, long:Double, maxDistance:Int, limit:Int) {
        
       
        Alamofire.request(.GET, "https://locator-app.com/api/v2/locations/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_,subJson):(String, JSON) in json["results"] {
                    
                        let lat = subJson["geotag"]["coordinates"][1].double
                        let long = subJson["geotag"]["coordinates"][0].double
                        
                        //self.showMarker(lat!, long: long!)
                    }
                }
                
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    

}
