//
//  CityWeatherForecastCell.swift
//  WeatherForecast
//
//  Created by Harshal Wani on 7/31/16.
//  Copyright © 2016 Harshal Wani. All rights reserved.
//

import UIKit

class CityWeatherForecastCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblRainTemp: UILabel!
    @IBOutlet weak var lblTempMax: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Public Methods
    
    func resetUIandPrepareForReuse() -> Void {
        self.lblDay.text = ""
        self.lblRainTemp.text = ""
        self.lblTempMax.text = ""
    }
    func setUpUIWithModel(model: CityForecastModel) -> Void {
        
        self.lblDay.text = String(format:"%@", NSDate.convertDateToWithFormat(Double(model.dt!)))
        
        self.lblRainTemp.text = model.rain?.stringValue
        let  imageUrl = BASE_URL + "img/w/" + model.icon + ".png"
        
        self.imgWeather!.sd_setImageWithURL((NSURL(string: imageUrl)), placeholderImage: UIImage(named: "weather_placeholder"))
    }

}
