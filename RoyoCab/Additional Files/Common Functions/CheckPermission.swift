//
//  CheckPermission.swift
//  Untap
//
//  Created by Sierra 4 on 13/06/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//


import Photos
import Contacts
import Foundation
import AddressBook

import Permission



extension CheckPermission {
  
  //static let shared = CheckPermission()
  
  
  func type(_ permissionType:Permission,completion:@escaping()->()) {
    
    let permission:Permission = permissionType
    
    permission.request { status in
      switch status {
      case .authorized:    print("authorized")
      completion()
      case .denied:        print("denied")
      case .disabled:      print("disabled")
      case .notDetermined: print("not determined")
      }
    }
  }
}
