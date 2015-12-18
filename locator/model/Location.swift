//
//  File.swift
//  locator
//
//  Created by Michael Knoch on 16/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class Location {
    
    let id:String
    var title:String
    var geoPosition:(lat :Double, long :Double)
    
    init(id: String, title: String, long: Double, lat: Double ) {
        self.id = id
        self.title = title
        self.geoPosition = (lat: lat, long: long)
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getGeoPosition() -> (lat :Double, long :Double) {
        return self.geoPosition
    }
    
    
}