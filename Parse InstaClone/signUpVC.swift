//
//  signUpVC.swift
//  Parse InstaClone
//
//  Created by Maverick on 12/5/20.
//  Copyright © 2020 Maverick. All rights reserved.
//

import UIKit
import Parse
class signUpVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func SignInClicked(_ sender: Any) {
        
        if emailTxt.text! != "" {
            if passwordTxt.text! != "" {
                PFUser.logInWithUsername(inBackground: emailTxt.text!, password: passwordTxt.text!) { (user, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        
                    } else {
                        
                        UserDefaults.standard.set(self.emailTxt.text!, forKey: "email")
                        UserDefaults.standard.synchronize()
                        
                        
                        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                            delegate.rememberLogin()
                        
                            let email : String? = UserDefaults.standard.string(forKey: "email")
                            
                            if email != nil {
                                
                                let borad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let TabBar = borad.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                                
                                let window = UIWindow()
                                window.rootViewController = TabBar
                            }
                            
                
                    }
                }
            }
        }
        
        
        
    }
    
    @IBAction func SignUpClicked(_ sender: Any) {
        
        let user = PFUser()
        user.username = emailTxt.text
        user.password = passwordTxt.text
        
        user.signUpInBackground { (success, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                print("Signed up succesfully!")
            }
        }
    }
    


}
