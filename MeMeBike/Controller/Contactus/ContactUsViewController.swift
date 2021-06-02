//
//  ContactUsViewController.swift
//  MeMeBike
//
//  Created by Rey on 23/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController
{
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropShadow()
        applyDropShadow()
        contentView.addSubview(textView)
    }
    
   func dropShadow() {
    mainView.layer.cornerRadius = 40;
    mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    sendButton.layer.cornerRadius = 10
    }
    
    func applyDropShadow() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.2
        contentView.clipsToBounds = false
        contentView.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowRadius = 1
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
