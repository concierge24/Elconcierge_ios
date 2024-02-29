//
//  LoginEndPoint.swift
//  Buraq24
//
//  Created by MANINDER on 16/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import Alamofire

enum LoginEndpoint {
    
    case appSetting
    case sendOtp(countryCode: String? , phoneNum : String?, iso: String?, social_key: String? = nil, signup_as: String? = nil, email: String? = nil, password: String? = nil)
    case socailLogin(social_key: String?, login_as: String?)
    case emailLogin( login_as: String?, email: String?, password: String?)
    case verifyOTP(otpCode: String?)
    case addName(name : String?,firstName:String?,lastName:String?,gender:String?,address:String?, email: String?, referral_code: String?, nationalId: String?)
     case logOut
    case updateData(fcmID : String?)
    case eContacts(phone_code:String?)
    case contactUs(message: String?)
    case editProfile(name : String? , email: String?, phone_code: String?, phone_number: String?, iso: String?)
    case updateNotifications(value : String? )
    case checkuserExists(social_key: String?, login_as: String?)
    case privateCooperationListing(items: String?, cooperation_type: String?)
    case privateCooperationRegForum(cooperation_id: Int?, identification_number: String?, email: String?, phone_code: String?, iso: String?, phone_number: String?, password: String?)
    case addEmergencyContact(contacts:String)
    case removeEmergencyContact(contactId:String)
    case userEmergencyContact
    
}

//http://192.168.100.45:9006/api-docs/#/User%20Drivers/post_user_service_homeApi
extension LoginEndpoint : RouterCab {
    

    func searchRequest(isImage: Bool, images: [UIImage?]?, isLoaderNeeded: Bool?, header: [String : String], completion: @escaping CompletionCab) -> DataRequest {
        let request = Alamofire.SessionManager.default.request("" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            print(response)
        }
        return request
    }


    func request(isImage: Bool = false , images: [UIImage?]? = [] , isLoaderNeeded: Bool? = true , header: [String: String] , completion: @escaping CompletionCab ) {
        APIManagerCab.shared.request(with: self, images: images, isLoaderNeeded: isLoaderNeeded, completion: completion, header: header)

    }

    var route : String  {
        switch self {
        case .sendOtp(_): return APITypes.sendOtp
        case .socailLogin(_): return APITypes.socailLogin
        case .verifyOTP(_): return APITypes.verifyOTP
        case .addName(_): return APITypes.addName
        case .logOut : return APITypes.logOut
        case .updateData(_) : return APITypes.updateData
        case .eContacts : return APITypes.eContacts
        case .contactUs(_) : return APITypes.contactUs
        case .editProfile(_) : return APITypes.editProfile
        case .updateNotifications(_) : return APITypes.changeNotification
        case .appSetting: return APITypes.appSetting
        case .checkuserExists: return APITypes.checkuserExists
        case .emailLogin(_): return APITypes.emailLogin
        case .privateCooperationListing: return APITypes.privateCooperationListing
        case .privateCooperationRegForum: return APITypes.privateCooperationRegForum
        case .addEmergencyContact: return APITypes.addEmergencyContact
        case .removeEmergencyContact: return APITypes.removeEmergencyContact
        case .userEmergencyContact: return APITypes.userEmergencyContact
        }
    }

    var parameters: OptionalDictionary {
        return format()
    }

    func format() -> OptionalDictionary {
     
        switch self {
            
        case .sendOtp(let countryCode,  let phoneNumber, let iso, let social_key, let signup_as, let email, let password):
            return Parameters.sendOtp.map(values: [ LanguageCode.English.rawValue , /countryCode , /phoneNumber , Utility.shared.localTimeZoneName , LocationsCab.lat.getLoc() , LocationsCab.longitude.getLoc(), "" , UserDefaultsManager.fcmId, "Ios", iso, social_key, signup_as, email, password])
            
        case .socailLogin(let social_key, let login_as):
            return Parameters.socailLogin.map(values: [ LanguageCode.English.rawValue , Utility.shared.localTimeZoneName , LocationsCab.lat.getLoc() , LocationsCab.longitude.getLoc(), "" , UserDefaultsManager.fcmId, "Ios", social_key, login_as])
            
        case .emailLogin(let login_as, let email, let password) :
            return Parameters.emailLogin.map(values: [ LanguageCode.English.rawValue , Utility.shared.localTimeZoneName , LocationsCab.lat.getLoc() , LocationsCab.longitude.getLoc(), "" , UserDefaultsManager.fcmId, "Ios", login_as, email, password])
            
            
         case .verifyOTP(let otpCode):
            return Parameters.verifyOTP.map(values: [otpCode])
            
        case .checkuserExists(let social_key, let login_as):
            return Parameters.checkuserExists.map(values: [social_key, login_as])
            
        case .addName(let strName,let firstName,let lastName,let gender,let address, let email, let referral_code, let nationalId):
            return Parameters.addName.map(values: [/strName,firstName,lastName,gender,address, email, referral_code, nationalId])
        
        case .logOut  :
        return Parameters.logout.map(values: [])
            
        case .eContacts(let phoneCode):
            return Parameters.eContacts.map(values: [phoneCode])
            
        case .updateData(let fcmID):
            return Parameters.updateData.map(values: [Utility.shared.localTimeZoneName , LocationsCab.lat.getLoc() , LocationsCab.longitude.getLoc(), fcmID])
        case .contactUs(let message):
             return Parameters.contactUs.map(values: [ message ])
        case .editProfile(let name, let email, let phone_code, let phone_number, let iso  ):
            return Parameters.editProfile.map(values: [ name, email, phone_code, phone_number, iso ])
        
        case .updateNotifications(let changeValue):
            return Parameters.changeNotification.map(values: [/changeValue])
            
        case .appSetting:
            return nil
            
        case .privateCooperationListing(let items, let cooperation_type):
            return Parameters.privateCooperationListing.map(values: [items, cooperation_type])
            
        case .privateCooperationRegForum(let cooperation_id, let identification_number, let email, let phone_code, let iso, let phone_number, let password) :
            return Parameters.privateCooperationRegForum.map(values: [ LanguageCode.English.rawValue , Utility.shared.localTimeZoneName , LocationsCab.lat.getLoc() , LocationsCab.longitude.getLoc(), "" , UserDefaultsManager.fcmId, "Ios", cooperation_id, identification_number,email , phone_code, iso, phone_number, password, "1"])
        case .addEmergencyContact(let contacts):
            return Parameters.addEmergrncyContact.map(values: [contacts])
        case .removeEmergencyContact(let contactId):
            return Parameters.removeEmergencyContact.map(values: [contactId])
        case .userEmergencyContact:
            return nil
        }
    }

    var method : Alamofire.HTTPMethod {
        switch self {

        case .appSetting, .privateCooperationListing:
            return .get
            
        default:
            return .post
        }
    }

    var baseURL: String {
        switch self {
            
        case .sendOtp(_), .verifyOTP(_), .addName(_) , .editProfile(_), .checkuserExists(_) , .socailLogin(_), .emailLogin(_), .privateCooperationRegForum(_),.addEmergencyContact(_),.removeEmergencyContact(_),.userEmergencyContact:
            return APIBasePath.basePath + Routes.user
        default:
            return APIBasePath.basePath + Routes.commonRoutes
        }
    }
}


