//
//  OTPViewController.swift
//  MeMeBike
//
//  Created by Rey on 11/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OTPViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var otpTextFirst: UITextField!
    @IBOutlet weak var otpTextThird: UITextField!
    @IBOutlet weak var otpTextSecond: UITextField!
    @IBOutlet weak var otpTextFourth: UITextField!
    
    
    var mobileNumberOTP : String = ""
    var countrycodeOTP :String = ""
    var hashOTP :String = ""
    var codeOTP :String = ""
    var messageData: String = "" 
    var emailOTP:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedCorners()
        print(mobileNumberOTP)
        print(countrycodeOTP)
        print(codeOTP)
        otpSelector()
    }
    
    func otpSelector() {
        otpTextFirst.delegate = self
        otpTextSecond.delegate = self
        otpTextThird.delegate = self
        otpTextFourth.delegate = self
        
        otpTextFirst.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextSecond.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextThird.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextFourth.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
       let text = textField.text
        let outputFinal = "\(otpTextFirst.text!)\(otpTextSecond.text!)\(otpTextThird.text!)\(otpTextFourth.text!)"
        codeOTP = outputFinal
        if  text?.count == 1 {
        switch textField{
        case otpTextFirst:
              otpTextSecond.becomeFirstResponder()
        case otpTextSecond:
              otpTextThird.becomeFirstResponder()
        case otpTextThird:
              otpTextFourth.becomeFirstResponder()
        case otpTextFourth:
              otpTextFourth.resignFirstResponder()
                default:
                    break
                }
            }
            if  text?.count == 0 {
                switch textField{
                case otpTextFirst:
                    otpTextFirst.becomeFirstResponder()
                case otpTextSecond:
                    otpTextFirst.becomeFirstResponder()
                case otpTextThird:
                    otpTextSecond.becomeFirstResponder()
                case otpTextFourth:
                    otpTextThird.becomeFirstResponder()
                default:
                    break
                }
            }
            else{

            }
        }
    
    func validation() {
        
        if otpTextFirst.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter OTP")
        }
        
        if otpTextSecond.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter OTP")
        }
        
        if otpTextThird.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter OTP")
        }
        
        if otpTextFourth.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter OTP")
        }
    }
   
    func roundedCorners() {
        continueBtn.layer.cornerRadius = continueBtn.frame.size.height / 2
        otpTextFirst.addShadowToTextField(cornerRadius: 3)
        otpTextFirst.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
        otpTextSecond.addShadowToTextField(cornerRadius: 3)
        otpTextSecond.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
        otpTextThird.addShadowToTextField(cornerRadius: 3)
        otpTextThird.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
        otpTextFourth.addShadowToTextField(cornerRadius: 3)
        otpTextFourth.addShadowToTextField(color: UIColor.gray, cornerRadius: 3)
    }
    
    func  getRegistrationVerification() {
        
        let url = "https://api.memebike.tv:2002/api/auth/registration/verification"
        AF.request("'https://api.memebike.tv:2002/api/auth/registration/verification" ,method: .post)
        let parameter : Parameters = [
            "countryCode" : countrycodeOTP,
            "mobile" : mobileNumberOTP,
            "code" : codeOTP,
            "email" : "",
            "referBy" : "",
            "hash"   : hashOTP
        ]
        print(codeOTP)
        print(Parameters.self)
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                if let mobile = json["mobile"].string {
                    print(mobile)
                }
                if let code = json["code"].string {
                    print(code)
                }
                if let message = json["message"].string {
                    print(message)
                    messageData = message
                    if (messageData == "Account created!") {
                        performSegue(withIdentifier: "home", sender: self)
                        showAlert(alertText: "Alert", alertMessage: messageData)
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
    
    
    func getVerification() {
        let url = "https://api.memebike.tv:2002/api/auth/login/verification"
        AF.request("https://api.memebike.tv:2002/api/auth/login/verification" ,method: .post)
        let parameter : Parameters = [
            "countryCode" : countrycodeOTP,
            "mobile" : mobileNumberOTP,
            "code" : codeOTP,
            "email" : "",
            "referBy" : "",
            "hash"   : hashOTP
        ]
        print(codeOTP)
        print(Parameters.self)
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                if let mobile = json["mobile"].string {
                    print(mobile)
                }
                if let code = json["code"].string {
                    print(code)
                }
                if let message = json["message"].string {
                    print(message)
                    messageData = message
                    if (messageData == "Login to app successfully!") {
                        performSegue(withIdentifier: "home", sender: self)
                        showAlert(alertText: "Alert", alertMessage: String(messageData))
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
    
    @IBAction func continueBtn(_ sender: UIButton) {
        
       validation()
        if messageData == "Verification code sent!" {
            getRegistrationVerification()
        }
        else {
            getVerification()
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

}
