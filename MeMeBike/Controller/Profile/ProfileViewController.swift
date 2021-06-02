//
//  ProfileViewController.swift
//  MeMeBike
//
//  Created by Rey on 20/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var viewDocuments: UIButton!
    @IBOutlet weak var nameEdit: UIButton!
    @IBOutlet weak var mobileEditTxt: UIButton!
    @IBOutlet weak var DistanceButton: UIButton!
    @IBOutlet weak var nameStack: UIStackView!
    @IBOutlet weak var mobileStack: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedImage()
        renderImage()
        
        view.addSubview(profileScrollView)
        profileScrollView.addSubview(profileView)
        
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    func renderImage() {
        let origImage = UIImage(named: "edit")
        mobileEditTxt.setImage(origImage, for: .normal)
        mobileEditTxt.tintColor = UIColor(rgb: 0x00A7FC)
        
        nameEdit.setImage(origImage, for: .normal)
        nameEdit.tintColor = UIColor(rgb: 0x00A7FC)
        
        editBtn.setImage(origImage, for: .normal)
        editBtn.tintColor = UIColor(rgb: 0x00A7FC)
        
        DistanceButton.layer.cornerRadius = 23
        let distanceImage = UIImage(named: "STEPS-1")
        DistanceButton.setImage(distanceImage, for: .normal)
        DistanceButton.tintColor = UIColor(rgb: 0x00A7FC)
        
        let originalImage  = UIImage(named: "218_Arrow_Arrows_Back-512")
        backBtn.setImage(originalImage, for: .normal)
        backBtn.tintColor = UIColor.white
        
       
    }
    
    func roundedImage() {
        profileImage.frame.size.width = 200
        profileImage.frame.size.height = 200
        profileImage.center = self.view.center
        profileImage.layer.cornerRadius = 50
        profileImage.layer.borderWidth = 2.0
        
        genderLabel.layer.cornerRadius = 10
        genderLabel.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor(red:1/255, green:170/255, blue:255/255, alpha: 1).cgColor
        viewDocuments.layer.cornerRadius = 10
        //profileImage.layer.borderColor = UIColor.blue.cgColor
        nameStack.addShadowToStackView(cornerRadius: 10)
        nameStack.addShadowToStackView(color: .gray, cornerRadius: 10)
        mobileStack.addShadowToStackView(cornerRadius: 10)
        mobileStack.addShadowToStackView(color: .gray, cornerRadius: 10)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let menu = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        navigationController?.popViewController(animated: true)
    }
}

extension UIButton{
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UIStackView {
    
    func addShadowToStackView(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
    }
}
