//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Lauri Laiho on 09/10/2019.
//  Copyright © 2019 Lauri Laiho. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var weatherDataController: WeatherDataController?
    var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addGradientToView(view: self.view)
        cityNameLabel.text? = "Tampere"
        weatherInfoLabel.text? = "Foggy"
        temperatureLabel.text? = "0°C"
    }
    
    func updateWeatherData() {
        DispatchQueue.main.async(execute: {() in
            do {
                let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.weatherDataController!.latitude!)&lon=\(self.weatherDataController!.longitude!)&units=metric&APPID=327b73ea7d94c0c1871610cb070cda9d"
                self.weatherDataController!.fetchCurrentWeather(url: url, view: self)
            } catch {
                print(error)
            }
        })
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.weatherIconImageView.image = UIImage(data: data)
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
