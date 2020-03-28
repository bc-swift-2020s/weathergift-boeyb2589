//
//  File.swift
//  WeatherGift
//
//  Created by Brandon Boey on 3/22/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import Foundation

class WeatherDetail: WeatherLocation {
    
    struct Result: Codable {
        var timezone: String
        var currently: Currently
        var daily: Daily
    }
    struct Currently: Codable {
        var temperature: Double
        var time: TimeInterval
    }
    
    struct Daily: Codable {
        var summary: String
        var icon: String
    }
    
    
    var timezone = ""
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    var currentTime = 0.0
    
    func getData(completed: @escaping () -> () ) {
        let coordinates = "\(latitude),\(longitude)"
        let urlString = "\(APIurls.darkSkyURL)\(APIkeys.darkSkyKey)/\(coordinates)"
        
        print("Acessing the url \(urlString)")
        //Create a url
        guard let url = URL(string: urlString) else {
            print("Error: could not create a url from \(urlString)")
            completed()
            return
        }
        //Create Session
        let session = URLSession.shared
        
        //Get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            //note: there are some additional things that can go wrong, but we shouldn't experience them
            
            // deal with the data
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                let result = try JSONDecoder().decode(Result.self, from: data!)
                self.timezone = result.timezone
                self.currentTime = result.currently.time
                self.temperature = Int(result.currently.temperature.rounded())
                self.summary = result.daily.summary
                self.dailyIcon = result.daily.icon
            } catch {
                print("Error \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
}
