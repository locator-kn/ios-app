//
//  LocationService.swift
//  locator
//
//  Created by Michael Knoch on 16/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LocationService {
    
    static func getNearby(lat: Double, long:Double, maxDistance:Float, limit:Int, callback: (([Location]) -> Void)) {
        
        var nearbyLocations = [Location]()
        
        Alamofire.request(.GET, "https://locator-app.com/api/v2/locations/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_,subJson):(String, JSON) in json["results"] {
                        
                        let lat = subJson["obj"]["geotag"]["coordinates"][1].double
                        let long = subJson["obj"]["geotag"]["coordinates"][0].double
                        let title = subJson["obj"]["title"].string
                        let id = subJson["obj"]["_id"].string
                        
                        nearbyLocations.append(Location(id: id!, title: title!, long: long!, lat: lat!))
                        
                    }
                    callback(nearbyLocations)
                    
                }
                
            case .Failure(let error):
                print(error)
            }
           
        }
    }
    
    
    static func getSchoenHiers(lat: Double, long:Double, maxDistance:Float, limit:Int, callback: (([SchoenHier]) -> Void)) {
        
        var nearbySchoenHiers = [SchoenHier]()
        
        Alamofire.request(.GET, "https://locator-app.com/api/v2/schoenhiers/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_,subJson):(String, JSON) in json["results"] {
                        let lat = subJson["obj"]["geotag"]["coordinates"][1].double
                        let long = subJson["obj"]["geotag"]["coordinates"][0].double
                        let createDate = subJson["obj"]["create_date"].string
                        let id = subJson["obj"]["_id"].string
                        
                        nearbySchoenHiers.append(SchoenHier(id: id!, createDate: createDate!, long: long!, lat: lat!))
                        
                    }
                    callback(nearbySchoenHiers)
                }
                
            case .Failure(let error):
                print(error)
            }
            
        }
    }
    
    
    static func schonHier(lat: Double, long:Double, callback: ((SchoenHier) -> Void)) {
        
        Alamofire.request(.POST, "https://locator-app.com/api/v2/schoenhiers", parameters: ["lat": lat, "long": long]).validate().responseJSON { response in
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                
                    let id = json["_id"].string
                    let lat = json["geotag"]["coordinates"][1].double
                    let long = json["geotag"]["coordinates"][0].double
                    let createDate = json["create_date"].string

                    callback(SchoenHier(id: id!, createDate: createDate!, long: long!, lat: lat!))
                    
                }
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    static func locationById(id: String, callback: ((Location) -> Void)) {
        
        Alamofire.request(.GET, "https://locator-app.com/api/v2/locations/" + id).validate().responseJSON { response in
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    let id = json["_id"].string
                    let title = json["title"].string
                    let lat = json["geotag"]["coordinates"][1].double
                    let long = json["geotag"]["coordinates"][0].double
                    let city = json["city"]["title"].string
                    
                    var imagePath = ""
                    
                    if (json["images"]["normal"].string != nil) {
                        imagePath = json["images"]["normal"].string!
                    }
                    
                    callback(Location(id: id!, title: title!, long: long!, lat: lat!, city: city!, imagePath: imagePath))
                }
                
            case .Failure(let error):
                print(error)
            }
        }
    }

}