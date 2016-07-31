//
//  APIProxy.swift
//  WeatherForecast
//
//  Created by Harshal Wani on 7/30/16.
//  Copyright © 2016 Harshal Wani. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class APIProxy: NSObject {
    
    // MARK: Helper Methods
    
    // Declare Headers
    class func getHeaders(mutableURLRequest : NSMutableURLRequest) -> NSMutableURLRequest  {
        
        //ToDo: Add your default session headers if required like API-SESSION-KEY
        
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return mutableURLRequest
    }
    
    // Create Complete URL
    class func getCompleteUrl(url: String) -> String {
        
        let baseUrl: String = BASE_URL
        var completedURL: String =  ""
        let url1 = url
        
        if !url.isEmpty && !baseUrl.isEmpty     {
            
            let imageURL = url[url.startIndex] == "/" ? String(url1.substringFromIndex(url1.startIndex.successor())): url1
            completedURL = baseUrl[baseUrl.endIndex.predecessor()] != "/" ? String(baseUrl+"/"): baseUrl
            completedURL.appendContentsOf(imageURL)
            completedURL =  completedURL.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
        }
        
        print("Complete Url : %@",completedURL)
        
        return completedURL
    }
    
    // MARK: API calls
    
    // GET
    class func getRequestDataWithURL(requestUrl: String,
                                     successHandler:(Bool, [String : AnyObject]) -> Void,
                                     failureHandler: (Bool, NSError?)->Void)   {
        
        if APP_DELEGATE.isNetworkAvailable == true {
            
            var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.getCompleteUrl(requestUrl))!)
            mutableURLRequest.HTTPMethod = "GET"
            
            mutableURLRequest = self.getHeaders(mutableURLRequest)
            
            Alamofire.request(mutableURLRequest)
                .responseJSON { (response) -> Void in
                    
                    guard response.result.isSuccess else {
                        
                        print("Error : \(response.result.error)")
                        
                        MBProgressHUD.hideHUDForView(APP_DELEGATE.window, animated: true)
                        showErrorAlert(response.result.error!)
                        failureHandler(false,response.result.error)
                        
                        return
                    }
                    
                    guard let value = response.result.value else    {
                        
                        print("Error: \(response.result.error)")
                        
                        
                        MBProgressHUD.hideHUDForView(APP_DELEGATE.window, animated: true)
                        
                        showErrorAlert(response.result.error!)
                        
                        failureHandler(false,response.result.error)
                        
                        return
                    }
                  
                    print("Response: \(value)")
                    
                    successHandler(true,(value as? [String : AnyObject])!)
            }
        } else {
            MBProgressHUD.hideHUDForView(APP_DELEGATE.window, animated: true)
            UIUtils.alertViewWithMessage("Alert", message: NSLocalizedString("Please check your internet connection.", comment:""))
            
        }
    }

    //MARK: Server Error Alert
    
    class func showErrorAlert(error:NSError) {
        
        if error._code == NSURLErrorTimedOut {
            
            UIUtils.alertViewWithMessage("Alert", message:"The server is not responding, please try again later.")
        }
    }

    //MARK: Server response validations with code
    
   class func checkServerRequestFailuire(object: AnyObject) -> Bool {
    
        if object.isKindOfClass(NSDictionary) {
            
            let code = Int(object["cod"] as! String)
            
            MBProgressHUD.hideHUDForView(APP_DELEGATE.window, animated: true)
            
            if code == 200 {
                
                return false
            }
            if code == 401 {
                
                let message = object["message"] as! String
                UIUtils.alertViewWithMessage("Alert", message: message)
                return true
            }
            
        }
        return false
    }
    
}
