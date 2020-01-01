//
//  ReserveVC.swift
//  Doc
//
//  Created by Abdelrhman on 11/11/17.
//  Copyright © 2017 bigNerdeo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import UserNotifications

class ReserveVC: UIViewController {
    var finalDate = ""
    var finalPeriod = ""
    var finalUID = ""
    var ref = Database.database().reference().child("Appoitments")
    var removingRef = Database.database().reference().child("Appoitments")
    let user = Auth.auth().currentUser
    var values = [String : Any]()
    var reservationDay = ""
    var childrenFirebase = UInt()
    var nextInLine = UInt()
    var dateComponents = DateComponents()
    
    let notificationDayDate = Date()
    let nformatter  = DateFormatter()
    
    @IBAction func btn_back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func confirmedAlert(){
        let alert = UIAlertController(title: "Confirmed",
                                      message: "\(finalDate) at \(finalPeriod)",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok",
                                          style: .default, handler: nil)
        chosenAppointment_Lbl.text = "you are scheduled for " + finalDate + " at " + finalPeriod
        alert.addAction(confirmAction)
       
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alert, animated: true)
        
        
    }
    func alert(){
        let defaults = UserDefaults.standard
        
        if self.childrenFirebase == 10 {
            print("childrenFirebase here",self.childrenFirebase)
            let alert = UIAlertController(title: "Day Complete",
                                          message: "Please choose another Day",
                preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok",
                                              style: .default, handler: nil)
            
            alert.addAction(confirmAction)
            
            alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(alert, animated: true)
        }else if defaults.object(forKey: "reservedDateeee") == nil {
            print("childrenFirebase",self.childrenFirebase)
            let alert = UIAlertController(title: "Confirm",
                                          message: "\(finalDate) at \(finalPeriod)",
                preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok",
                                              style: .default, handler: confirmation)
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel, handler: nil)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(alert, animated: true)
        }
        
    }
    func checkchildrenFirebase(){
        
        self.ref.child(finalDate).child(finalPeriod).observe(.value, with: { (dataSnapshot) in
            print(dataSnapshot.childrenCount)
            self.childrenFirebase = dataSnapshot.childrenCount
            if self.finalPeriod == "Night"{
                if self.childrenFirebase < 2 {
                    print("I am 2")
                    self.dateComponents.hour = 20
                    self.dateComponents.minute = 0
                }else if self.childrenFirebase < 4 {
                    print("I am 4")
                    self.dateComponents.hour = 21
                    self.dateComponents.minute = 0
                }else if self.childrenFirebase < 6 {
                    print("I am 6")
                    self.dateComponents.hour = 22
                    self.dateComponents.minute = 0
                }
                else if self.childrenFirebase < 8 {
                    print("I am 8")
                    self.dateComponents.hour = 23
                    self.dateComponents.minute = 0
                }
                else if self.childrenFirebase <= 10 {
                    print("I am 10")
                    self.dateComponents.hour = 24
                    self.dateComponents.minute = 0
                }
            }
            else{
                if self.childrenFirebase < 2 {
                    print("I am 2")
                    self.dateComponents.hour = 13
                    self.dateComponents.minute = 0
                }else if self.childrenFirebase < 4 {
                    print("I am 4")
                    self.dateComponents.hour = 14
                    self.dateComponents.minute = 0
                }else if self.childrenFirebase < 6 {
                    print("I am 6")
                    self.dateComponents.hour = 15
                    self.dateComponents.minute = 0
                }
                else if self.childrenFirebase < 8 {
                    print("I am 8")
                    self.dateComponents.hour = 16
                    self.dateComponents.minute = 0
                }
                else if self.childrenFirebase <= 10 {
                    print("I am 10")
                    self.dateComponents.hour = 17
                    self.dateComponents.minute = 0
                }
            }
            
            self.alert()
        })
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
    func CancellingConfirmation(alert: UIAlertAction!){
        let day=UserDefaults.standard.string(forKey: "reservedDateeee")
        let period=UserDefaults.standard.string(forKey: "reservedTimeee")
        if (day != nil && period != nil){
            print("here is the day ",day)
            print(period)
            removingRef.child(day!).child(period!).queryOrdered(byChild: "UId").queryEqual(toValue : "81HEXixy4fRVSEQXgpI3LU7UalE3").observe(.value, with:{ (snapshot: DataSnapshot) in
                for snap in snapshot.children{
                    print((snap as! DataSnapshot).key)
                    
                    
                    
                    self.removingRef.child(day!).child(period!).child((snap as! DataSnapshot).key).child("UId").removeValue(completionBlock: { (error, refer) in
                        if error != nil {
                            print(error)
                        } else {
                            //print(refer)
                            print("Child Removed Correctly")
                        }
                    })
                    
                    
                }
            })
        }
        let defaults = UserDefaults.standard
        
        defaults.set(nil, forKey:"reservedDateeee")
        
        chosenAppointment_Lbl.text  = "Choose your Apointment"
        
        firstDayDay_Btn_Otlt.isEnabled = true
        firstDayDay_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        
        
        firstDayNight_Btn_Otlt.isEnabled = true
        firstDayNight_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        
        secondDayDay_Btn_Otlt.isEnabled = true
        secondDayDay_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        secondDayNight_Btn_Otlt.isEnabled = true
        secondDayNight_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        thirdDayDay_Btn_Otlt.isEnabled = true
        thirdDayDay_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        thirdDayNight_Btn_Otlt.isEnabled = true
        thirdDayNight_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        fourthDayDay_Btn_Otlt.isEnabled = true
        fourthDayDay_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        fourthDayNight_Btn_Otlt.isEnabled = true
        fourthDayNight_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        fifthDayDay_Btn_Otlt.isEnabled = true
        fifthDayDay_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        fifthDayNight_Btn_Otlt.isEnabled = true
        fifthDayNight_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        sixthDayDay_Btn_Otlt.isEnabled = true
        sixthDayDay_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        sixthDayNight_Btn_Otlt.isEnabled = true
        sixthDayNight_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        seventhDayDay_Btn_Otlt.isEnabled = true
        seventhDayDay_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
        seventhDayNight_Btn_Otlt.isEnabled = true
        seventhDayNight_Btn_Otlt.backgroundColor = UIColor(red: 0/255, green: 33/255, blue: 66/255, alpha: 1)
    }
    @IBAction func cancelReservation_Btn(_ sender: UIButton) {
        
        //print("date",finalDate)
        //handle cancelation
        
        let alert = UIAlertController(title: "Cancel Appointment",
                                      message: "\(finalDate) at \(finalPeriod)",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok",
                                          style: .default, handler: CancellingConfirmation)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alert, animated: true)
        
        
        
        
    }
    @IBOutlet weak var cancelReservation_Btn: UIButton!
    @IBOutlet weak var chosenAppointment_Lbl: UILabel!
    @IBOutlet weak var firstDayDay_Btn_Otlt: UIButton!
    
    @IBOutlet weak var firstDayNight_Btn_Otlt: UIButton!
    
    @IBOutlet weak var secondDayDay_Btn_Otlt: UIButton!
    
    @IBOutlet weak var secondDayNight_Btn_Otlt: UIButton!
    
    @IBOutlet weak var thirdDayDay_Btn_Otlt: UIButton!
    
    @IBOutlet weak var thirdDayNight_Btn_Otlt: UIButton!
    
    @IBOutlet weak var fourthDayDay_Btn_Otlt: UIButton!
    
    @IBOutlet weak var fourthDayNight_Btn_Otlt: UIButton!
    
    @IBOutlet weak var fifthDayDay_Btn_Otlt: UIButton!
    
    @IBOutlet weak var fifthDayNight_Btn_Otlt: UIButton!
    
    @IBOutlet weak var sixthDayDay_Btn_Otlt: UIButton!
    
    @IBOutlet weak var sixthDayNight_Btn_Otlt: UIButton!
    
    @IBOutlet weak var seventhDayDay_Btn_Otlt: UIButton!
    
    @IBOutlet weak var seventhDayNight_Btn_Otlt: UIButton!
    
    
  
    
    @IBOutlet weak var firstDay: UILabel!
    @IBOutlet weak var secondDay: UILabel!
    @IBOutlet weak var thirdDayLbl: UILabel!
    @IBOutlet weak var fourthDayLbl: UILabel!
    @IBOutlet weak var fifthDayLbl: UILabel!
    @IBOutlet weak var sixthDayLbl: UILabel!
    @IBOutlet weak var SeventhDayLbl: UILabel!
    
    @IBAction func secondDayDay(_ sender: UIButton) {
        
        finalDate = secondDay.text!
        finalPeriod = "Day"
        print(finalDate)
        
        let secondNDayDate = Calendar.current.date(byAdding: .day, value: 1, to: notificationDayDate)
        let secondNDayResult = nformatter.string(from: secondNDayDate!)
        
        
        let todayDate = nformatter.date(from: secondNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        checkchildrenFirebase()
        
    }
    @IBAction func secondDayNight(_ sender: UIButton) {
        
        
        finalDate = secondDay.text!
        finalPeriod = "Night"
        
        let secondNDayDate = Calendar.current.date(byAdding: .day, value: 1, to: notificationDayDate)
        let secondNDayResult = nformatter.string(from: secondNDayDate!)
        
        
        let todayDate = nformatter.date(from: secondNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
        checkchildrenFirebase()
        
    }
    @IBAction func thirdDayDay(_ sender: UIButton) {
        
        finalDate = thirdDayLbl.text!
        finalPeriod = "Day"
        
        let thirdNDayDate = Calendar.current.date(byAdding: .day, value: 2, to: notificationDayDate)
        let thirdNDayResult = nformatter.string(from: thirdNDayDate!)
        
        
        let todayDate = nformatter.date(from: thirdNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
        checkchildrenFirebase()
        
    }
    @IBAction func thirdDayNight(_ sender: UIButton) {
        
        finalDate = thirdDayLbl.text!
        finalPeriod = "Night"
        
        
        let thirdNDayDate = Calendar.current.date(byAdding: .day, value: 2, to: notificationDayDate)
        let thirdNDayResult = nformatter.string(from: thirdNDayDate!)
        
        
        let todayDate = nformatter.date(from: thirdNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
       checkchildrenFirebase()
       
    }
    @IBAction func fourthDayDay(_ sender: UIButton) {
        
        finalDate = thirdDayLbl.text!
        finalPeriod = "Day"
        
        let fourthNDayDate = Calendar.current.date(byAdding: .day, value: 3, to: notificationDayDate)
        let fourthNDayResult = nformatter.string(from: fourthNDayDate!)
        
        
        let todayDate = nformatter.date(from: fourthNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
        checkchildrenFirebase()
        
    }
    @IBAction func fourthDayNight(_ sender: UIButton) {
        
        finalDate = fourthDayLbl.text!
        finalPeriod = "Night"
        
        
        let fourthNDayDate = Calendar.current.date(byAdding: .day, value: 3, to: notificationDayDate)
        let fourthNDayResult = nformatter.string(from: fourthNDayDate!)
        
        let todayDate = nformatter.date(from: fourthNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
        
       checkchildrenFirebase()
        
    }
    //@IBOutlet weak var fifthDayDay: UIButton!
    @IBAction func fifthDayDay(_ sender: UIButton) {
       
        finalDate = fifthDayLbl.text!
        finalPeriod = "Day"
        
        let fifthNDayDate = Calendar.current.date(byAdding: .day, value: 4, to: notificationDayDate)
        let fifthNDayResult = nformatter.string(from: fifthNDayDate!)
        
        
        let todayDate = nformatter.date(from: fifthNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
       checkchildrenFirebase()
        
    }
    @IBAction func fifthDayNight(_ sender: UIButton) {
        
        finalDate = fifthDayLbl.text!
        finalPeriod = "Night"
        
        let fifthNDayDate = Calendar.current.date(byAdding: .day, value: 4, to: notificationDayDate)
        let fifthNDayResult = nformatter.string(from: fifthNDayDate!)
        
        
        let todayDate = nformatter.date(from: fifthNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        checkchildrenFirebase()
        
    }
    @IBAction func seventhDayNight(_ sender: UIButton) {
        
        finalDate = SeventhDayLbl.text!
        finalPeriod = "Night"
        
        let seventhNDayDate = Calendar.current.date(byAdding: .day, value: 6, to: notificationDayDate)
        let seventhNDayResult = nformatter.string(from: seventhNDayDate!)
        
        
        let todayDate = nformatter.date(from: seventhNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
        
        checkchildrenFirebase()
       
    }
    @IBAction func seventhDayDay(_ sender: UIButton) {
        
        finalDate = SeventhDayLbl.text!
        finalPeriod = "Day"
        
        let seventhNDayDate = Calendar.current.date(byAdding: .day, value: 6, to: notificationDayDate)
        let seventhNDayResult = nformatter.string(from: seventhNDayDate!)
        
        
        let todayDate = nformatter.date(from: seventhNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
        checkchildrenFirebase()
       
    }
    @IBAction func sixthDayNight(_ sender: UIButton) {
       
        finalDate = sixthDayLbl.text!
        finalPeriod = "Night"
        
        let sixthNDayDate = Calendar.current.date(byAdding: .day, value: 5, to: notificationDayDate)
        let sixthNDayResult = nformatter.string(from: sixthNDayDate!)
        
        
        let todayDate = nformatter.date(from: sixthNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
        checkchildrenFirebase()
        
    }
    @IBAction func sixthDayDay(_ sender: UIButton) {
        
        finalDate = sixthDayLbl.text!
        finalPeriod = "Day"
        
        let sixthNDayDate = Calendar.current.date(byAdding: .day, value: 5, to: notificationDayDate)
        let sixthNDayResult = nformatter.string(from: sixthNDayDate!)
        
        let todayDate = nformatter.date(from: sixthNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 18
        dateComponents.minute = 25
        
        
       checkchildrenFirebase()
        
    }
    @IBAction func firstDayNight(_ sender: UIButton) {
        
        finalDate = firstDay.text!
        finalPeriod = "Night"
        
         let firstNDayResult = nformatter.string(from: notificationDayDate)
        
        let todayDate = nformatter.date(from: firstNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        print(today!,"here it is")
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        checkchildrenFirebase()
        dateComponents.month = month!
        dateComponents.day = today!
        
        dateComponents.hour = 19
        dateComponents.minute = 8
        
       
       
    }
    
    func confirmation(alert: UIAlertAction!){
        
        self.values = ["UId":finalUID]
        //ref = ref.child(finalDate).child(finalPeriod)
       
        if self.childrenFirebase < 10 {
            self.nextInLine = childrenFirebase+1
            self.ref.child(finalDate).child(finalPeriod).child("\(nextInLine)").updateChildValues(self.values, withCompletionBlock: { (error, snapshot) in
                if error != nil {
                    print("oops, an error")
                } else {
                    print("completed")
                    self.confirmedAlert()
                    let content = UNMutableNotificationContent()
                    content.title = "Dr.Michael Maged"
                    content.subtitle = "Appointment Reminder"
                    content.body = "Your Appointment is starting soon,please arrive at the doctor's clinic soon"
                    content.badge = 1
                    
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: self.dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    
                    
                }
            })
            
            let defaults = UserDefaults.standard
            if defaults.object(forKey: "reservedDateeee") == nil {
                print("first time using app")
                
                defaults.set(finalDate, forKey:"reservedDateeee")
                
                
                if finalPeriod == "Day"{
                    
                    defaults.set("Day", forKey:"reservedTimeee")
                    //defaults.set("Day", forKey:"reservedPeriod")
                }else{
                    defaults.set("Night", forKey:"reservedTimeee")
                   // defaults.set("night", forKey:"reservedPeriod")
                }
                
                
                defaults.synchronize()
                
                
            }
            
            
            firstDayDay_Btn_Otlt.isEnabled = false
            firstDayDay_Btn_Otlt.backgroundColor = .lightGray
            
            firstDayNight_Btn_Otlt.isEnabled = false
            firstDayNight_Btn_Otlt.backgroundColor = .lightGray
            
            secondDayDay_Btn_Otlt.isEnabled = false
            secondDayDay_Btn_Otlt.backgroundColor = .lightGray
            
            secondDayNight_Btn_Otlt.isEnabled = false
            secondDayNight_Btn_Otlt.backgroundColor = .lightGray
            
            thirdDayDay_Btn_Otlt.isEnabled = false
            thirdDayDay_Btn_Otlt.backgroundColor = .lightGray
            
            thirdDayNight_Btn_Otlt.isEnabled = false
            thirdDayNight_Btn_Otlt.backgroundColor = .lightGray
            
            fourthDayDay_Btn_Otlt.isEnabled = false
            fourthDayDay_Btn_Otlt.backgroundColor = .lightGray
            
            fourthDayNight_Btn_Otlt.isEnabled = false
            fourthDayNight_Btn_Otlt.backgroundColor = .lightGray
            
            fifthDayDay_Btn_Otlt.isEnabled = false
            fifthDayDay_Btn_Otlt.backgroundColor = .lightGray
            
            fifthDayNight_Btn_Otlt.isEnabled = false
            fifthDayNight_Btn_Otlt.backgroundColor = .lightGray
            
            sixthDayDay_Btn_Otlt.isEnabled = false
            sixthDayDay_Btn_Otlt.backgroundColor = .lightGray
            
            sixthDayNight_Btn_Otlt.isEnabled = false
            sixthDayNight_Btn_Otlt.backgroundColor = .lightGray
            
            seventhDayDay_Btn_Otlt.isEnabled = false
            seventhDayDay_Btn_Otlt.backgroundColor = .lightGray
            
            seventhDayNight_Btn_Otlt.isEnabled = false
            seventhDayNight_Btn_Otlt.backgroundColor = .lightGray
            
            
            chosenAppointment_Lbl.text = "you are scheduled for " + finalDate + " at " + finalPeriod
            
        }
            
        else{
            print("not enough today")
        }
        
    }
    @IBAction func firstDayDay(_ sender: UIButton) {
        
       
        finalDate = firstDay.text!
        finalPeriod = "Day"
        
        
        let firstNDayResult = nformatter.string(from: notificationDayDate)
        
        
       
        
        
        
        
        
        let todayDate = nformatter.date(from: firstNDayResult)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let today = myComponents.day
        let monthComponent = myCalendar.components(.month, from: todayDate)
        let month = monthComponent.month
        
        
        dateComponents.month = month!
        dateComponents.day = today!
        
        
        
        dateComponents.hour = 12
        dateComponents.minute = 5
        
        
        checkchildrenFirebase()
        
        
        
       
    }
    
    override func viewDidLoad() {
       nformatter.dateFormat = "yyyy-MM-dd"
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,error in })
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
       
        var firstDayDate = Date()
      
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        
        var firstDayResult = formatter.string(from: firstDayDate)
        
        finalUID = (user?.uid)!
        //changing the date from the database into nsdate to be able to read date from server not user's phone
       var dateRef = Database.database().reference()
        dateRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let date = value?["date"] as? String ?? firstDayResult
           print("here is tasdahe date",date)
            firstDayResult = date
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        let isoDate = "Thursday, Aug 16, 2018"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:isoDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDateServer = calendar.date(from:components)
        
        
        print("here is the date",finalDateServer)
       
        
        firstDayDate = Calendar.current.date(byAdding: .day, value: 0, to: finalDateServer!)!
        let secondDayDate = Calendar.current.date(byAdding: .day, value: 1, to: finalDateServer!)
        let thirdDayDate = Calendar.current.date(byAdding: .day, value: 2, to: finalDateServer!)
        let fourthDayDate = Calendar.current.date(byAdding: .day, value: 3, to: finalDateServer!)
        let fifthDayDate = Calendar.current.date(byAdding: .day, value: 4, to: finalDateServer!)
        let sixthDayDate = Calendar.current.date(byAdding: .day, value: 5, to: finalDateServer!)
        let seventhDayDate = Calendar.current.date(byAdding: .day, value: 6, to: finalDateServer!)
        
        // let timeStamp = Date().ticks
        firstDayResult = formatter.string(from: firstDayDate)
        let secondDayResult = formatter.string(from: secondDayDate!)
        let thirdDayResult = formatter.string(from: thirdDayDate!)
        let fourthDayResult = formatter.string(from: fourthDayDate!)
        let fifthDayResult = formatter.string(from: fifthDayDate!)
        let sixthDayResult = formatter.string(from: sixthDayDate!)
        let seventhDayResult = formatter.string(from: seventhDayDate!)
        
        
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "reservedDateeee") != nil {
            //print("first time using app")
            
            
            if firstDayResult != UserDefaults.standard.string(forKey: "reservedDateeee") &&
                secondDayResult != UserDefaults.standard.string(forKey: "reservedDateeee") &&
                thirdDayResult != UserDefaults.standard.string(forKey: "reservedDateeee") &&
                fourthDayResult != UserDefaults.standard.string(forKey: "reservedDateeee") &&
                fifthDayResult != UserDefaults.standard.string(forKey: "reservedDateeee") &&
                sixthDayResult != UserDefaults.standard.string(forKey: "reservedDateeee") &&
                seventhDayResult != UserDefaults.standard.string(forKey: "reservedDateeee")
                {
                print(firstDayResult)
                print(UserDefaults.standard.string(forKey: "reservedDateeee")!)
                 chosenAppointment_Lbl.text  = "Choose your Apointment"
                
                defaults.set(nil, forKey:"reservedDateeee")
                defaults.set(nil, forKey:"reservedTimeee")
                firstDayDay_Btn_Otlt.isEnabled = true
                
                firstDayNight_Btn_Otlt.isEnabled = true
                
                secondDayDay_Btn_Otlt.isEnabled = true
                
                secondDayNight_Btn_Otlt.isEnabled = true
                
                thirdDayDay_Btn_Otlt.isEnabled = true
                
                thirdDayNight_Btn_Otlt.isEnabled = true
                
                fourthDayDay_Btn_Otlt.isEnabled = true
                
                fourthDayNight_Btn_Otlt.isEnabled = true
                
                fifthDayDay_Btn_Otlt.isEnabled = true
                
                fifthDayNight_Btn_Otlt.isEnabled = true
                
                sixthDayDay_Btn_Otlt.isEnabled = true
                
                sixthDayNight_Btn_Otlt.isEnabled = true
                
                seventhDayDay_Btn_Otlt.isEnabled = true
                
                seventhDayNight_Btn_Otlt.isEnabled = true
                
                
            }
            else{
               // print(UserDefaults.standard.string(forKey: "reservedDateeee")!)
                if UserDefaults.standard.string(forKey: "reservedTimeee") != nil && UserDefaults.standard.string(forKey: "reservedDateeee") != nil{
                    finalPeriod = UserDefaults.standard.string(forKey: "reservedTimeee")!
                    finalDate = UserDefaults.standard.string(forKey: "reservedDateeee")!
                    
                     chosenAppointment_Lbl.text  = "your reservation is " + UserDefaults.standard.string(forKey: "reservedDateeee")! + " at " + UserDefaults.standard.string(forKey: "reservedTimeee")!
                }
                
                
                
                
                

                firstDayDay_Btn_Otlt.isEnabled = false

                firstDayNight_Btn_Otlt.isEnabled = false

                secondDayDay_Btn_Otlt.isEnabled = false

                secondDayNight_Btn_Otlt.isEnabled = false

                thirdDayDay_Btn_Otlt.isEnabled = false

                thirdDayNight_Btn_Otlt.isEnabled = false

                fourthDayDay_Btn_Otlt.isEnabled = false

                fourthDayNight_Btn_Otlt.isEnabled = false

                fifthDayDay_Btn_Otlt.isEnabled = false

                fifthDayNight_Btn_Otlt.isEnabled = false

                sixthDayDay_Btn_Otlt.isEnabled = false

                sixthDayNight_Btn_Otlt.isEnabled = false

                seventhDayDay_Btn_Otlt.isEnabled = false

                seventhDayNight_Btn_Otlt.isEnabled = false
            }
            //defaults.set(finalDate+" at "+finalPeriod, forKey:"reserved")
            //defaults.synchronize()
            
            
        }
        
        
        firstDay.text = firstDayResult
        secondDay.text = secondDayResult
        thirdDayLbl.text = thirdDayResult
        fourthDayLbl.text = fourthDayResult
        fifthDayLbl.text = fifthDayResult
        sixthDayLbl.text = sixthDayResult
        SeventhDayLbl.text = seventhDayResult
        
    }
}
