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
    
    
    @IBOutlet weak var BATV: UITableView!
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
            
            
            
            
            
        }
        return cell
    }
    override func viewDidLoad() {
        
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
        BAList.removeAll()
        ref.observe(.childAdded, with: { (snapshot) in
            //if let items = snapshot.value as? [String:Any]{
            
            
            self.BAList.append(snapshot)
            
            
            
            
            
            //}
            self.BATV.reloadData()
        })
    }
    

}
