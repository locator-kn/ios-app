//
//  GenericTabBarVC.swift
//  locator
//
//  Created by Michael Knoch on 16/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit
import PageMenu

class UserTabVC: UIViewController {
    
    var locations:[Location]?
    var follower:[User]!
    var following:[User]!
    var user:User!
    
    var locationForSegue: Location?
    var userForSegue: User?
    
    var pageMenu: CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        //Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let locationListCtrl = storyboard.instantiateViewControllerWithIdentifier("LocationListVC") as? LocationListVC
        let favoritedLocations = storyboard.instantiateViewControllerWithIdentifier("LocationListVC") as? LocationListVC
        
        let followerListCtrl = storyboard.instantiateViewControllerWithIdentifier("UserListVC") as? UserListVC
        let followedByListCtrl = storyboard.instantiateViewControllerWithIdentifier("UserListVC") as? UserListVC
        
        locationListCtrl!.title = "Locations"
        favoritedLocations!.title = "Favoriten"
        
        followerListCtrl!.title = "Follower"
        followedByListCtrl!.title = "Folgt"
        
        locationListCtrl!.user = self.user
        
        favoritedLocations!.user = self.user
        favoritedLocations!.showFavoritedLocations = true
        
        followerListCtrl!.user = self.user
        followerListCtrl!.showFollower = true
        followedByListCtrl!.user = self.user
        followerListCtrl!.showFollower = false
        
        favoritedLocations!.parentCtrl = self
        locationListCtrl!.parentCtrl = self
        followerListCtrl!.parentCtrl = self
        followedByListCtrl!.parentCtrl = self
        
        controllerArray.append(locationListCtrl!)
        controllerArray.append(favoritedLocations!)
        controllerArray.append(followedByListCtrl!)
        controllerArray.append(followerListCtrl!)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .ViewBackgroundColor(UIColor(red: 255/0, green: 255/0, blue: 255/0, alpha: 0)),
            .ScrollMenuBackgroundColor(UIColor(red: 255/0, green: 255/0, blue: 255/0, alpha: 0)),
            .MenuItemFont(UIFont(name: "SourceSansPro-Light", size: 16)!),
            .MenuHeight (50),
            .EnableHorizontalBounce(false),
            .CenterMenuItems(true)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)

        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "locationDetail") {
            let locationDetail = segue.destinationViewController as? LocationDetailVC
            locationDetail?.location = self.locationForSegue
        } else if (segue.identifier == "user") {
            let user = segue.destinationViewController as? UserVC
            user?.user = self.userForSegue!
        }
    }


}
