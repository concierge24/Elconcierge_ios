//
//  StoryClcCell.swift
//  RoyoRide
//
//  Created by Prashant on 07/07/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import AVFoundation

class StoryClcCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var viewPlayerContainer: UIView!
    
   
    var playerLayer:AVPlayerLayer?
    var durationInSeconds = 0
    var currentTimeInSeconds = 0
    var item:StoryModel?
    var timeObserver:Any?
    
    
    
    
    
    func setupPlayer(player:AVPlayer?){
        
//        if let playerLayer = playerLayer{
//
//            playerLayer.removeFromSuperlayer()
//            self.playerLayer = nil
//        }
        guard let player = player else{return}
        

             playerLayer = AVPlayerLayer(player: player)
            guard let playerLayer = playerLayer else{return}
            player.seek(to: .zero)
           
            playerLayer.frame = self.bounds //bounds of the view in which AVPlayer should be displayed
            playerLayer.videoGravity = .resizeAspect
            
            //4. Add playerLayer to view's layer
            self.viewPlayerContainer.layer.addSublayer(playerLayer)
            
    
        
    }
    
    
    
    
    
}
