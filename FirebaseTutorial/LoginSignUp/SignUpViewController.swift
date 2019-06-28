//
//  SignUpViewController.swift
//  FirebaseTutorial
//
//  Created by James Dacombe on 16/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmEmail_txtField: UITextField!
  
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmEmail_txtField.resignFirstResponder()
    }
    
    
    
    
    
    var ref = Database.database().reference().child("Patients")
    var values = [String : Any]()
    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if emailTextField.text == "" || confirmEmail_txtField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else if emailTextField.text != confirmEmail_txtField.text{
            
            let alertController = UIAlertController(title: "Error", message: "Please enter the same email address", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    finalUserID = (user?.uid)!
                    print("You have successfully signed up")
                    
                    let finalUID = (user?.uid)!
                    self.values = ["UId":finalUID,"fullName":"Enter your Name"]
                    self.ref.child(finalUID).child("BasicInfo").updateChildValues(self.values, withCompletionBlock: { (error, snapshot) in
                        if error != nil {
                            print("oops, an error")
                        } else {
                            print("completed")
                            
                        }
                    })
                    //
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
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

                    
                    
                    
                    //
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBC")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
}

