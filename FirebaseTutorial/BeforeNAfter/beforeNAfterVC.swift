//
//  beforeNAfter.swift
//  Doc
//
//  Created by Abdelrhman on 10/31/17.
//  Copyright © 2017 bigNerdeo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class BeforeNAfterVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var BATV: UITableView!
    @IBOutlet weak var internetConnection: UILabel!
    //object for the internet connectivity reachability class
    @IBOutlet weak var upperViewHeightConstraints: NSLayoutConstraint!
    
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
    var BAList = [DataSnapshot]()
    var ref = Database.database().reference().child("BeforeNAfter")
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BAList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BACell", for: indexPath) as! BeforeNAfterCell
        let model = BAList[indexPath.row]
        
        if let value = model.value as? [String:Any]{
            
            if let postPicture = value["PostImage"] as? String{
                
                let imageUrl:NSURL? = NSURL(string: postPicture)
                if let url = imageUrl {
                    cell.beforePic.sd_setImage(with: url as URL)
                    
                    
                }
                
                
            }
            
             if let text = value["beforeNAfterTitle"] as? String{
                cell.beforeNAfterTitle.text = text
            }
            if let text = value["beforeNAfterDetail"] as? String{
                cell.beforeNAfterDetail.text = text
            }
            
            
            
            
            
        }
        return cell
    }
    override func viewDidLoad() {
        
        upperView.setShadow()
        upperView.setBorder(color: UIColor.gray)
        btnNotification.setCornerRadius(isClipped: true, isRounded: false)
        btnCalender.setCornerRadius(isClipped: true, isRounded: false)
        
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                
                self.internetConnection.isHidden = true
                self.upperViewHeightConstraints.constant = 0
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
        BAList.removeAll()
        ref.observe(.childAdded, with: { (snapshot) in
            //if let items = snapshot.value as? [String:Any]{
            
            
            self.BAList.append(snapshot)
            
            
            
            
            
            //}
            self.BATV.reloadData()
        })
    }
    

}
