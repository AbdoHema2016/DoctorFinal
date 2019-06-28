//
//  HomeViewController.swift
//  FirebaseTutorial
//
//  Created by James Dacombe on 16/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    @IBAction func changeProfilePic_Btn(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated:true){
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            userImage_Image.image = image
        }else{
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var userName_TxtField: UITextField!
    
    @IBOutlet weak var userJob_TxtField: UITextField!
    
    @IBOutlet weak var userGender: UITextField!
    
    @IBOutlet weak var userBirthday_TxtField: UITextField!
    
    @IBOutlet weak var userPhoneNum_TxtField: UITextField!
    
    
    
    
    
    
    
     var TableArray = [String]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            print("section = 0")
        }
        if(section == 1){
            print("section = 1")
        }
        if(section == 2){
            print("section = 2")
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
    

    @IBOutlet weak var age_Lbl: UILabel!
    @IBOutlet weak var userImage_Image: UIImageView!
    @IBOutlet weak var userName_Lbl: UILabel!
    
    @IBOutlet weak var userAge_Lbl: UILabel!
    @IBOutlet weak var emailAddress_Lbl: UILabel!
    @IBAction func settings_Btn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    
    
    @IBOutlet weak var internetConnection: UILabel!
    //object for the internet connectivity reachability class
    let reachability = MyReachability()!
    func internetChanged(note: Notification) {
        
        let reachability = note.object as! MyReachability
        if reachability.isReachable{
            if reachability.isReachableViaWiFi{
                DispatchQueue.main.async {
                    
                    self.internetConnection.isHidden = true
                   
                    
                }
            }else{
                DispatchQueue.main.async {
                    
                    self.internetConnection.isHidden = true
                  
                    
                }
            }
        }else{
            DispatchQueue.main.async {
                
                self.internetConnection.isHidden = false
            }
        }
    }
    var ref = Database.database().reference().child("History")
    var userRef = Database.database().reference().child("Patients")
    let user = Auth.auth().currentUser
    var historyList = [DataSnapshot]()
    var values = [String : Any]()
    
    @IBOutlet weak var previousAppointmentsTV: UITableView!
    
    @IBAction func next_Btn(_ sender: UIButton) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = self.userName_TxtField.text ?? "Please Enter your Name"
        
        changeRequest?.commitChanges { (error) in
            print(error.debugDescription)
        }
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("IOS").child("\(imageName).png")
         if let image = self.userImage_Image.image {
            if let uploadData = UIImageJPEGRepresentation(image, 0.5){
                storageRef.putData(uploadData, metadata: nil, completion: {
                    (metadata,error) in
                    if error != nil{
                        print(error!)
                        return
                    }
            if let postImageUrl = metadata?.downloadURL()?.absoluteString{
                
                let changePhotoRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changePhotoRequest?.photoURL = metadata?.downloadURL()
                
                changePhotoRequest?.commitChanges { (error) in
                    print(error.debugDescription)
                }
                
                print(postImageUrl + "here")
                self.values = ["age":self.userBirthday_TxtField.text ?? "Please Enter your Name","fullName":self.userName_TxtField.text!,"jobTitle":self.userJob_TxtField.text!,"phoneNumber":self.userPhoneNum_TxtField.text!,"gender":self.userGender.text!,"profilePic":postImageUrl]
                
                self.userRef.child((self.user?.uid)!).child("BasicInfo").updateChildValues(self.values, withCompletionBlock: { (error, snapshot) in
                    if error != nil {
                        print("oops, an error")
                    } else {
                        print("completed")
                        
                    }
                })
                
                    }
                })
                
            }
            
        }
        
        
        
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
        let viewController = storyboard.instantiateViewController(withIdentifier: "TBC")
        UIApplication.shared.keyWindow?.rootViewController = viewController
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userName_TxtField.resignFirstResponder()
        userBirthday_TxtField.resignFirstResponder()
        userJob_TxtField.resignFirstResponder()
        userPhoneNum_TxtField.resignFirstResponder()
        
        
        
    }
    /*
    @IBAction func back_Btn(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
        let viewController = storyboard.instantiateViewController(withIdentifier: "TBC") as! UITabBarController
        viewController.selectedIndex = 3
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        self.dismiss(animated: true, completion: nil)
        
        
    }*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref =  self.ref.child((user?.uid)!)
        if let user = self.user {
           
            let displayName = user.displayName
            
           
            self.userName_TxtField.text = displayName
                          }
       
        userRef.child((user?.uid)!).child("BasicInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            // let userAge = value?["age"] as? String ?? ""
            let userJob = value?["jobTitle"] as? String ?? ""
            let userGenderText = value?["gender"] as? String ?? ""
            let userBirthday = value?["age"] as? String ?? ""
            let userphoneNum = value?["phoneNumber"] as? String ?? ""
            //let userName = value?["fullName"] as? String ?? ""
            self.userJob_TxtField.text = userJob
            self.userGender.text = userGenderText
            self.userPhoneNum_TxtField.text = userphoneNum
            self.userBirthday_TxtField.text = userBirthday
            //let user = User(username: username)
            //self.age_Lbl.text = userAge
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
         TableArray = ["All","Cavities","Teeth health"]
        let userID = Auth.auth().currentUser?.uid
        userRef.child(userID!).child("BasicInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
           // let userAge = value?["age"] as? String ?? ""
            let userJob = value?["jobTitle"] as? String ?? ""
            let userGenderText = value?["gender"] as? String ?? ""
            let userBirthday = value?["age"] as? String ?? ""
            let userphoneNum = value?["phoneNumber"] as? String ?? ""
            //let userName = value?["fullName"] as? String ?? ""
            self.userJob_TxtField.text = userJob
            self.userGender.text = userGenderText
            self.userPhoneNum_TxtField.text = userphoneNum
            self.userBirthday_TxtField.text = userBirthday
            //let user = User(username: username)
            //self.age_Lbl.text = userAge
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            if let user = self.user {
                
                let displayName = user.displayName
                //let photoURL = user.photoURL?.absoluteString
                //let email = user.email
                let otherImage = "https://firebasestorage.googleapis.com/v0/b/doctor-6a5df.appspot.com/o/cavity.png?alt=media&token=37edfbdd-da45-42ec-9295-2cc67fb9af1f"
                if let data = try? Data(contentsOf: user.photoURL ?? URL(string: otherImage)!){
                    userImage_Image.image = UIImage(data: data)
                }
                self.userName_TxtField.text = displayName
                //self.emailAddress_Lbl.text = email
                
                //let url = URL(string: photoURL ?? "https://firebasestorage.googleapis.com/v0/b/doctor-6a5df.appspot.com/o/cavity.png?alt=media&token=37edfbdd-da45-42ec-9295-2cc67fb9af1f")
//                if let data = try? Data(contentsOf: url!) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                    self.userImage_Image.image = UIImage(data: data)
//                    //userImage.do
//                    
//                    // ...
//                }
            }
            
            
        }
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                
                self.internetConnection.isHidden = true
            }
            
        }
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                
                self.internetConnection.isHidden = false
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged ), name: ReachabilityChangedNotification, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("couldn't start notifier")
        }
        //let UID = (user?.uid)!
        //ref = ref.child(UID)
        
        

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
