//
//  Validation.swift
//  Grintafy
//
//  Created by Sierra 4 on 14/07/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import Foundation
import SwiftMessages

enum FieldType {
  case name
  case email
  case phone
}

enum Valid {
  case success
  case failure(String)
}

class Validations {
  
  static let sharedInstance = Validations()
    
    func validationLevel(pickupLevel: String, dropLevel:String) -> Bool {
        
        if pickupLevel.isEmpty {
            Alerts.shared.show(alert: "AppName".localizedString, message: "pickupLevel".localizedString , type: .error )
            return false
        } else if dropLevel.isEmpty {
             Alerts.shared.show(alert: "AppName".localizedString, message: "dropLevel".localizedString , type: .error )
            return false
        }
        
        return true
    }

    
    func validationFrazileTemplate(materialType: String, weightInKg: String, receiverName: String, phoneNumber: String, senderName: String, additionalInfomation: String, pickupAt: String, dropoffAt: String) -> Bool {
        
        if materialType.isEmpty {
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .Delivery20:
                Alerts.shared.show(alert: "AppName".localizedString, message: "materialType2".localizedString , type: .error )
                break
                
            default:
               Alerts.shared.show(alert: "AppName".localizedString, message: "materialType".localizedString , type: .error )
            }
            
            return false
            
        } else if weightInKg.isEmpty {
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .Delivery20:
                Alerts.shared.show(alert: "AppName".localizedString, message: "approxWeight2".localizedString , type: .error )
                break
                
            default:
               Alerts.shared.show(alert: "AppName".localizedString, message: "approxWeight".localizedString , type: .error )
            }
             
