//
//  BubbleVC.swift
//  locator
//
//  Created by Sergej Birklin on 20/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit
import PromiseKit

class BubbleVC: UIViewController {
    
    let maxDistance: Float = 20000.0
    let limit = 6
    let colorRed = Color.red()
    
    @IBOutlet weak var schoenHier: UIButton!
    var locations = [Location]()
    var detailLocation: Location?
    
    var gps:GpsService!
    
    // Schoenhier
    @IBOutlet weak var schoenHierImageView: UIImageView!
    // UserProfil
    @IBOutlet weak var userProfilImageView: UIImageView!
    // First Bubble
    @IBOutlet weak var firstBubbleImageView: BubbleView!
    // Second Bubble
    @IBOutlet weak var secondBubbleImageView: BubbleView!
    // Third Bubble
    @IBOutlet weak var thirdBubbleImageView: BubbleView!
    // Fourth Bubble
    @IBOutlet weak var fourthBubbleImageView: BubbleView!
    // Fifth Bubble
    @IBOutlet weak var fifthBubbleImageView: BubbleView!
    // Sixth Bubble
    @IBOutlet weak var sixthBubbleImageView: BubbleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BoardingService.showBoarding(self)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "map_icon_white"), style: .Plain, target: self, action: #selector(self.showMap))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "reload_white"), style: .Plain, target: self, action: #selector(self.resolveBubblePromises))
        
        gps = GpsService(successHandler: gpsSuccessHandler, deniedHandler: gpsDeniedHandler)
        addGestureRecognizer()
        //self.loadBubbles()
        
        userProfilImageView = UtilService.roundImageView(userProfilImageView, borderWidth: 3)
    }
    
    func showUserThumb() {
        
        if let imgData: NSData = NSUserDefaults.standardUserDefaults().objectForKey("userimg") as? NSData {
            userProfilImageView.image = UIImage(data: imgData)
            
        } else {
            
            if let imagePath = User.me?.imagePathNormal {
                UtilService.dataFromCache(imagePath).then {
                    result -> Void in
                    self.userProfilImageView.image = UIImage(data: result)
                    
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        showUserThumb()
    }
    
    func loadBubbles() {
        let location = gps.getMaybeCurrentLocation()
        let lat = location.keys.first
        let long = location.values.first
        
        BubbleService.getBubbles(lat!, long: long!, maxDistance: maxDistance, limit: limit).then { bubbles -> Void in

            self.locations = bubbles
            for (index, element) in self.locations.enumerate() {
                self.loadLocationImage(index, urlPath: element.imagePathNormal)
            }
            
            }.then {
                result -> Void in
                self.reloadInputViews()
                
                self.firstBubbleImageView.show()
                self.secondBubbleImageView.show()
                self.thirdBubbleImageView.show()
                self.fourthBubbleImageView.show()
                self.fifthBubbleImageView.show()
                self.sixthBubbleImageView.show()
            }.error {
                err -> Void in
                AlertService.simpleAlert(self, message: "Da ist etwas schief gelaufen.. pardon")
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            resolveBubblePromises()
            TrackingService.sharedInstance.trackEvent("Bubble | shake")
        }
    }
    
    func resolveBubblePromises() {
        let prom1 = self.firstBubbleImageView.hide()
        let prom2 = self.secondBubbleImageView.hide()
        let prom3 = self.thirdBubbleImageView.hide()
        let prom4 = self.fourthBubbleImageView.hide()
        let prom5 = self.fifthBubbleImageView.hide()
        let prom6 = self.sixthBubbleImageView.hide()
        
        when(prom1, prom2, prom3, prom4, prom5, prom6).then {
            result -> Void in
            self.loadBubbles()
        }
    }
    
    func gpsDeniedHandler(accessGranted: Bool) {
        if !accessGranted {
            let alert = UIAlertController(title: "GPS aktivieren", message: "Du musst dein GPS aktivieren um Locations in deiner nähe entdecken zu können.",preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Gerne", style: UIAlertActionStyle.Default, handler: AlertService.openAppSettings))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func gpsSuccessHandler(accessGranted: Bool) {
        self.loadBubbles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUserProfilImageView()
        layoutBubble(firstBubbleImageView)
        layoutBubble(secondBubbleImageView)
        layoutBubble(thirdBubbleImageView)
        layoutBubble(fourthBubbleImageView)
        layoutBubble(fifthBubbleImageView)
        layoutBubble(sixthBubbleImageView)
    }
    
    func layoutUserProfilImageView() {
        userProfilImageView.layer.cornerRadius = userProfilImageView.frame.width / 2
        userProfilImageView.clipsToBounds = true
    }
    
    func layoutBubble(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = colorRed.first.CGColor
        imageView.layer.borderWidth = 4
    }
    
    func addGestureRecognizer() {
        let schoenHierGesture = UITapGestureRecognizer(target:self, action:#selector(self.schoenHierTapped(_:)))
        
        let schoenHierGesture_hold = UILongPressGestureRecognizer(target:self, action:#selector(self.schonHierLongPress(_:)))
        
        schoenHier.addGestureRecognizer(schoenHierGesture)
        schoenHier.addGestureRecognizer(schoenHierGesture_hold)
        
        let userProfileGesture = UITapGestureRecognizer(target:self, action:#selector(self.userProfileTapped(_:)))
        userProfilImageView.addGestureRecognizer(userProfileGesture)
        let firstBubbleGesture = UITapGestureRecognizer(target:self, action:#selector(self.firstBubbleTapped(_:)))
        firstBubbleImageView.addGestureRecognizer(firstBubbleGesture)
        let secondBubbleGesture = UITapGestureRecognizer(target:self, action:#selector(self.secondBubbleTapped(_:)))
        secondBubbleImageView.addGestureRecognizer(secondBubbleGesture)
        let thirdBubbleGesture = UITapGestureRecognizer(target:self, action:#selector(self.thirdBubbleTapped(_:)))
        thirdBubbleImageView.addGestureRecognizer(thirdBubbleGesture)
        let fourthBubbleGesture = UITapGestureRecognizer(target:self, action:#selector(self.fourthBubbleTapped(_:)))
        fourthBubbleImageView.addGestureRecognizer(fourthBubbleGesture)
        let fifthBubbleGesture = UITapGestureRecognizer(target:self, action:#selector(self.fifthBubbleTapped(_:)))
        fifthBubbleImageView.addGestureRecognizer(fifthBubbleGesture)
        let sixthBubbleGesture = UITapGestureRecognizer(target:self, action:#selector(self.sixthBubbleTapped(_:)))
        sixthBubbleImageView.addGestureRecognizer(sixthBubbleGesture)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
        rightSwipe.direction = .Left
        view.addGestureRecognizer(rightSwipe)
    }
    
    func schoenHierTapped(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("map", sender: self)
    }
    
    func schonHierLongPress(sender: UILongPressGestureRecognizer) {
        if (sender.state == .Began) {
            if AlertService.validateLoggedUser(self) {
                performSegueWithIdentifier("createLocation", sender: self)
            }
        }
    }
    
    func userProfileTapped(imageView: UIImageView) {
        if !AlertService.validateLoggedUser(self) {
            return
        }
        performSegueWithIdentifier("showOwnProfil", sender: self)
    }
    
    func firstBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[0]
        showDetailView()
    }
    
    func secondBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[1]
        showDetailView()
    }
    
    func thirdBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[2]
        showDetailView()
    }
    
    func fourthBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[3]
        showDetailView()
    }
    
    func fifthBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[4]
        showDetailView()
    }
    
    func sixthBubbleTapped(imageView: UIImageView) {
        detailLocation = locations[5]
        showDetailView()
    }
    
    func loadLocationImage(bubble: Int, urlPath: String) {
        
        if urlPath == "" {
            return
        }
        
        UtilService.dataFromCache(urlPath).then { image -> Void in
            switch bubble{
            case 0:
                self.firstBubbleImageView.image = UIImage(data: image)
            case 1:
                self.secondBubbleImageView.image = UIImage(data: image)
            case 2:
                self.thirdBubbleImageView.image = UIImage(data: image)
            case 3:
                self.fourthBubbleImageView.image = UIImage(data: image)
            case 4:
                self.fifthBubbleImageView.image = UIImage(data: image)
            case 5:
                self.sixthBubbleImageView.image = UIImage(data: image)
            default:
                break
            }
        }
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe left")
            self.showMap()
        }
    }
    
    func showMap() {
        self.performSegueWithIdentifier("map", sender: self)
    }
    
    func showDetailView() {
        performSegueWithIdentifier("showDetailLocation", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetailLocation") {
            
            if let destinationVC: LocationDetailVC = segue.destinationViewController as? LocationDetailVC {
                destinationVC.location = detailLocation
            }
        } else if (segue.identifier == "showOwnProfil") {
            if let destination: UserVC = segue.destinationViewController as? UserVC {
                destination.user = User.me
            }
        } else if let destinationVC: MapVC = segue.destinationViewController as? MapVC {
            destinationVC.initialSchoenHier = true
        }
    }
    
}
