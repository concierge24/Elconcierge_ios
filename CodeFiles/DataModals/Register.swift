//
//  Register.swift
//  Clikat
//
//  Created by cblmacmini on 4/28/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class Register: NSObject {

    class func validateCredentials(email : String, password : String?) -> String{
        
        var message = ""
        
        if email.count == 0 {
            message = L10n.PleaseEnterYourEmailAddress.string
        }else if !isValidEmail(testStr: email){
            message = L10n.PleaseEnterAValidEmailAddress.string
        }else if password?.count == 0 {
            message = L10n.PleaseEnterYourPassword.string
        }else if (password?.count ?? 0) < 6 {
            message = L10n.PasswordShouldBeMinimum6Characters.string
        }
        return message
    }
    public class func validateEmailPhoneCred(email : String, password : String?) -> String{
           var message = ""
           if email.count == 0 {
               message = L10n.PleaseEnterYourEmailAddressOrPhoneNumber.string
           }else if password?.count == 0 {
               message = L10n.PleaseEnterYourPassword.string
           }else if (password?.count ?? 0) < 6 {
               message = L10n.PasswordShouldBeMinimum6Characters.string
           }else if !isValidEmail(testStr: email){
               if !isAllDigits(testStr: email) || (email.count) < 7{
                   message = L10n.PleaseEnterYourEmailAddressOrPhoneNumber.string
               }
           }
           return message
       }
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: testStr)
    }
    
    class func isValidPhoneNumber(testStr:String) -> Bool {
        return testStr.count < 7 ? false : true
    }
    public class func isAllDigits(testStr:String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = testStr.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  testStr == filtered
    }
    class func validateSignupDetails(email : String, password : String?, confirmPassword: String?, first_name: String?, last_name: String?, mobileNo: String?, isMobileValid:Bool) -> String{
        
        var message = ""
        
        if email.count == 0 {
            message = L10n.PleaseEnterYourEmailAddress.string
        }else if !isValidEmail(testStr: email){
            message = L10n.PleaseEnterAValidEmailAddress.string
        }else if password?.count == 0 {
            message = L10n.PleaseEnterYourPassword.string
        }else if (password?.count ?? 0) < 6 {
            message = L10n.PasswordShouldBeMinimum6Characters.string
        }else if /password != /confirmPassword {
            message = L10n.PasswordsDoNotMatch.string
        }else if !isMobileValid || !isValidPhoneNumber(testStr: mobileNo ?? "") {
            message = L10n.PleaseEnterValidPhoneNumber.string
        }
        return message
    }

}
