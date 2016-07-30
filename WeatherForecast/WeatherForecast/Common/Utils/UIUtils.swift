//
//  UIUtils.swift
//  WeatherForecast
//
//  Created by Harshal Wani on 7/31/16.
//  Copyright © 2016 Harshal Wani. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH: Float = Float(UIScreen.mainScreen().bounds.size.width)
let SCREEN_HEIGHT: Float = Float(UIScreen.mainScreen().bounds.size.height)

let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)


class UIUtils {
    
    
    class func pointsToPixels (points: Float)-> CGFloat {
        
        let baseWidth: Float = 320
        let screenWidth: Float = SCREEN_MIN_LENGTH
        
        let sd: CGFloat = CGFloat((points * screenWidth) / baseWidth);
        return sd;
    }
    
    class func alertViewWithMessage(title: String, message:String) {
        
        let alertController = UIAlertController(title:title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.Default,handler: nil)
        
        alertController.addAction(action)
        let _ = UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }

}