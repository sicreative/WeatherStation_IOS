//
//  WeatherDetail.swift
//  WeatherStation
//
//  Created by slee on 22/11/2019.
//  Copyright © 2019 sclee. All rights reserved.
//

import SwiftUI
import CoreData

struct WeatherDetail: View {
   
    struct DataItem:Identifiable {
        var id: Int64
        var value: String
        var time: String
    }
    
    
   
    
    
    
    let name : String
  
   
    @State  var log : [DataItem] = []
    @EnvironmentObject var weatherDataUpdated: WeatherDataUpdated

    
    
     func loaddata()
    {
        
         
        //var next : [DataItem] = []
        
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
                           
        let moc = container.newBackgroundContext()
        
        

        let sensorsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensors")
        
        sensorsFetch.sortDescriptors = [NSSortDescriptor(key:"timestamp",ascending: false)]
              
            let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yy-MM-dd HH:mm:ss"
             dateFormatter.timeZone = TimeZone.current
        
        var next : [DataItem] = []
        
              do{
                  
                  let fetchedSensors = try moc.fetch(sensorsFetch)
                  
                
              //  log.removeAll()
                  for item in fetchedSensors{
                      let sensor = item as! SensorsMO
                      
                      
                     // print(sensor.timestamp?.description)

                      let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(sensor.sensors!)
                    
                       let id = Int64(sensor.timestamp!.timeIntervalSince1970)
                    let item = DataItem(id: id , value: (data as! Dictionary<String,WeatherValue>)[name]!.value, time: dateFormatter.string(from: Date(timeIntervalSince1970: Double(id))))
                      
                       next.append(item)
                    //  print((data as! Dictionary<String,WeatherValue>)["iaq"]!.value)
                      
                   
                  
                      
                     // (item as! SensorsMO).timestamp
                  }
                  
                  
               log = next;
                 // print(String(fetchedSensors.count))
                  
              
                  
              }catch{
                  fatalError("Failed to fetch sensors: \(error)")
              }
    }
    
    
    
    
    
    

    var body: some View {
        
        
        if (!weatherDataUpdated.updated){
           
         
          weatherDataUpdated.updated = true
          
             
        DispatchQueue.main.async(execute: { () -> Void in
             //WeatherDetail.dataloaded = true
        
             self.loaddata()
        
            })
           
     
        }
        
        return List{
          
            
                ForEach(log, id: \.id){ data in
                    HStack{
                        Text(data.value)
                        Spacer()
                        Text(data.time)
                    }
                
                    
                    
               
         
            }
                
        }.navigationBarTitle(Text(Bundle.main.localizedString(forKey: name, value: "", table: nil))).onAppear(){
           // WeatherDetail.dataloaded = true
        }.onDisappear(){
         //   WeatherDetail.dataloaded = false
        }
        
    }
    
    
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(name:"preview")
    }
}
