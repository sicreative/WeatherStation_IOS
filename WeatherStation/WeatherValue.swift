//
//  WeatherValue.swift
//  WeatherStation
//
//  Created by slee on 12/11/2019.
//  Copyright © 2019 sclee. All rights reserved.
//

import SwiftUI
import Combine

class WeatherValue:NSObject,NSCoding  {
    var value:String
    var name:String
    var unit:String
    
    func encode(with coder: NSCoder) {
        coder.encode(value)
        coder.encode(name)
        coder.encode(unit)
    }
    
    required init?(coder: NSCoder) {
       value = coder.decodeObject() as! String
        name = coder.decodeObject() as! String
        unit = coder.decodeObject() as! String
    }
    
    
    
    init(name:String,value:String,unit:String){
        self.value = value
        self.name = name
        self.unit = unit
    }
    
    
    
}
