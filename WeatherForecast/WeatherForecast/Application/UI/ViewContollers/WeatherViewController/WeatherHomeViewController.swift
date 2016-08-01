//
//  WeatherHomeViewController.swift
//  WeatherForecast
//
//  Created by Harshal Wani on 7/30/16.
//  Copyright © 2016 Harshal Wani. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit

class WeatherHomeViewController: AbstractViewController,CLLocationManagerDelegate {

    @IBOutlet weak var tblCityForecast: UITableView!

    @IBOutlet weak var lblNoRecords: UILabel!
    @IBOutlet weak var txtCityName: UITextField!
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var cityName = ""
    var cityForecastArray:[CityForecastModel]  = []

    override func viewDidLoad() {
        super.viewDidLoad()

        showAccessLocationPopUp()
        registerTableViewCell()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    //MARK: Private Methods
    
    func showAccessLocationPopUp() {
        
        // Ask for access location Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    func getUsersCurrentCity() {
        
        let geoCoder = CLGeocoder()
        
        let location = CLLocation(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if placeMark != nil
            {
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    self.cityName = city as String
                    self.txtCityName.text = self.cityName
                    self.callGetCityForecast()
                }
            }
            }
        )
    }

    func registerTableViewCell() -> Void {
        
        self.tblCityForecast.registerNib(UINib(nibName: "CityWeatherForecastCell",bundle: nil), forCellReuseIdentifier: "CityWeatherForecastCell")
    }
    
    //MARK: UITableView delegate and datasource methods
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityForecastArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tblCityForecast.dequeueReusableCellWithIdentifier("CityWeatherForecastCell", forIndexPath: indexPath) as! CityWeatherForecastCell
        
        cell.resetUIandPrepareForReuse()
        cell.setUpUIWithModel(self.cityForecastArray[indexPath.row])
        return cell
    }
    
    //MARK: TextView Delegate methods
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        if self.txtCityName.text != "" {
            
            self.cityName = self.txtCityName.text!
            callGetCityForecast()
        }
    }
    
    //MARK: CLLocationManager Delegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.currentLocation = manager.location!.coordinate
        
        locationManager.stopUpdatingLocation()
        
        getUsersCurrentCity()
        
    }

    //MARK: City weather forecaste API proxy call
    
    func callGetCityForecast() -> Void {

        MBProgressHUD.showHUDAddedTo(APP_DELEGATE.window, animated: true)
        
        CityWeatherProxy.getCityWeatherForecast(self.cityName, noOfDays: NUMBER_OF_DAYS, completionHandler:{
            
            (finished, response) in
            
            self.lblNoRecords.hidden = true
            let dictionary = response as! NSDictionary
            self.cityForecastArray.removeAll()
            self.cityForecastArray = CityForecastModel.getArrayOfCityForecastModel(dictionary) as! [CityForecastModel]
            
            self.tblCityForecast.reloadData()
            
            
            }) { (finished, response) in
                
                self.cityForecastArray.removeAll()
                self.tblCityForecast.reloadData()
                self.lblNoRecords.hidden = false
                self.lblNoRecords.text = INCORRECT_CITY_NAME
        }
    }
}
