//
//  BeforeNAfterCell.swift
//  Doc
//
//  Created by Abdelrhman on 10/31/17.
//  Copyright © 2017 bigNerdeo. All rights reserved.
//

import UIKit
class BeforeNAfterCell: UITableViewCell {
    
    @IBOutlet weak var beforePic: UIImageView!
    
    @IBOutlet weak var beforeNAfterDetail: UILabel!
    @IBOutlet weak var beforeNAfterTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
