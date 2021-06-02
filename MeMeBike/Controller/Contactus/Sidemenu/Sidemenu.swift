//
//  Sidemenu.swift
//  
//
//  Created by Rey on 21/05/21.
//

import UIKit

class Sidemenu: UITableViewCell {

   
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var sideImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
