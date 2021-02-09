//
//  SecondViewController.swift
//  Parse InstaClone
//
//  Created by Maverick on 12/5/20.
//  Copyright © 2020 Maverick. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var PostComment: UITextView!
    
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to hide keyborad
        
        let KeyboardGR = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKey))
        self.view.addGestureRecognizer(KeyboardGR)
        
        // to select an image
        
        ImageView.isUserInteractionEnabled = true
        let GR = UITapGestureRecognizer(target: self, action: #selector(uploadVC.imagePicker))
        ImageView.addGestureRecognizer(GR)
        
        uploadButton.isEnabled = false
    }
    
    @objc func hideKey(){
        
        self.view.endEditing(true)
    }
    
    @objc func imagePicker(){
        
        print("YESS1")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        print("YESS")
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        self.uploadButton.isEnabled = true
        
    }
        

    @IBAction func UploadBtnClicked(_ sender: Any) {
        
        self.uploadButton.isEnabled = true
        
        let post = PFObject(className: "Post")
        
        let Data = ImageView.image?.jpegData(compressionQuality: 0.9)
        
        let uuid = UUID().uuidString
        
        let imagePF = PFFileObject(name: "\(uuid).jpg", data: Data!)
        
        post["PostImage"] = imagePF
        post["PostComment"] = PostComment.text!
        post["owner"] = PFUser.current()!.username!
        post["PostUUID"] = "\(PFUser.current()!.username!)-\(uuid)"
        
        post.saveInBackground { (Success, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Try Again", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                self.PostComment.text = ""
                self.ImageView.image = UIImage(named: "123.png")
                self.tabBarController?.selectedIndex = 0
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "new"), object: nil)
            }
        }
    }
    

}

