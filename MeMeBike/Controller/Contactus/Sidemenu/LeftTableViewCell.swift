//
//  LeftTableViewCell.swift
//  MeMeBike
//
//  Created by Rey on 13/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit

class LeftTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var slideImage: UIImageView!
   
    @IBOutlet weak var slideLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
