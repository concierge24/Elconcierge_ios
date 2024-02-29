//
//  StoryModel.swift
//  RoyoRide
//
//  Created by Prashant on 07/07/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import Foundation



class StoryModel{
    
    var urlStr:String?
    var isVideo:Bool?
    init(url:String,isVideo:Bool){
        
        self.urlStr = url
        self.isVideo = isVideo
    }
    
}
