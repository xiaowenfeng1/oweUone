//
//  LoginViewController.swift
//  oweUone
//
//  Created by Xiaowen Feng on 5/17/16.
//  Copyright © 2016 Xiaowen Feng, Peter Freschi, Quynh Huynh. All rights reserved.
//


import UIKit

import FirebaseAuth
import Firebase
import FirebaseDatabase

import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    
    var imageView : UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    let loginButton = FBSDKLoginButton()
    
    let rootRef = FIRDatabase.database().reference()
   
    let user = FIRAuth.auth()?.currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        
        imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        imageView.center = CGPoint(x: view.center.x, y: 200)
        imageView.image = UIImage(named: "fb-art")
        view.addSubview(imageView)
        
        
    }
    
    
    
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
       // loginButton.readPermissions = ["email", "public_profile"]
        //if let error = error {
           // print(error.localizedDescription)
       //     return
        //} else if result.isCancelled {
          //  print("Cancelled")
      //  } else {
            
            getUserInfo()
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            self.firebaseLogin(credential)
        //}
        
    }
    
    func getUserInfo() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            print(FBSDKAccessToken.currentAccessToken().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
            graphRequest.startWithCompletionHandler({ (connection, user, requestError) -> Void in
                let FBid = user.valueForKey("id") as? String
              //  print(FBid!)
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.imageView.image = UIImage(data: NSData(contentsOfURL: url!)!)
            
            
            })
        }
    }
    
    func firebaseLogin(credential: FIRAuthCredential) {
        if let user = FIRAuth.auth()?.currentUser {
            user.linkWithCredential(credential) {(user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    for profile in user!.providerData {
                        let newUser = [
                            "provider": profile.providerID,
                             "Name": profile.displayName,
                             "Email": profile.email!
                        
                        ]
                       //self.rootRef.child("users").child(profile.uid).setValue(newUser as? AnyObject)
                    }
                }
            }
        } else {
            FIRAuth.auth()?.signInWithCredential(credential) {(user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
            }
        }
    }
    
    
    /*
     let userImageView: UIImageView = {
     let imageView = UIImageView()
     imageView.contentMode = .ScaleAspectFit
     imageView.translatesAutoresizingMaskIntoConstraints = false
     imageView.layer.masksToBounds = true
     return imageView
     }()
     
     let nameLabel: UILabel = {
     let label = UILabel()
     label.font = UIFont.boldSystemFontOfSize(20)
     label.textAlignment = .Center
     label.translatesAutoresizingMaskIntoConstraints = false
     return label
     }()
     
     
     
     
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
     
     
     var _ = user["email"] as? String
     let firstName = user["first_name"] as? String
     let lastName = user["last_name"] as? String
     
     self.nameLabel.text = "\(firstName!) \(lastName!)"
     
     var pictureUrl = ""
     
     if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
     pictureUrl = url
     }
     
     let url = NSURL(string: pictureUrl)
     NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
     if error != nil {
     print(error)
     return
     }
     
     let image = UIImage(data: data!)
     dispatch_async(dispatch_get_main_queue(), { () -> Void in
     self.userImageView.image = image
     })
     
     }).resume()
     
     
     })
     }
     
     func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
     
     }
     
     func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
     return true
     }
     
     */
    
    
}
