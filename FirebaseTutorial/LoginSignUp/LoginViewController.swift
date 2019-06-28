//
//  LoginViewController.swift
//  FirebaseTutorial
//
//  Created by James Dacombe on 16/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
var finalUserID = ""
class LoginViewController: UIViewController,GIDSignInUIDelegate {

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
//Outlets
@IBOutlet weak var emailTextField: UITextField!
@IBOutlet weak var passwordTextField: UITextField!

    var values = [String : Any]()

    override func viewDidLoad() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TBC") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                // User is signed in. Show home screen
            }else{
                GIDSignIn.sharedInstance().uiDelegate = self
            }
        }
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                let userRef = Database.database().reference().child("Patients")
                
                self.values = ["fullName":user?.displayName! ?? "Your Name"]
                userRef.child((user?.uid)!).child("BasicInfo").updateChildValues(self.values, withCompletionBlock: { (error, snapshot) in
                    if error != nil {
                        print("oops, an error")
                    } else {
                        print("completed")
                        
                    }
                })
                // Present the main view
                
                let defaults = UserDefaults.standard
                if defaults.object(forKey: "isFirstTimeLoggingInaa") == nil {
                    print("first time using app")
                    
                    defaults.set("No", forKey:"isFirstTimeLoggingInaa")
                    defaults.synchronize()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
                    let viewController = storyboard.instantiateViewController(withIdentifier: "profileData")
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
                /*
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TBC") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }*/
                
            })
            
        }
    }
    
    //Login Action
    @IBAction func loginAction(_ sender: AnyObject) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    finalUserID = (user?.uid)!
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    /*
                    let defaults = UserDefaults.standard
                    if defaults.object(forKey: "isFirstTimeLoggingIn") == nil {
                        print("first time using app")
                        
                        defaults.set("No", forKey:"isFirstTimeLoggingIn")
                        defaults.synchronize()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
                        let viewController = storyboard.instantiateViewController(withIdentifier: "BasicInfoVC")
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                    */
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBC")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }}
