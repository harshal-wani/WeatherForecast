//
//  NSDateExtensions.swift
//  WeatherForecast
//
//  Created by Harshal Wani on 7/31/16.
//  Copyright © 2016 Harshal Wani. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
 
    class func convertDateToWithFormat(timestampDate: Double) -> String {
        
        let date1 = NSDate(timeIntervalSince1970: timestampDate)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "dd MMM"
        
        return dateFormatter.stringFromDate(date1)
        
    }

}