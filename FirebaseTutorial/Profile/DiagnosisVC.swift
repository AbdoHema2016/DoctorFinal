//
//  MedicienVC.swift
//  Dr. Abdelrhman Arwish Clinic
//
//  Created by Abdelrhman on 6/14/19.
//  Copyright © 2019 Dr. Abdelrhman Arwish Clinic. All rights reserved.
//

import UIKit

struct cellData{
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}
class DiagnosisVC:UIViewController{
    
    @IBAction func back_Btn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
        let viewController = storyboard.instantiateViewController(withIdentifier: "TBC") as! UITabBarController
        viewController.selectedIndex = 2
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var treatment_Image: UIImageView!
    @IBOutlet weak var diagnosis_Image: UIImageView!
    
    @IBOutlet weak var diagnosis_TxtView: UITextView!
    
    @IBOutlet weak var treatmentPlan_TxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diagnosis_TxtView.text = visitDiagnosis
        treatmentPlan_TxtView.text = visitTreatment
        
        treatment_Image.layer.cornerRadius = 5
        treatment_Image.layer.borderWidth = 1
        treatment_Image.layer.borderColor = UIColor.white.cgColor
        
        
        diagnosis_Image.layer.cornerRadius = 5
        diagnosis_Image.layer.borderWidth = 1
        diagnosis_Image.layer.borderColor = UIColor.white.cgColor
    }
    //expanding cells
    /*
    var tableViewData = [cellData]()
    override func viewDidLoad() {
        tableViewData = [cellData(opened:false,title:"title1",sectionData:["cell1","cell2","cell 3"]),
                         cellData(opened:false,title:"title2",sectionData:["cell1","cell2","cell 3"]),
                         cellData(opened:false,title:"title3",sectionData:["cell1","cell2","cell 3"])]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true{
            return tableViewData[section].sectionData.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell") else {return UITableViewCell()}
            
            cell.textLabel?.text = tableViewData[indexPath.section].title
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell") else {return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            return cell
        }
    }
    
    
     @IBAction func back_Btn(_ sender: UIBarButtonItem) {
     
     let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
     let viewController = storyboard.instantiateViewController(withIdentifier: "TBC") as! UITabBarController
     viewController.selectedIndex = 2
     UIApplication.shared.keyWindow?.rootViewController = viewController
     
     self.dismiss(animated: true, completion: nil)
     
     
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }else{
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }else{
            //do something once u select a cell insid a specific section
        }
    }
    
    */
    
}