            return false
            
        } else if receiverName.isEmpty {
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .Delivery20:
               Alerts.shared.show(alert: "AppName".localizedString, message: "receiverName2".localizedString , type: .error )
                break
                
            default:
               Alerts.shared.show(alert: "AppName".localizedString, message: "receiverName".localizedString , type: .error )
            }
             
            return false
        } else if phoneNumber.isEmpty {
            
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .Delivery20:
               Alerts.shared.show(alert: "AppName".localizedString, message: "phoneNumber2".localizedString , type: .error )
                break
                
            default:
               Alerts.shared.show(alert: "AppName".localizedString, message: "phoneNumber".localizedString , type: .error )
            }
            
            
            return false
        } else if senderName.isEmpty {
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .Delivery20:
                Alerts.shared.show(alert: "AppName".localizedString, message: "senderName2".localizedString , type: .error )

                break
                
            default:
                Alerts.shared.show(alert: "AppName".localizedString, message: "senderName".localizedString , type: .error )

            }
            return false
        } else if additionalInfomation.isEmpty {
            Alerts.shared.show(alert: "AppName".localizedString, message: "additionalInformation".localizedString , type: .error )
            return false
        } else if pickupAt.isEmpty {
            Alerts.shared.show(alert: "AppName".localizedString, message: "pickupAtLocation".localizedString , type: .error )
            return false
        } else if dropoffAt.isEmpty {
            Alerts.shared.show(alert: "AppName".localizedString, message: "dropAtLocation".localizedString , type: .error )
                       return false
        }
        
        return true
    }

    
    
    func validateSchedulingDate(date : Date, minDate: Date = Date().addHours(hoursToAdd: 1)) -> Bool {
        
        let oneHourAdded = minDate.addingTimeInterval(-10)
        if date.isGreaterThanDate(dateToCompare: oneHourAdded) {
            return true
        }
        return false
    }
    
    
    func validateCancellingReason(strReason : String) -> Bool {
        if strReason.isBlank {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "cancellation_reason_validation_text".localizedString , type: .error )

            return false
        }
    return true
    }
    
    
    func validateContactUS(strReason : String) -> Bool {
        if strReason.isBlank {
            Alerts.shared.show(alert: "AppName".localizedString, message: "please_enter_message".localizedString , type: .error )

            return false
        }
        return true
    }
  
  func validateEmail(email: String) -> Bool {
    if email.isBlank {
       Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter email." , type: .error )

      return false
    } else {
      let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
      let status = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
      if status {
        return true
      } else {
        Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter valid email." , type: .error )

        return false
      }
    }
  }
    
    func validateProfileSetup(firstName: String,lastName:String,address:String, email: String, officialIDRequire: Bool,  isOfficialIDFrontImageAdded: Bool, isOfficialIDBackImageAdded: Bool, addressProofImage: Bool, addressImages: [UIImage]) -> Bool {
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        
        switch template {
            
        case .DeliverSome?:
            if firstName.isEmpty {
                
                Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter first name".localizedString , type: .error )
                
                return false
            }else if lastName.isEmpty {
                
                Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter last name".localizedString , type: .error )
                
                return false
            } else if !validateEmail(email: email) {
                return false
            }
                
            else {
                return true
                
            }
            
            
        default:
            
            if firstName.isEmpty {
                
                Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter first name".localizedString , type: .error )
                
                return false
            }else if lastName.isEmpty {
                
                Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter last name".localizedString , type: .error )
                
                return false
            }else if address.isEmpty {
                
                Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter address".localizedString , type: .error )
                return false
                
            } else if !validateEmail(email: email) {
                return false
                
            } else if officialIDRequire {
                if !isOfficialIDFrontImageAdded || !isOfficialIDBackImageAdded {
                    Alerts.shared.show(alert: "AppName".localizedString, message: "Please add both front & back image of your official ID".localizedString , type: .error )
                    return false
                }
            } else if addressProofImage {
                if addressImages.count == 0 {
                    Alerts.shared.show(alert: "AppName".localizedString, message: "Please add  your address id proof images.".localizedString , type: .error )
                    return false
                }
            }
            
            else {
                return true
                
            }
            
        }
        
        return true
      
    }
  
  func validateUserName(userName: String) -> Bool {
    
    if userName.isEmpty {
        
        Alerts.shared.show(alert: "AppName".localizedString, message: "name_empty_validation_message".localizedString , type: .error )

      return false
    } else {
         return true
//      let regEx = "^([a-zA-Z]{1,}\\s?[a-zA-z]{1,}'?-?[a-zA-Z]{1,}\\s?([a-zA-Z]{1,})?)"
//      let emailTest = NSPredicate(format:"SELF MATCHES %@", regEx)
//      let status = emailTest.evaluate(with: userName)
//      if status {
//        return true
//      } else {
//        Toast.show(text: "name_empty_validation_message".localizedString , type: .error)
//        return false
//      }
    }
  }
    
    
    
    
    func validateLoginUsernameAndPassword(usernameOrEmail: String, password: String) -> Bool {
        
        
        if usernameOrEmail.isEmpty {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "username_email_validation".localizedString , type: .error )

          return false
        } else if password.isEmpty {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "password_empty_validation_message".localizedString , type: .error )

          return false
        } else {
             return true
    //      let regEx = "^([a-zA-Z]{1,}\\s?[a-zA-z]{1,}'?-?[a-zA-Z]{1,}\\s?([a-zA-Z]{1,})?)"
    //      let emailTest = NSPredicate(format:"SELF MATCHES %@", regEx)
    //      let status = emailTest.evaluate(with: userName)
    //      if status {
    //        return true
    //      } else {
    //        Toast.show(text: "name_empty_validation_message".localizedString , type: .error)
    //        return false
    //      }
        }
      }
    
    func validateSignupUsernameAndPassword(usernameOrEmail: String, password: String, confirmPassword: String, phone: String) -> Bool {
        
        
        if usernameOrEmail.isEmpty {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "username_email_validation".localizedString , type: .error )

          return false
        } else if !validateSignupPassword(password: password) {
          return false
        } else if confirmPassword.isEmpty {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "confirm_password_empty_validation_message".localizedString , type: .error )

          return false
        } else if password != confirmPassword {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "password_confirmPassword_validation".localizedString , type: .error )
            return false
        } else if !validatePhoneNumber(phone: phone) {
          return false
        } else {
             return true
    //      let regEx = "^([a-zA-Z]{1,}\\s?[a-zA-z]{1,}'?-?[a-zA-Z]{1,}\\s?([a-zA-Z]{1,})?)"
    //      let emailTest = NSPredicate(format:"SELF MATCHES %@", regEx)
    //      let status = emailTest.evaluate(with: userName)
    //      if status {
    //        return true
    //      } else {
    //        Toast.show(text: "name_empty_validation_message".localizedString , type: .error)
    //        return false
    //      }
        }
      }
    
    
    
  
    func validateInstitutionalSignup(type: String, name: String) -> Bool {
        
        
        if type.isEmpty {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "institution_type_validation".localizedString , type: .error )

          return false
        } else if name.isEmpty {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "institution_name_validation".localizedString , type: .error )

          return false
        }
        return true
      }
    
    
    func validateInstitutionalSignupInfo(id: String, email: String, phone: String, password: String, image: UIImage?) -> Bool {
      
      
      if id.isEmpty {
          
          Alerts.shared.show(alert: "AppName".localizedString, message: "institution_id_validation".localizedString , type: .error )

        return false
      } else if email.isEmpty {
          
          Alerts.shared.show(alert: "AppName".localizedString, message: "empty_institutional_email_validation".localizedString , type: .error )

        return false
      }  else if !validateEmail(email: email) {
             return false
      } else if !validatePhoneNumber(phone: phone) {
        return false
      }else if !validateSignupPassword(password: password) {
        return false
      } else if image == nil {
        Alerts.shared.show(alert: "AppName".localizedString, message: "institutional_cred_Image_validation".localizedString , type: .error )
     }
        
      return true
    }
    
    
 func validatePromoCode(promo: String) -> Bool {
     
     if promo.isEmpty {
         
         Alerts.shared.show(alert: "AppName".localizedString, message: "promoCode_empty_validation_message".localizedString , type: .error )

       return false
     }
    return true
   }
  
    func validatePhoneNumber(phone: String) -> Bool {
        
        if phone.isEmpty {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "phone_validation_message".localizedString , type: .error)
            
            return false
            
        } else {
            
            return true
            
           /* if (phone.count != 10 ) {
                
                Alerts.shared.show(alert: "AppName".localizedString, message: "phone_validation_message".localizedString , type: .error)
                
                return false
                
            } else {
                
                return true
                
            } */
            
        }
        
    }
  
    
    func validateSignupPassword(password: String) -> Bool {
        
        if password.isEmpty {
                        
            Alerts.shared.show(alert: "AppName".localizedString, message: "password_empty_validation_message".localizedString , type: .error )

          return false
        } else if password.count < 6 {
                        
            Alerts.shared.show(alert: "AppName".localizedString, message: "password_length_validation_message".localizedString , type: .error )

          return false
        }
        
        return true
    }
}






