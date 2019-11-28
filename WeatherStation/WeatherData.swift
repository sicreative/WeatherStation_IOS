//
//  WeatherData.swift
//  WeatherStation
//
//  Created by slee on 11/11/2019.
//  Copyright © 2019 sclee. All rights reserved.
//


import SwiftUI
import Combine

final class WeatherData: ObservableObject  {
    
    
    
    @Published var data = [String: WeatherValue]()
  
   
    
   
}
