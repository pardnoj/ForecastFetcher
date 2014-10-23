//
//  ForecastManager.swift
//  API
//
//  Created by Foamy Media iMac 1 on 15/10/2014.
//  Copyright (c) 2014 foamymedia. All rights reserved.
//

import Foundation
import CoreLocation

typealias Forecast = ForecastManager

typealias ResponseObject = [String : AnyObject]

typealias SuccessHandler = (response : ResponseObject) -> Void
typealias FailureHandler = (error : NSError!) -> Void

public enum Exclusion : String {
    case Currently = "currently"
    case Minutely = "minutely"
    case Hourly = "hourly"
    case Daily = "daily"
    case Alerts = "alerts"
    case Flags = "flags"
}

public enum Unit : String {
    case US = "us"
    case SI = "si"
}

public enum Language : String {
    case BS = "bs"
    case DE = "de"
    case EN = "en"
    case ES = "es"
    case FR = "fr"
    case IT = "it"
    case NL = "nl"
    case PL = "pl"
    case PT = "pt"
    case TET = "tet"
    case PIGLATIN = "x-pig-latin"
}

enum ForecastError : Int {
    case InvalidDate = 1009
}

public class ForecastManager {
    // TODO: Check if the API KEY is correct
    let apiKey : String!
    let forecastUrl = "https://api.forecast.io/forecast/"
    
    init(_ apiKey : String) {
        self.apiKey = apiKey
    }
    
    // MARK: PUBLIC METHODS
    // MARK: Closures
    public func fetchForecastWithTime(time: String,
        latitude : Double,
        longitude: Double,
        success: (response : Dictionary<String, AnyObject>!) -> (),
        failure : (error : NSError!) -> ())
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.dateFromString(time)
        if let _date = date {
            self.makeApiRequest(Int(_date.timeIntervalSince1970), latitude, longitude, completionHandler : { (jsonDict, error) -> () in
                if (error == nil) {
                    success(response: jsonDict)
                } else {
                    failure(error: error)
                }
            })
        } else {
            failure(error: NSError(domain: "Forecast: ", code: 400, userInfo: [NSLocalizedDescriptionKey : "Invalid date"]))
        }
    }
    
    public func fetchForecastWithDate(date : NSDate,
        latitude : Double,
        longitude: Double,
        success: (response : Dictionary<String, AnyObject>!) -> (),
        failure : (error : NSError!) -> ())
    {
        let unixTime = Int(date.timeIntervalSince1970)
        self.makeApiRequest(unixTime, latitude, longitude, completionHandler : { (jsonDict, error) -> () in
            if (error == nil) {
                success(response: jsonDict)
            } else {
                failure(error: error)
            }
        })
    }
    
    public func fetchForecastWithDate(date : NSDate,
        latitude : Double,
        longitude: Double,
        exclusions : [Exclusion],
        units : Unit,
        language : Language,
        success: (response : Dictionary<String, AnyObject>!) -> (),
        failure : (error : NSError!) -> ())
    {
        let unixTime = Int(date.timeIntervalSince1970)
        self.makeApiRequest(unixTime, latitude, longitude, exclusions, units, language, completionHandler : { (jsonDict, error) -> () in
            if (error == nil) {
                success(response: jsonDict)
            } else {
                failure(error: error)
            }
        })
    }
    
    // MARK: PRIVATE
    private func makeApiRequest(time : Int,
        _ latitude : Double,
        _ longitude: Double,
        _ exclusions : [Exclusion]! = nil,
        _ units : Unit! = nil,
        _ language : Language! = nil,
        completionHandler: (jsonDict : ResponseObject!, error : NSError!)-> ()) -> ()
    {
        let urlString = self.urlStringForTime(time, latitude, longitude, exclusions, units, language)
        println(urlString)
        
        NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: NSURL(string: urlString))) { (data, response, error) in
            let resp = response as NSHTTPURLResponse
            println(!(resp.statusCode >= 400))
            if (error == nil && !(resp.statusCode >= 400)) {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as ResponseObject
                completionHandler(jsonDict: json, error: nil)
            } else {
                println("this should happen")
               completionHandler(jsonDict: nil, error: error)
                
            }
        }.resume()
    }
    
    private func urlStringForTime(time : Int!, _ latitude : Double!, _ longitude : Double!, _ exclusions : [Exclusion]?, _ units : Unit?, _ language : Language?) -> String {
        var urlString : String = forecastUrl + apiKey + "/" + NSString(format: "%.14f", latitude) + "," + NSString(format: "%.14f", longitude) + "," + String(time)
        println(urlString)
        if (exclusions != nil) {
            for (index, element) in enumerate(exclusions!) {
                urlString += index == 0 ? "?exclude=" + element.toRaw() : "," + element.toRaw()
            }
        }
        if (units != nil) { urlString += (exclusions != nil) ? "&units=" + units!.toRaw() : "?units=" + units!.toRaw() }
        if (language != nil) { urlString += (exclusions != nil || units != nil) ? "&lang=" + language!.toRaw() : "?lang=" + language!.toRaw() }
        
        return urlString
    }
}









