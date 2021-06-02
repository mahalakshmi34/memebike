//
//  ViewController.swift
//  MeMeBike
//
//  Created by IGNASI REBISTAN on 4/28/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MRCountryPicker

class ViewController: UIViewController,UITextFieldDelegate,MRCountryPickerDelegate {
  
    
    @IBOutlet weak var requestOtpBtn: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var mobilenumberTxt: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var notmemberLabel: UILabel!
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryPicker: MRCountryPicker!
    @IBOutlet weak var stackViewButton: UIButton!
    @IBOutlet weak var doneToolBar: UIToolbar!
    
    
    var isExpand : Bool = false
    var alertMessage = ""
    var codeData :Int = 0
    var hashData :String = ""
    var mobileData:String = ""
    var messageData :String = ""
    var delegate:MemeBikeDelegate?
    var countryData : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedCorners()
        dropShadow()
        signupUnderline()
        viewSubviews()
        tapGesture()
        textGesture()
        textTapped()
    }
    
    func viewSubviews() {
        mobilenumberTxt.delegate = self
        self.view.endEditing(true)
        view.addSubview(loginScrollView)
        loginScrollView.addSubview(subView)
        subView.addSubview(loginImageView)
        subView.addSubview(loginView)
        loginScrollView.isScrollEnabled = true
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        countryPicker.setCountry("")
        countryPicker.setLocale("")
        //navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
        countryFlag.layer.cornerRadius = 30 / 2
        countryFlag.clipsToBounds = true
        countryFlag.contentMode = .scaleAspectFill
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    func textTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapped(_:)))
        countryText.addGestureRecognizer(tap)
    }
    
    func textGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapped(_:)))
        stackViewButton.addGestureRecognizer(tap)
    }
    
    @objc func handleTapped(_ sender: UITapGestureRecognizer? = nil) {
        countryPicker.isHidden = false
        doneToolBar.isHidden = false
        requestOtpBtn.isHidden = true
        
    }
    
    func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        loginScrollView.addGestureRecognizer(tap)
       
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        keyboardDisappear()
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem){
        countryPicker.isHidden = true
        doneToolBar.isHidden = true
        requestOtpBtn.isHidden = false
        
    }
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryText.text = phoneCode
        countryFlag.isHidden = false
         countryFlag.image = flag
        
        requestOtpBtn.isHidden = true
    }
    
    func buttonFrame() {
        notmemberLabel.frame.size.width = 242
        var button = signupBtn
        button?.frame.origin.x = notmemberLabel.frame.size.width + 34
        countryText.frame.size.height = 45
        mobilenumberTxt.frame.size.height = 45
    }
    
    func dropShadow () {
//        mobilenumberTxt.addShadowToTextField(cornerRadius: 3)
//        mobilenumberTxt.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
        
        stackViewButton.addShadowToButton(cornerRadius: 10)
        stackViewButton.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
    }
    
    func getLoginAuthendication() {
        let url = "https://api.memebike.tv:2002/api/auth/login"
        AF.request("https://api.memebike.tv:2002/api/auth/login" ,method: .post)
        let parameter : Parameters = [
            "countryCode" : countryText.text,
            "mobile" : mobilenumberTxt.text,
        ]
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { [self] response in
                print("isiLagi: \(response)")
                switch response.result {
                case .success(let data):
                    print("isi: \(data)")
                    let json = JSON(data)
                    if let message = json["message"].string {
                        if (message == "Account not found!")  {
                            showAlert(alertText: "Alert", alertMessage: message)
                        }
                    }
                    if let mobile = json["mobile"].string {
                        mobileData = mobile
                    }
                    if let code = json["code"].int
                    {
                        codeData = code
                    }
                    if let hash = json["hash"].string {
                        hashData = hash
                        countryData = countryText.text!
                    }
                    if let message = json["message"].string {
                        messageData = message
                        if (messageData == "Verification code sent!") {
                            let Menu = storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
                            Menu?.mobileNumberOTP = mobileData
                            Menu?.codeOTP = String(codeData)
                            Menu?.hashOTP = hashData
                            Menu?.countrycodeOTP = countryData
                            delegate?.onMemeBike(type: hashData)
                            navigationController?.pushViewController(Menu!, animated: true)
                            showAlert(alertText: "Alert", alertMessage:String(codeData))
                        }
                        else {
                            showAlert(alertText: "Alert", alertMessage: messageData)
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    func keyboardDisappear() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func addObserver () {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification)
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
            let keyboardSize = keyboardInfo.cgRectValue.size
     //   let contentInsets = UIEdgeInsets(top: 0, left: 0,bottom: keyboardSize.height, right: 0)
        //let screenSize: CGRect = UIScreen.main.bounds
      //  let subviewHeight =  screenSize.height
     //   subView.frame.origin.y -= keyboardSize.height
      //  print("subView height",subView.frame.origin.y )
    // self.loginScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: screenSize.height  + keyboardSize.height )
      //  let contentInset = UIEdgeInsets(top: 0, left:0, bottom:mobilenumberTxt.frame.origin.y - keyboardSize.height , right: 0)
        
        let globalPoint = mobilenumberTxt.superview?.convert(mobilenumberTxt.frame.origin, to: nil)
        print(globalPoint)
        if (UIScreen.main.bounds.height - keyboardSize.height ) < (globalPoint?.y ?? 0) + mobilenumberTxt.frame.height{
            let contentInset = UIEdgeInsets(top:  keyboardSize.height - (globalPoint?.y ?? 0) + mobilenumberTxt.frame.height + 20, left:0, bottom: 0, right: 0)
        print(contentInset)
        loginScrollView.contentInset = contentInset
        loginScrollView.scrollIndicatorInsets = contentInset
        }
        
        
      //  self.loginScrollView.contentSize = CGSize(width: screenSize.width, height: screenSize.height + keyboardSize.height)
    // print("scrollview",loginScrollView.frame.size.height , keyboardSize.height)
     //   let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        //loginScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        loginScrollView.contentInset = .zero
        loginScrollView.scrollIndicatorInsets = .zero
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func signupUnderline() {
        var attributedString = NSMutableAttributedString(string:"Sign Up")
        var attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19.0),
            NSAttributedString.Key.foregroundColor : UIColor.blue
        ]
        var gString = NSMutableAttributedString(string:"g", attributes:attrs)
        attributedString.append(gString)
        signupBtn.titleLabel?.attributedText = attributedString;
    }
    
    func roundedCorners() {
        requestOtpBtn.layer.cornerRadius = 20
        mobilenumberTxt.layer.cornerRadius = mobilenumberTxt.frame.size.height / 2
    }
    
    func validation()  {
        if mobilenumberTxt.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Enter mobile number")
        }
        
        else if (mobilenumberTxt.text!.count > 10) {
            showAlert(alertText: "Alert", alertMessage: "Invalid phone number")
        }
        
        else if (mobilenumberTxt.text!.count < 10) {
            showAlert(alertText: "Alert", alertMessage: "Invalid phone number")
            
        }
    }
 
    @IBAction func requestAction(_ sender: UIButton) {
        validation()
        getLoginAuthendication()
        keyboardDisappear()
       self.view.endEditing(true)
    }
    
    @IBAction func signBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "signup", sender: self)
    }
}
  



