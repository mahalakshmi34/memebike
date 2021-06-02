//
//  DropDownTableViewCell.swift
//  MeMeBike
//
//  Created by Rey on 31/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

   
    @IBOutlet weak var dropDownLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
