//
//  CityForecastModel.swift
//  WeatherForecast
//
//  Created by Harshal Wani on 7/31/16.
//  Copyright © 2016 Harshal Wani. All rights reserved.
//

import UIKit

class CityForecastModel: NSObject {
    
    var dt : NSNumber? = 0
    var mainVal:String = ""
    var icon:String = ""
    var rain:NSNumber? = 0
    
    class func jsonMapping() -> [String : String] {
        
        return [
            "dt":"dt",
            "main":"mainVal",
            "icon":"icon",
            "rain":"rain"]
    }
    
    class func getModelFromDictionary(dictionary:NSDictionary) -> CityForecastModel {
        
        let model = CityForecastModel()
        let mapping:[String: String] = CityForecastModel.jsonMapping()
        
        for attribute in CityForecastModel.jsonMapping().keys {
            
            let classProperty = mapping[attribute]! as String
            let attributeValue = dictionary.objectForKey(attribute)
            
            if attributeValue != nil && !((attributeValue?.isKindOfClass(NSNull.self))!) {
                
                model.setValue(attributeValue, forKey: classProperty)
            }
        }
        return model as CityForecastModel

    }
    
    class func getArrayOfCityForecastModel(dictionary:NSDictionary) -> NSArray {
        
        var weatherForcastList:[CityForecastModel] = []
        let dictArray = dictionary["list"] as! NSArray
        
        for tempDict in dictArray {
            
            var model = CityForecastModel()
            
            let dict = tempDict as! NSDictionary
            let weatherDict = dict["weather"] as! NSArray
            let subDict = weatherDict[0] as! NSDictionary
            
            model = getModelFromDictionary(subDict)

            model.setValue(dict["dt"], forKey: "dt")

            let result1 = (dict["rain"] != nil) ? dict["rain"] : 0;
            model.setValue(result1, forKey: "rain")

            weatherForcastList.append(model)
            
        }
        return weatherForcastList
    }

}
