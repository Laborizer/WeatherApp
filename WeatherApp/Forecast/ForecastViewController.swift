//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Lauri Laiho on 09/10/2019.
//  Copyright © 2019 Lauri Laiho. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var weatherForecastTableView: UITableView!
    
    var gradientLayer: CAGradientLayer?
    var weatherDataController: WeatherDataController?
    var forecasts = [List]()
    var icons = [UIImage]()
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addGradientToView(view: self.view)
        self.weatherForecastTableView.backgroundColor = UIColor.clear
        self.weatherForecastTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.weatherForecastTableView.delegate = self
        self.weatherForecastTableView.dataSource = self
        
        self.weatherDataController!.fetchForecastWeather(url: "https://api.openweathermap.org/data/2.5/forecast?lat=\(self.weatherDataController!.latitude!)&lon=\(self.weatherDataController!.longitude!)&units=metric&APPID=327b73ea7d94c0c1871610cb070cda9d", view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.weatherForecastTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        let upperText = forecasts[indexPath.row].weather[0].main + ", " + String(forecasts[indexPath.row].main.temp) + "°C"
        let lowerText = forecasts[indexPath.row].dt_txt
        
        cell!.textLabel?.numberOfLines = 2
        cell!.textLabel?.text = upperText + "\n" + lowerText
        cell!.textLabel?.textColor = UIColor.white
        cell!.layer.backgroundColor = UIColor.clear.cgColor
        if (!icons.isEmpty) {
            cell!.imageView?.image = icons[indexPath.row]
        }
        return cell!
    }
    
    func createForecastsArray() {
        self.forecasts.removeAll(keepingCapacity: true)
        let dataList = weatherDataController!.forecastDataModel!.list
        for data in dataList {
            if (data.dt_txt.contains("09:00:00") || data.dt_txt.contains("12:00:00") || data.dt_txt.contains("15:00:00") || data.dt_txt.contains("18:00:00") || data.dt_txt.contains("21:00:00")) {
                forecasts.append(data)
                self.weatherForecastTableView.reloadData()
            }
        }
        DispatchQueue.main.async(execute: {() in
            do {
                self.weatherForecastTableView.reloadData()
            } catch {
                print(error)
            }
        })
    }
    
    func createIconsArray() {
        self.icons.removeAll(keepingCapacity: true)
        let dataList = self.weatherDataController!.forecastDataModel!.list
        for data in dataList {
            if (data.dt_txt.contains("09:00:00") || data.dt_txt.contains("12:00:00") || data.dt_txt.contains("15:00:00") || data.dt_txt.contains("18:00:00") || data.dt_txt.contains("21:00:00")) {
                let iconCode = data.weather[0].icon
                
                let url = URL(string: "https://openweathermap.org/img/w/\(iconCode).png")!
                self.weatherDataController!.downloadIcons(from: url)
            }
        }
    }
    
    func addGradientToView(view: UIView) {
        self.gradientLayer = CAGradientLayer()
        gradientLayer!.colors = [UIColor.black.cgColor,    UIColor.gray.cgColor, UIColor.black.cgColor]
        gradientLayer!.locations = [0.0, 0.5, 1.0]
        view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        self.gradientLayer!.frame = self.view.bounds
    }
    
    
}
