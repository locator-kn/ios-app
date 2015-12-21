//
//  LocationDetailVC.swift
//  locator
//
//  Created by Michael Knoch on 20/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit

class LocationDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!

    @IBOutlet weak var locationDescription: UITextView!

    
    @IBOutlet weak var opacity: UIImageView!
    var location:Location!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        LocationService.locationById(location.id) { (result) -> Void in
            print(self.location.title)
           
            let url  = NSURL(string: "https://locator-app.com" + "/api/v1/locations/" + self.location.id + "/supertrip.jpeg?size=max&key=AIzaSyCveLtBw4QozQIkMstvefLSTd3_opSvHS4"),
            data = NSData(contentsOfURL: url!)
            print(url)
            self.imageView.image = UIImage(data: data!)
            self.locationTitle.text = result.title
            self.locationDescription.text = result.description
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.imageView.frame
            gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
            gradient.locations = [0.0, 0.5, 1]
            self.imageView.layer.insertSublayer(gradient, atIndex: 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
