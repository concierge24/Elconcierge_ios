//
//  UserInactivity.swift
//  Buraq24
//
//  Created by Apple on 14/12/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class UserInactivity: UIApplication {
    
    static let ApplicationDidTimoutNotification = "AppTimout"
    
    // The timeout in seconds for when to fire the idle timer.
    let timeoutInSeconds: TimeInterval = 1 * 60
    
    var idleTimer: Timer?
    
    override init()
    {
        super.init()
        resetIdleTimer()
    }
    
    // Resent the timer because there was user interaction.
    
    func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        // setting app timout to false
        ApplicationTimeout.isTimedOut = false
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(UserInactivity.idleTimerExceeded), userInfo: nil, repeats: false)
        
    }
    
    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    @objc func idleTimerExceeded() {
        
        ApplicationTimeout.isTimedOut = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserInactivity.ApplicationDidTimoutNotification), object: nil)
    }
    
    override func sendEvent(_ event: UIEvent) {
        
        super.sendEvent(event)
        
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches {
            for touch in touches {
                if touch.phase == UITouch.Phase.began {
                    self.resetIdleTimer()
                }
            }
        }
        
    }
}
