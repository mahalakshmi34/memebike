//
//  DepositViewController.swift
//  MeMeBike
//
//  Created by Rey on 20/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit

class DepositViewController: UIViewController {
   
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var depositBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCornerRadius()
    }
    
    func viewCornerRadius() {
        depositView.layer.cornerRadius = 10
        depositBtn.layer.cornerRadius = 10
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let originalImage = UIImage(named: "218_Arrow_Arrows_Back-512")
        backBtn.setImage(originalImage, for: .normal)
        backBtn.tintColor = UIColor.white
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        let menu = self.storyboard?.instantiateViewController(identifier: "DepositViewController") as! DepositViewController
        navigationController?.popViewController(animated: true)
    }

}


