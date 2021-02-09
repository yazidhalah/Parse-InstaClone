//
//  FirstViewController.swift
//  Parse InstaClone
//
//  Created by Maverick on 12/3/20.
//  Copyright © 2020 Maverick. All rights reserved.
//

import UIKit
import Parse

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TableView: UITableView!
    
    var ownerArray = [String]()
    var commetnArray = [String]()
    var imageArray = [PFFileObject]()
    var uuidArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
    
        getData()
        
        // to hide keyborad
        
        let KeyboardGR = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKey))
        self.view.addGestureRecognizer(KeyboardGR)
        
    }
    @objc func hideKey(){
        
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(feedVC.getData), name: NSNotification.Name(rawValue: "new"), object: nil)
    }
    
    @objc func getData(){
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Try Again", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                self.ownerArray.removeAll(keepingCapacity: false)
                self.commetnArray.removeAll(keepingCapacity: false)
                self.imageArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.ownerArray.append(object.object(forKey: "owner") as! String)
                    self.commetnArray.append(object.object(forKey: "PostComment") as! String)
                    self.uuidArray.append(object.object(forKey: "PostUUID") as! String)
                    
                    self.imageArray.append(object.object(forKey: "PostImage") as! PFFileObject)
                    
                }
                self.TableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ownerArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCellVC
        cell.usernameLabel.text = self.ownerArray[indexPath.row]
        cell.PostComment.text = self.commetnArray[indexPath.row]
        cell.UUIDLbl.text = self.uuidArray[indexPath.row]
        
        self.imageArray[indexPath.row].getDataInBackground { (data, error) in
            if error != nil {
                let alert = UIAlertController(title: "Try Again", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                cell.postedImage.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    @IBAction func LogoutClicked(_ sender: Any) {
        
        PFUser.logOutInBackground { (error) in
            
            if error != nil {
                
                let alert = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "dismiss", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.synchronize()
                
                let Signup = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! signUpVC
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = Signup
                delegate.rememberLogin()
            }
        }
        
    }
    

}

