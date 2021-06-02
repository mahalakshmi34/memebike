//
//  RidehistoryViewController.swift
//  MeMeBike
//
//  Created by Rey on 21/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit

class RidehistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var rideHistoryCollection: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rideHistoryCollection.delegate = self
        rideHistoryCollection.dataSource = self
        
        rideHistoryCollection.layoutIfNeeded()
        
        let originalImage = UIImage(named: "218_Arrow_Arrows_Back-512")
        backButton.setImage(originalImage, for: .normal)
        backButton.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ridehistory", for: indexPath)as! RidehistoryCollectionViewCell
        
         cell.memeLogo.layer.cornerRadius = 50
//
        cell.memeLogo.layer.borderWidth = 4.0
        
        cell.memeLogo.layer.borderColor = UIColor(rgb: 0x00A7FC).cgColor
        
         cell.completedBtn.layer.cornerRadius = 20
        
        cell.layer.cornerRadius = 10
        
           cell.contentView.layer.cornerRadius = 2.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true

           
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rideHistoryCollection.frame.size.width, height:112)
       }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        let menu = self.storyboard?.instantiateViewController(identifier: "RidehistoryViewController") as! RidehistoryViewController
        navigationController?.popViewController(animated: true)
        
    }
    
    func addShadow() {
       
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
