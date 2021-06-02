//
//  MetroStationCollectionViewCell.swift
//  MeMeBike
//
//  Created by Rey on 19/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit

class MetroStationCollectionViewCell: UICollectionViewCell {
    
    var currentpage :Int = 0
    
    @IBOutlet weak var joggersLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var nearestMeme: UIButton!
    
}
