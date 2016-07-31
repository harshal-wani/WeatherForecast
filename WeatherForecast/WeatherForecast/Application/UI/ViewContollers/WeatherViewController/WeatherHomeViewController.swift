//
//  WeatherHomeViewController.swift
//  WeatherForecast
//
//  Created by Harshal Wani on 7/30/16.
//  Copyright © 2016 Harshal Wani. All rights reserved.
//

import UIKit
import MBProgressHUD

class WeatherHomeViewController: AbstractViewController {

    @IBOutlet weak var tblCityForecast: UITableView!

    @IBOutlet weak var txtCityName: UITextField!
    
    var cityForecastArray:[CityForecastModel]  = []

    override func viewDidLoad() {
        super.viewDidLoad()


        registerTableViewCell()
        self.tblCityForecast.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        callGetCityForecast()
  
    }
    
    //MARK: Private Methods
    
    func registerTableViewCell() -> Void {
        
        self.tblCityForecast.registerNib(UINib(nibName: "CityWeatherForecastCell",bundle: nil), forCellReuseIdentifier: "CityWeatherForecastCell")
    }

    func convertDateToWithFormat(timestampDate: Double) -> String {
        
        let date1 = NSDate(timeIntervalSince1970: timestampDate)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        return dateFormatter.stringFromDate(date1)

    }
    
    //MARK: UITableView delegate and datasource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityForecastArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tblCityForecast.dequeueReusableCellWithIdentifier("CityWeatherForecastCell", forIndexPath: indexPath) as! CityWeatherForecastCell
        
        let cityModel = self.cityForecastArray[indexPath.row]

        cell.lblDay.text = String(format:"%@", convertDateToWithFormat(Double(cityModel.dt!)))
        
        return cell
    }
    
    
    //MARK: City weather forecaste API proxy call
    
    func callGetCityForecast() -> Void {

        MBProgressHUD.showHUDAddedTo(APP_DELEGATE.window, animated: true)
        
        CityWeatherProxy.getCityWeatherForecast("California", noOfDays: 14, completionHandler:{
            
            (finished, response) in
            
            let dictionary = response as! NSDictionary
            
            self.cityForecastArray = CityForecastModel.getArrayOfCityForecastModel(dictionary) as! [CityForecastModel]
            
            self.tblCityForecast.reloadData()

            
            }) { (finished, response) in
                
                
        }
    }
}
