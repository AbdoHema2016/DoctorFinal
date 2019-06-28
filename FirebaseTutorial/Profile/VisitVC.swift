//
//  VisitVC.swift
//  Dr. Abdelrhman Arwish Clinic
//
//  Created by Abdelrhman on 6/14/19.
//  Copyright © 2019 Dr. Abdelrhman Arwish Clinic. All rights reserved.
//

import UIKit
class VisitVC:UIViewController{
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var visitNum: UILabel!
    
    @IBAction func back_Btn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
        let viewController = storyboard.instantiateViewController(withIdentifier: "TBC") as! UITabBarController
        viewController.selectedIndex = 2
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        self.dismiss(animated: true, completion: nil)
        
       
    }
    @IBOutlet weak var visitDate: UILabel!
    
    
    @IBOutlet weak var diagnosis_TXTView: UITextView!
    
    @IBOutlet weak var treatmentPlan_TXTView: UITextView!
    
    @IBOutlet weak var done_TXTView: UITextView!
    
   
    override func viewWillAppear(_ animated: Bool) {
        visitNum.text = visitNumTxt
        visitDate.text = visitDateTxt
        diagnosis_TXTView.text = visitDiagnosis
        treatmentPlan_TXTView.text = visitTreatment
        done_TXTView.text = visitDone
        
    }
    
    
}
