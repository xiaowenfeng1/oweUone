//
//  LoginViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

        
        let loginButton: FBSDKLoginButton = {
            let button = FBSDKLoginButton()
            button.readPermissions = ["email"]
            return button
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(loginButton)
            loginButton.center = view.center
            
            // check if is logged in
            if let _ = FBSDKAccessToken.currentAccessToken() {
                fetchProfile()
            }
        }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        fetchProfile()
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
          //  var email = user["email"] as? String
            //let firstName = user["first_name"] as? String
            //let lastName = user["last_name"] as? String
            
            //self.nameLabel.text = "\(firstName!) \(lastName!)"
            
            //var pictureUrl = ""
            
           // if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
             //   pictureUrl = url
            //}
            
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
 
}
