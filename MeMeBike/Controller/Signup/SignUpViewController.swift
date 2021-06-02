//
//  SignUpViewController.swift
//  MeMeBike
//
//  Created by IGNASI REBISTAN on 4/29/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var referalTxt: UITextField!
    @IBOutlet weak var signupImage: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var referalView: UIView!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var requestotpBtn: UIButton!
    @IBOutlet weak var signupScrollview: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    
    var isExpand : Bool = false
    var alertMessage = ""
    var mobileNumber:String = ""
    var countrycode :String = ""
    var hashData :String = ""
    var messageAlert :String = ""
    var emailData:String = ""
    var verificationCode :String = ""
    var codeData  :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(signupScrollview)
        signupScrollview.addSubview(subView)
        signupScrollview.delegate = self
        subView.addSubview(signupImage)
        subView.addSubview(mainView)
        roundedCorners()
        dropshadow()
        tapGesture()
        handleTap()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func keyboardDisappear() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        signupScrollview.contentInset = contentInset
        signupScrollview.scrollIndicatorInsets = contentInset
        
        //   signupScrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + keyboardSize.height)
        
        //subView.frame.origin.y -= keyboardFrame.height
        //
        //        var contentInset:UIEdgeInsets = self.signupScrollview.contentInset
        //        contentInset.bottom = keyboardFrame.size.height + 20
        //        signupScrollview.contentInset = contentInset
        
        //    self.signupScrollview.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        signupScrollview.contentInset = .zero
        signupScrollview.scrollIndicatorInsets = .zero
    }
    
    func getRegistration() {
        let url = "https://api.memebike.tv:2002/api/auth/registration"
        AF.request("https://api.memebike.tv:2002/api/auth/registration" ,method: .post)
        let parameter : Parameters = [
            "countryCode" : countryTxt.text,
            "mobile" : phoneTxt.text,
            "email" : "",
            "referBy" : ""
        ]
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
            print("isi: \(data)")
            let json = JSON(data)
            print(json)
            if let mobile = json["mobile"].string {
            print(mobile)
            mobileNumber = mobile
            }
            if let countryCode = json["countryCode"].string {
            countrycode = countryCode
            }
            if let hash = json["hash"].string {
            hashData = hash
            }
            if let message = json["message"].string
            {
              messageAlert = message
            }
            if let email = json["email"].string {
                 emailData = email
            }
            if let code = json["code"].int
            {
            codeData = String(code)
            }
                
            if messageAlert == "Verification code sent!" {
            let Menu = storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
                Menu!.mobileNumberOTP = mobileNumber
                Menu!.countrycodeOTP = countrycode
                Menu!.hashOTP = hashData
                Menu!.codeOTP = codeData
                Menu!.emailOTP = emailData
                Menu?.messageData = messageAlert
            navigationController?.pushViewController(Menu!, animated: true)
                showAlert(alertText: "Alert", alertMessage: String(codeData))
            }
                
            else {
                showAlert(alertText: "Alert", alertMessage: messageAlert)
            }
            case .failure(let error):
                print("Request failed with error: \(error)")
                }
            }
    }
 
    func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        signupScrollview.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        keyboardDisappear()
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func dropshadow() {
        phoneTxt.addShadowToTextField(cornerRadius: 3)
        phoneTxt.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
        countryTxt.addShadowToTextField(cornerRadius: 3)
        countryTxt.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
        emailTxt.addShadowToTextField(cornerRadius: 3)
        emailTxt.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
        referalTxt.addShadowToTextField(cornerRadius: 3)
        referalTxt.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
    }

    func roundedCorners() {
        requestotpBtn.layer.cornerRadius = 20
        referalView.layer.cornerRadius = 10
        verifyButton.roundedButton()
    }
    
    func getEmailValidationMessage(email: String) {
        var invalidEmailMessage = "";
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (emailTxt.text?.count == 0) {
            getRegistration()
        }
        else if(!emailPred.evaluate(with: email)) {
            showAlert(alertText: "Alert", alertMessage: "Invalid Email Address")
        }
        else if (phoneTxt.text?.count == 0) {
            showAlert(alertText: "Alert", alertMessage: "Please enter phonenumber")
            
        }
        else if (phoneTxt.text!.count < 10) {
            showAlert(alertText:"Alert",alertMessage:"Invalid phone Number")
        }
        else if (phoneTxt.text!.count > 10) {
            showAlert(alertText: "Alert", alertMessage: "Invalid phone Number")
        }
        else
        {
            getRegistration()
        }
    }
    
    func textfieldValidation() {
        if (phoneTxt.text?.count == 0) {
        showAlert(alertText: "Alert", alertMessage: "Enter mobile number")
        }
        if (phoneTxt.text!.count > 10) {
            showAlert(alertText: "Alert", alertMessage: "Invalid phone number")
        }
        if (phoneTxt.text!.count < 10) {
            showAlert(alertText: "Alert", alertMessage: "Invalid phone number")
        }
    }
    
    func apiValidation() {
        if messageAlert.count != 0 {
            showAlert(alertText: "Alert", alertMessage: messageAlert)
        }
    }
    
    @IBAction func requestotpBtn(_ sender: Any) {
        textfieldValidation()
        keyboardDisappear()
        view.endEditing(true)
        let emailValidationMessage =  getEmailValidationMessage(email: emailTxt.text!)
        if (emailTxt.text?.count == 0) {
            getRegistration()
        }
    }
}

extension UITextField {
    func addShadowToTextField(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
    }
}


extension UIButton{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UIViewController {
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController (title: alertText, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
}
