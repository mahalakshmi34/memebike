//
//  Identity Proof ViewController.swift
//  MeMeBike
//
//  Created by Rey on 18/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit

class Identity_Proof_ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var idproofFront: UIButton!
    @IBOutlet weak var idproofBack: UIButton!
    @IBOutlet weak var photoVerification: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropShadow()
    }
    
    
    func dropShadow() {
        idproofFront.addShadowToButton(cornerRadius: 10)
        idproofFront.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
        idproofBack.addShadowToButton(cornerRadius: 10)
        idproofBack.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
        
        photoVerification.addShadowToButton(cornerRadius: 10)
        photoVerification.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
        
        submitBtn.layer.cornerRadius = 20
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let origImage = UIImage(named: "218_Arrow_Arrows_Back-512")
        backButton.setImage(origImage, for: .normal)
        backButton.tintColor = UIColor.white
    }
    
    
    @IBAction func idProofFrontTapped(_ sender: UIButton) {
        actionSheet()
    }
    
    @IBAction func idProofBack(_ sender: UIButton) {
        actionSheet()
    }
    
    @IBAction func photoVerification(_ sender: UIButton) {
        actionSheet()
    }
    
    
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
   
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let menu = self.storyboard?.instantiateViewController(identifier: "HomeViewController")as! HomeViewController
        navigationController?.popViewController(animated: true)
    }
    
    func actionSheet() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (handler) in
            self.openCamera()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
      }
    
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */




extension UIButton {
    
    func addShadowToButton(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
    }

}

