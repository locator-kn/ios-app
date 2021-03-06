//
//  File.swift
//  locator
//
//  Created by Michael Knoch on 16/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import UIKit

class Location {
    
    let id:String
    var geoPosition:(lat :Double, long :Double)!

    var title:String!
    var city:City!
    
    var imagePathXlarge:String!
    var imagePathLarge: String!
    var imagePathNormal:String!
    var imagePathSmall:String!
    var imagePathEgg:String?
    
    var categories = [String]()
    
    var user:User!
    //favored by me
    var favored:Bool = false
    var favorites:Int!
    var userWhoFavored:[String]!
    var stream:[AbstractImpression]!
    
    init(id: String) {
        self.id = id
    }
    
    init(id: String, title: String, long: Double, lat: Double, city:City, imagePathSmall: String, imagePathNormal:String, imagePathLarge: String, imagePathXlarge:String, favored: Bool, favorites:Int, user: User) {
        self.id = id
        self.title = title
        self.geoPosition = (lat: lat, long: long)

        self.imagePathSmall = imagePathSmall
        self.imagePathNormal = imagePathNormal
        self.imagePathLarge = imagePathLarge
        self.imagePathXlarge = imagePathXlarge
        
        self.favored = favored
        self.favorites = favorites
        self.user = user
        self.city = city
    }
    
}