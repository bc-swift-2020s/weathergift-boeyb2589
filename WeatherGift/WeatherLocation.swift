//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Brandon Boey on 3/8/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getData() {
        let coordinates = "\(latitude),\(longitude)"
        let urlString = "\(APIurls.darkSkyURL)\(APIkeys.darkSkyKey)/\(coordinates)"
        
        print("Acessing the url \(urlString)")
        //Create a url
        guard let url = URL(string: urlString) else {
            print("Error: could not create a url from \(urlString)")
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
                print("\(json)")
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
