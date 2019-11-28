//
//  ContentView.swift
//  WeatherStation
//
//  Created by slee on 7/11/2019.
//  Copyright © 2019 sclee. All rights reserved.
//

import SwiftUI





struct ContentView: View {
    
    @EnvironmentObject var weatherData: WeatherData
    @EnvironmentObject var weatherDataUpdated: WeatherDataUpdated
    
  
    
    var body: some View {
        
        
         WeatherList().environmentObject(weatherData).environmentObject(weatherDataUpdated)
        
        

    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let httpjson = HttpJson()
        httpjson.startLoad()
   
        
        return ContentView().environmentObject(httpjson.weatherData)
    }
      
}
