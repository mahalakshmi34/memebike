//
//  LeftSlideViewController.swift
//  MeMeBike
//
//  Created by Rey on 13/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit


class LeftSlideViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var slideMenu = ["Ride History", "Referral","Identity Proof","Deposit","Wallet","Prices","Notification","Rate us","Terms of use","Logout","Contact us ","FAQ"]
    
    var sliceIcon = ["ride history","referral","magnifier","deposit","wallet","prices","notification","rateus","terms-and-conditions","logout-1","contactus","faq"]

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        navigationController?.navigationBar.isHidden = true
        
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return slideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sidemenu", for: indexPath) as! Sidemenu
        let image = UIImage(named: "\(slideMenu.count)")
        cell.sideLabel.text = slideMenu[indexPath.row]
        cell.sideImage.image = UIImage(named: sliceIcon[indexPath.row])
        cell.sideImage.tintColor = UIColor.gray
        cell.sideImage.image = cell.sideImage.image?.withRenderingMode(.alwaysTemplate)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.tag = slideMenu.count
        print("9999",tableView.tag)
        print("You deselected cell #\(indexPath.row)!")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sidemenu", for: indexPath) as! Sidemenu
        if (indexPath.row == 0) {
            let Identity = self.storyboard?.instantiateViewController(identifier: "RidehistoryViewController") as! RidehistoryViewController
            self.navigationController?.pushViewController(Identity, animated: true)
        }
        
        if (indexPath.row == 2) {
           let Identity = self.storyboard?.instantiateViewController(identifier: "Identity_Proof_ViewController") as! Identity_Proof_ViewController
            self.navigationController?.pushViewController(Identity, animated: true)
        }
        
        if (indexPath.row == 3) {
            let Identity = self.storyboard?.instantiateViewController(identifier: "DepositViewController") as! DepositViewController
            self.navigationController?.pushViewController(Identity, animated: true)
        }
        
        if (indexPath.row == 9) {
            let contactus = self.storyboard?.instantiateViewController(identifier: "ContactUsViewController") as! ContactUsViewController
            self.navigationController?.pushViewController(contactus, animated: true)
        }
    }
}

extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
