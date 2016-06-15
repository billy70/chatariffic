//
//  ViewController.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/12/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(FIREBASE_KEY_UID) != nil {
            print("Performing segue from viewDidAppear().")
            self.performSegueWithIdentifier(SEGUE_ID_SHOW_CHAT, sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
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
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                
                    if error != nil {
                        print("Firebase login via Facebook failed! Error: \(error)")
                    } else {
                        print("Firebase login via Facebook successful. Firebase auth data: \(user)")
                        
                        // Save the user to Firebase.
                        // FIXME: Add error handling for the case that firebaseAuthData.provider == nil.
                        let userData = ["provider": credential.provider, "blahblah": "test"]
                        DataService.ds.createFirebaseUser(user!.uid, user: userData)
                        
                        // Save the Firebase user ID onto the user's device.
                        NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: FIREBASE_KEY_UID)
                        
                        self.performSegueWithIdentifier(SEGUE_ID_SHOW_CHAT, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func emailLoginTapped(sender: UIButton!) {
        
        if let email = emailField.text where email != "", let password = passwordField.text where password != "" {
            
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: {
                (user, error) in
                
                if error != nil {
                    
                    print("Firebase authentication failure. Error code: \(error!.code)")
                    print("   Error: \(error)")

                    if let errorCode = FIRAuthErrorCode(rawValue: error!.code) {
                        switch (errorCode) {
                            case .ErrorCodeUserNotFound:
                                print("Handle invalid user")
                            
                                FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
                                    
                                    if error != nil {
                                        self.showErrorAlert("Could not create account", message: "Problem creating account. Please try again.")
                                    } else {
                                        NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: FIREBASE_KEY_UID)

                                        // Save the user to Firebase.
                                        // FIXME: Add error handling for the case that firebaseAuthData.provider == nil.
                                        let userData = ["provider": "email"]
                                        DataService.ds.createFirebaseUser(user!.uid, user: userData)
                                        
                                        print("User logged in successfully.")
                                        self.performSegueWithIdentifier(SEGUE_ID_SHOW_CHAT, sender: nil)
                                    }
                                })
                            case .ErrorCodeEmailAlreadyInUse:
                                print("Handle email already taken")
                                self.showErrorAlert("Email address already taken", message: "The email address \(email) is already taken. Please use a different email address.")
                            case .ErrorCodeInvalidEmail:
                                print("Handle invalid email")
                                self.showErrorAlert("Email address is invalid", message: "The email address \(email) is invalid. Please use a valid email address.")
                            case .ErrorCodeWrongPassword:
                                print("Handle invalid password")
                                self.showErrorAlert("Password invalid", message: "The password is invalid. Please use the correct password.")
                            default:
                                print("Handle default situation")
                                self.showErrorAlert("An unknown error occurred.", message: "Please try again with different credentials, or try again later.")
                        }
                    }  // END if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
                } else {
                    // User is logged into Firebase.
                    print("User sucessfully logged into Firebase with email/password.")
                    self.performSegueWithIdentifier(SEGUE_ID_SHOW_CHAT, sender: nil)
                    
                }
            })
        } else {
            showErrorAlert("Email and password required", message: "You must enter an email and password to signup.")
        }
    }
}
