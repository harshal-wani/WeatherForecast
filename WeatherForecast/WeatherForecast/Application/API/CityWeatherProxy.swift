//
//  CityWeatherProxy.swift
//  WeatherForecast
//
//  Created by Harshal Wani on 7/31/16.
//  Copyright © 2016 Harshal Wani. All rights reserved.
//

import UIKit

class CityWeatherProxy: NSObject {

    class func getCityWeatherForecast(cityName: String,
                                noOfDays: NSInteger,
                                completionHandler:(finished: Bool, response: AnyObject) -> Void,
                                failureHandler:(finished: Bool, response: AnyObject)-> Void)
        -> Void {
        
            var url = String(format: "data/2.5/forecast/daily?q=%@&cnt=%d&APPID=%@",cityName,noOfDays,WEATHER_MAP_API_KEY)
            
            if cityName.isEmpty {
                url = String(format: "")
            }
            print(url)
            
        APIProxy.getRequestDataWithURL(url,
                                       successHandler:
            { (success, response) in
            
                print(response)

                if APIProxy.checkServerRequestFailuire(response){
                    
                    failureHandler(finished: false, response: response)
                }
                else {
                    completionHandler(finished: true, response: response)
                }
            
            })
            { (success, errorType) in
                
                failureHandler(finished: false, response: "")
            }
            
    }
}
