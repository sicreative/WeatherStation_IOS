//
//  HttpJson.swift
//  WeatherStation
//
//  Created by slee on 10/11/2019.
//  Copyright © 2019 sclee. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData



class HttpJson : NSObject,URLSessionDataDelegate{
  
  


    let sessionIdentifier = "mobile_json"
    let updaterate = 5.0
    let saverate = 5.0
    var lastsavetimestamp = 0.0
    
    var json = ""
    var receivedData: Data?
    static let maxretry = 20
    var retry = HttpJson.maxretry
    var running = false
    var weatherData: WeatherData
    var weatherDataUpdated: WeatherDataUpdated
    
    private var session:URLSession?


    private var dataContainer:NSPersistentCloudKitContainer?
    
    
    
    
 
    
    struct Weather_json: Codable {
        
      
        var temperature:Float
        var humidity:Float
        var pressure:Float
        var altitude:Float
        var pm1:Int
        var pm25:Int
        var pm10:Int
        var light:Float
        var iaq:Int
        var eco2:Int
        var evoc:Int
        var accuracy:Int
        var gas:Int
        var fan:Int
        var time:Int64
        
        
        
    }
    
    convenience init(dataContainer:NSPersistentCloudKitContainer){
        self.init()
        self.dataContainer = dataContainer
        
       
    }
    
   override init(){
        
        weatherData = WeatherData()
        weatherDataUpdated = WeatherDataUpdated()
        
        super.init()
         let sessionConf = URLSessionConfiguration.background(withIdentifier:( sessionIdentifier))
        sessionConf.waitsForConnectivity = true;

        
        session = URLSession(configuration: sessionConf,delegate: self,delegateQueue: nil)
        
        
       
        
    
        
        
        
                   
        }
    
    func startLoad(){
        if (running){
            return
        }
        
        running = true
        
        let url = URL(string: "http://192.168.1.134:8080/mobile.json")!
        
        receivedData = Data()
        
        let task = session?.dataTask(with: url)
        
        
        task?.resume()
        
        
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode),
            let mimeType = response.mimeType,
            mimeType == "application/json" else {
            completionHandler(.cancel)
            return
        }
        completionHandler(.allow)
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.receivedData?.append(data)
    }
    

    func coreSave(timestamp:Int64){
        if (dataContainer==nil){
            return
        }
        
        let current = Date().timeIntervalSince1970
        
        if (current - lastsavetimestamp < saverate){
            return
        }
        
        lastsavetimestamp = current
        
        let moc = dataContainer?.newBackgroundContext()
        let sensorsData = NSEntityDescription.insertNewObject(forEntityName: "Sensors", into: moc!)
        
        sensorsData.setValue(Date(timeIntervalSince1970: Double(timestamp)), forKey: "timestamp")
        do {
            let data =  try NSKeyedArchiver.archivedData(withRootObject: self.weatherData.data,requiringSecureCoding: false)
             sensorsData.setValue(data, forKey: "sensors")
             try moc?.save()
            
           
            
        }catch{
            fatalError("Failure context: \(error)")
        }
       
       
        let sensorsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensors")
        
        do{
            
            let fetchedSensors = try moc!.fetch(sensorsFetch)
            
          
            
    
            
            
            print(String(fetchedSensors.count))
            
              weatherDataUpdated.updated = false
            
        }catch{
            fatalError("Failed to fetch sensors: \(error)")
        }
       
        
        
       // sensorsData["timestamp"] = Date(timeIntervalSince1970: Double(timestamp))
       // sensorsData. = weatherData as! Data
       // sensorsData.timestamp = Date(timeIntervalSince1970: Double(timestamp))
        
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        running = false
        if (error != nil && (error! as NSError).domain == NSURLErrorDomain){
            
            if (retry != 0){
                retry-=1
                startLoad();
                
            }
            DispatchQueue.main.async {
            self.weatherData.data.removeAll()
            }
            return
        }
        retry = HttpJson.maxretry
        //let s = String(decoding: receivedData!,as: UTF8.self)
        let decorder = JSONDecoder()
        
        do{
           let json = try decorder.decode(Weather_json.self, from: receivedData!)
            DispatchQueue.main.async {
                self.weatherData.data["temperature"] = WeatherValue(name:"Temperature",value:String(json.temperature),unit:"℃")
                self.weatherData.data["humidity"] = WeatherValue(name:"humidity",value:String(json.humidity),unit:"%")
                self.weatherData.data["pressure"] = WeatherValue(name:"pressure",value:String(json.pressure),unit:"hPa")
                self.weatherData.data["altitude"] = WeatherValue(name:"altitude",value:String(json.altitude),unit:"m")
                self.weatherData.data["pm1"] = WeatherValue(name:"pm1",value:String(json.pm1),unit:"μg/㎥")
                self.weatherData.data["pm25"] = WeatherValue(name:"pm25",value:String(json.pm25),unit:"μg/㎥")
                self.weatherData.data["pm10"] = WeatherValue(name:"pm10",value:String(json.pm10),unit:"μg/㎥")
                self.weatherData.data["iaq"] = WeatherValue(name:"iaq",value:String(json.iaq),unit:"")
                self.weatherData.data["eco2"] = WeatherValue(name:"eco2",value:String(json.eco2),unit:"ppm")
                self.weatherData.data["evoc"] = WeatherValue(name:"evoc",value:String(json.evoc),unit:"ppm")
                self.weatherData.data["light"] = WeatherValue(name:"light",value:String(json.light),unit:"lux")
                self.weatherData.data["accuracy"] = WeatherValue(name:"accuracy",value:String(json.accuracy),unit:"lux")
                self.weatherData.data["gas"] = WeatherValue(name:"gas",value:String(json.gas),unit:"ohm")
                self.weatherData.data["fan"] = WeatherValue(name:"fan",value:String(json.fan),unit:"mV")
               
                self.coreSave(timestamp:json.time)
                Timer.scheduledTimer(withTimeInterval: self.updaterate, repeats: false){ timer in
                    self.startLoad()
                }
            }
            
            
            
            
        }catch {
            
        }
        
       
    }
    
    
}

