//
//  WeatherList.swift
//  WeatherStation
//
//  Created by slee on 20/11/2019.
//  Copyright © 2019 sclee. All rights reserved.
//

import SwiftUI
import CoreData




struct WeatherList: View {
      @EnvironmentObject var weatherDataUpdated: WeatherDataUpdated
      @EnvironmentObject var weatherData: WeatherData
    
    
    func coreDeleteAll(){
      

        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        let moc = container.viewContext
                                  
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensors")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
        try moc.execute(deleteRequest)
        
            weatherDataUpdated.updated = false
        }catch{
             fatalError("Failure delete database: \(error)")
        }
        
    }
    
    //sensor list
    let sensors = ["temperature","humidity","pressure","altitude","pm1","pm25","pm10","iaq","eco2","evoc","light","accuracy","gas","fan"]
    var body: some View {
        
    VStack{
      NavigationView {
        List {
            
            // No display if weatherData.data is empty (no network connected to devices)
            if (!weatherData.data.isEmpty){
                ForEach (0..<sensors.count){ i in
                    NavigationLink(destination:WeatherDetail(name:self.sensors[i])){
                        WeatherRow(name:self.sensors[i] ).environmentObject(self.weatherData)
                        }
                    }
                }
            }.navigationBarTitle(Text(Bundle.main.localizedString(forKey: "navigation_list_title", value: "", table: nil)))
        
        }
       
        // Clear Button
        Button(action: {self.coreDeleteAll()}) {
                    HStack{
                    Image(systemName: "trash").font(.title)
                        Text(Bundle.main.localizedString(forKey: "clear_button", value: "", table: nil)).font(.subheadline)
                    }
                        
                    .frame(width: UIScreen.main.bounds.size.width*0.8)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.orange)
                    .cornerRadius(30)
                }
        }
        
    }
    
    
}




struct WeatherList_Previews: PreviewProvider {
 static var previews: some View {
    WeatherList().environmentObject(WeatherData())
    }
    
    
}
