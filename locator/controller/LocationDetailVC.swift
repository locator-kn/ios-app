//
//  ImpressionFeedVC.swift
//  locator
//
//  Created by Michael Knoch on 24/02/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit
import PromiseKit

class LocationDetailVC: UITableViewController {

    var location: Location!
    var impressions: [AbstractImpression]?
    @IBOutlet weak var favorIcon: UIButton!
    let favoriteIcon = UIImage(named: "favorite_icon") as UIImage?
    let favoriteIconActive = UIImage(named: "favorite_icon_active") as UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let locationPromise = LocationService.locationById(location.id)
        let impressionsPromise = ImpressionService.getImpressions(location.id)
        
        when(locationPromise, impressionsPromise).then {
            location, impressions -> Void in
            
            self.location = location
            self.title = self.location.title
            
            self.impressions = impressions
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            let  header = tableView.dequeueReusableCellWithIdentifier("headerCell") as! LocationDetailHeaderCell
            header.layoutMargins = UIEdgeInsetsZero;
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = header.locationImage.frame
            gradient.colors = [UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.6) .CGColor, UIColor.clearColor().CGColor]
            gradient.locations = [0.0, 0.5, 1]
            header.locationImage.layer.insertSublayer(gradient, atIndex: 0)
            
            if self.impressions == nil {
                header.locationImage!.image = UIImage()
            } else {
                header.username.setTitle(location.user.name, forState: UIControlState.Normal)
                header.favorCount.text = String(location.favorites)
                header.impressionsCount.text = String(impressions!.count)
                header.locationImage.image = UIImage(data: UtilService.dataFromPath(location.imagePathNormal))
                header.city.text = location.city.title
                
                if location.favored == true {
                    header.favorIcon.setImage(self.favoriteIconActive, forState: .Normal)
                }
            }
            return header
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.impressions == nil {
            return 0
        }
        return self.impressions!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let impression = impressions![indexPath.row]
        
        if let imageImpression = impression as? ImageImpression {
            let cell = tableView.dequeueReusableCellWithIdentifier("imageImpression", forIndexPath: indexPath) as! ImageImpressionCell
          
            cell.date.text = String(imageImpression.date)
            
            UserService.getUser(imageImpression.user.id!).then {
                result -> Void in
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ImageImpressionCell {
                    cellToUpdate.username.text = result.name
                }
                
                UtilService.dataFromCache(result.imagePathThumb!).then {
                    result -> Void in
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ImageImpressionCell {
                        cellToUpdate.userThumb.image = UIImage(data: result)
                    }
                }
            }
            
            UtilService.dataFromCache(API.IMAGE_URL + imageImpression.imagePath).then {
                result -> Void in
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ImageImpressionCell {
                    cellToUpdate.imageBox.image = UIImage(data: result)
                }
            }
            
            return cell
            
        } else if let textImpression = impression as? TextImpression {
            let cell = tableView.dequeueReusableCellWithIdentifier("textImpression", forIndexPath: indexPath) as! TextImpressionCell
            cell.textView.text = textImpression.text
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 380.0
    }
    
    @IBAction func favorLocation(sender: UIButton) {
        
        LocationService.favLocation(location.id).then {
            favors,favor -> Void in
            
            self.location.favorites = favors
            self.location.favored = favor
            
            if (favor) {
                self.favorIcon.setImage(self.favoriteIconActive, forState: .Normal)
            } else {
                self.favorIcon.setImage(self.favoriteIcon, forState: .Normal)
            }
            
            self.tableView.reloadData()
            
            }.error {
                err -> Void in
                print(err)
        }

        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if (segue.identifier == "text") {
            let controller = segue.destinationViewController as! TextImpressionVC
            controller.locationId = self.location.id
        } else if (segue.identifier == "image") {
            let controller = segue.destinationViewController as! ImageImpressionVC
            controller.locationId = self.location.id
        } else if (segue.identifier == "user") {
            let controller = segue.destinationViewController as! UserVC
            controller.user = self.location.user
        } else if (segue.identifier == "map") {
            let controller = segue.destinationViewController as! MapVC
            controller.locationsOfInterest[location.id] = location
        }
    }

}
