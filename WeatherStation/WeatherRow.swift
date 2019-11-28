//
//  WeatherRow.swift
//  WeatherStation
//
//  Created by slee on 11/11/2019.
//  Copyright © 2019 sclee. All rights reserved.
//

import SwiftUI
struct WeatherRow: View {
   
    var name:String
    @EnvironmentObject var data : WeatherData
    
   
    init(name:String){
        self.name = name;
        
        
      
        
    }
    
    var body: some View{
 
        var value = "preview_value"
        var unit = "preview_unit"
        
        if (data.data[self.name] != nil){
            value = data.data[self.name]!.value
            unit = data.data[self.name]!.unit
        }
        
      
      return VStack(){
            

                
                HStack(alignment: .top){
                    Text(Bundle.main.localizedString(forKey: name+"_icon", value: "💡", table: nil)).font(.system(size: 35)).frame(width: 50, height: 50, alignment: .center)
                    VStack(alignment: .leading){
                        Text(Bundle.main.localizedString(forKey: name, value: name, table: nil)).font(.subheadline)
                        HStack(alignment: .bottom){
                                Spacer()
                                Text(value).font(.title)
                                Spacer()
                            Text(unit).font(.subheadline).frame(minWidth: 30).padding(.trailing,10)
                                
                             }
                       
                         }
        }
          
            
        }
    }
    
    
}

struct WeatherRow_Previews: PreviewProvider {
  
      
    static var previews: some View {
       
      
        
        WeatherRow(name:"preview_name").environmentObject(WeatherData())
      
    }
}
