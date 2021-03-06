//
//  TextImpression.swift
//  locator
//
//  Created by Michael Knoch on 24/02/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class TextImpressionCell: UITableViewCell {

    var user:User!
    var rootVC: LocationDetailVC!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userThumb: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var textheight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func redirectUser(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("UserVC") as! UserVC
        nextViewController.user = self.user
        self.rootVC.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
