//
//  ViewController.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/12/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbButtonTapped(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error: \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login cancelled.")
            } else {
                let facebookAccessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with Facebook. Token: \(facebookAccessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: facebookAccessToken, withCompletionBlock: { error, firebaseAuthData in
                    
                    if error != nil {
                        print("Firebase login via Facebook failed! Error: \(error)")
                    } else {
                        print("Firebase login via Facebook successful. Firebase auth data: \(firebaseAuthData)")
                        
                        // Save the Firebase user ID onto the user's device.
                        NSUserDefaults.standardUserDefaults().setValue(firebaseAuthData.uid, forKey: FIREBASE_KEY_UID)
                    }
                })
            }
        }
    }
}
