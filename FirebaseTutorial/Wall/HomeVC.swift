//
//  HomeVC.swift
//  Doc
//
//  Created by Abdelrhman on 10/31/17.
//  Copyright © 2017 bigNerdeo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage
import UserNotifications
var finalPostId = ""
var finalPostImage = ""
var finalText = ""
var finalTitle = ""
class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var internetConnection: UILabel!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var upperViewHeightConstraint: NSLayoutConstraint!
    @IBAction func logout(_ sender: UIButton) {
        
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
    
    @IBOutlet weak var Appointment_Btn: UIButton!
    @IBOutlet weak var filter_Btn: UIBarButtonItem!
    @IBOutlet weak var notification_Btn: UIButton!
    var filterChoice = Int()
    var search_Btn = UIButton()
    @IBAction func search_Btn(_ sender: UIButton) {
       // performSegue(withIdentifier: "searchSegue", sender: self)
    }
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
    
    @IBOutlet weak var wallTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredWall = [DataSnapshot]()
    var isSearching = false
    var data = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    var wallList = [DataSnapshot]()
    var ref = Database.database().reference().child("Articles")
    var postsArray = [NSDictionary]()
    var filteredPosts = [NSDictionary]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredWall.count
        }
        return wallList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WallCell", for: indexPath) as! WallCell
        
        let model = wallList[indexPath.row]
        if let value = model.value as? [String:Any]{
            
            
            
            
            if let text = value["postTitle"] as? String{
                cell.postTitle.text = text
                
            }
            
            if let postPicture = value["image"] as? String{
                
                let imageUrl:NSURL? = NSURL(string: postPicture)
                if let url = imageUrl {
                    cell.postPic.sd_setImage(with: url as URL)
                    
                    
                }
                
                
            }
            
            
            
            
            
        }

       
        return cell
    }

    var databaseRef = Database.database().reference()
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = wallList[indexPath.row]
        //print(wallList[postIndex])
        if let value = model.value as? [String:Any]{
            finalPostId = model.key
            
            if let profilePic = value["image"] as? String{
                finalPostImage = profilePic
                
                
            }
            if let text = value["text"] as? String {
                
                finalText = text
            }
            if let title = value["postTitle"] as? String {
                
                finalTitle = title
            }
        }
        search_Btn.isHidden = true
         performSegue(withIdentifier: "postIDetailsVC", sender: self)
    }
  
    func searchButtonAction() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "searchingItems") as! UITableViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    func saturdayNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow,error in
            
            
        })
        let now = Date()
        let gregorian = Calendar(identifier: .gregorian)
        
        var components = gregorian.dateComponents([.weekday,.hour, .minute, .second], from: now)
        components.weekday = 1
        components.hour = 14
        components.minute = 30
        components.second = 0
        let date = gregorian.date(from: components)!
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "teeth"
        notificationContent.subtitle = "this is a new noti"
        notificationContent.body = "brush your teeth"
        notificationContent.badge = 1
        let request = UNNotificationRequest(identifier: "saturdayNotification", content: notificationContent, trigger: trigger)
        print("INSIDE NOTIFICATION")
        
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            if let error = error {
                print("SOMETHING WENT WRONG")
            }
        })
        
    }
    func wednesdayNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow,error in
            
            
        })
        let now = Date()
        let gregorian = Calendar(identifier: .gregorian)
        
        var components = gregorian.dateComponents([.weekday,.hour, .minute, .second], from: now)
        components.weekday = 5
        components.hour = 14
        components.minute = 30
        components.second = 0
        let date = gregorian.date(from: components)!
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "hey"
        notificationContent.subtitle = "this is a new noti"
        notificationContent.body = "helooo"
        notificationContent.badge = 1
        let request = UNNotificationRequest(identifier: "wednesdayNotification", content: notificationContent, trigger: trigger)
        print("INSIDE NOTIFICATION")
        
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            if let error = error {
                print("SOMETHING WENT WRONG")
            }
        })
        
    }
    @objc func openReserve(){
       performSegue(withIdentifier: "ReserveSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //filter_Btn.target = self.revealViewController()
        //filter_Btn.action = #selector(SWRevealViewController.revealToggle(_:))
        Appointment_Btn.addTarget(self, action: #selector(openReserve), for: .touchUpInside)
       
        upperView.setShadow()
        saturdayNotification()
        wednesdayNotification()
        
        
        notification_Btn.layer.cornerRadius = 5
        notification_Btn.layer.borderWidth = 1
        notification_Btn.layer.borderColor = UIColor.black.cgColor
        
        
       
        Appointment_Btn.layer.cornerRadius = 5
        Appointment_Btn.layer.borderWidth = 1
        Appointment_Btn.layer.borderColor = UIColor.black.cgColor
        
        
        
        search_Btn = UIButton(frame:CGRect(origin:CGPoint(x:self.view.frame.width / 1.2,y:self.view.frame.height-120),size:CGSize(width:50,height:50)))
        search_Btn.layer.cornerRadius = 0.5 * search_Btn.bounds.size.width
        search_Btn.clipsToBounds = true
        search_Btn.setImage(UIImage(named:"searchIcon.png"), for: .normal)
        search_Btn.backgroundColor = UIColor(red: 0, green: 153/255, blue: 244/255, alpha: 1)
        self.navigationController?.view.addSubview(search_Btn)
        search_Btn.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)

        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if (selectedRow == 0 ){
            ref.observe(.childAdded, with: { (snapshot) in
                //if let items = snapshot.value as? [String:Any]{
                
                
                self.wallList.append(snapshot)
                
                
                
                
                
                //}
                self.wallTV.reloadData()
            })
            
        }
        else if(selectedRow == 1 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "a").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 2 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "b").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 3 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "c").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 4 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "d").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 5 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "e").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 6 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "f").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 7 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "g").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 8 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "h").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 9 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "i").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 10 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "j").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 11 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "k").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 12 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "l").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 13 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "m").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 14 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "n").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 15 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "o").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 16 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "p").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 17 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "q").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 18 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "r").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 19 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "s").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 20 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "t").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 21 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "u").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 22 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "v").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 23 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "w").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 24 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "x").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 25 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "y").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 26 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "z").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 27 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "za").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 28 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "zb").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
        else if(selectedRow == 29 ){
            wallList.removeAll()
            self.ref.queryOrdered(byChild: "zc").queryEqual(toValue: "true").observe(.childAdded, with: { (DataSnapshot) in
                
                self.wallList.append(DataSnapshot)
                
                self.wallTV.reloadData()
            })
        }
       
        
        
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                
                self.internetConnection.isHidden = true
                self.upperViewHeightConstraint.constant = 0
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

        
        
        wallList.removeAll()
        
        
    }
}
