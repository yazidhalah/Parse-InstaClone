//
//  FeedCellVC.swift
//  Parse InstaClone
//
//  Created by Maverick on 12/3/20.
//  Copyright © 2020 Maverick. All rights reserved.
//

import UIKit
import Parse

class FeedCellVC: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var PostComment: UITextView!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var UUIDLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UUIDLbl.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func LikeClicked(_ sender: Any) {
        
        let likeobject = PFObject(className: "Likes")
        
        likeobject["from"] = PFUser.current()?.username
        likeobject["to"] = self.UUIDLbl.text
        
        likeobject.saveInBackground { (success, error) in
            
            if error != nil {
                
                let alert = UIAlertController(title: "Try Again", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
            }else{
                
                print("like is saved to the server")
                
            }
            
        }
        
    }
    @IBAction func CommentClicked(_ sender: Any) {
        
        let commentobject = PFObject(className: "Comment")
        
        commentobject["from"] = PFUser.current()?.username
        commentobject["to"] = self.UUIDLbl.text
        
        commentobject.saveInBackground { (success, error) in
            
            if error != nil {
                
                let alert = UIAlertController(title: "Try Again", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
            }else{
                
                print("Comment is saved to the server")
                
            }
            
        }
    }
    
}
