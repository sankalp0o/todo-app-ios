//
//  httpmethods.swift
//  testapp3
//
//  Created by Sankalp Agarwal on 16/08/16.
//  Copyright © 2016 Sankalp Agarwal. All rights reserved.
//

import Foundation
import UIKit


func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
    let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
    if NSJSONSerialization.isValidJSONObject(value) {
        do{
            let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string as String
            }
        }catch {
            print("error")
            //Access error here
        }
    }
    return ""
}



func JSONParseArray(string: String) -> [AnyObject]{
    if let data = string.dataUsingEncoding(NSUTF8StringEncoding){
        do{
            if let array = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)  as? [AnyObject] {
                return array
            }
        }catch{
            print("error")
            //handle errors here
        }
    }
    return [AnyObject]()
}


func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
    
    if let data: NSData = jsonString.dataUsingEncoding(
        NSUTF8StringEncoding){
        
        do{
            if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>{
                return jsonObj
            }
        }catch{
            print("Error")
        }
    }
    return [String: AnyObject]()
}



func HTTPsendRequest(request: NSMutableURLRequest,
                     callback: (String, String?) -> Void) {
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(
        request, completionHandler :
        {
            data, response, error in
            if error != nil {
                callback("", (error!.localizedDescription) as String)
            } else {
                callback(
                    NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,
                    nil
                )
            }
    })
    
    task.resume()
    
}

func HTTPGetJSON(
    url: String,
    callback: (Dictionary<String, AnyObject>, String?) -> Void) {
    
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    HTTPsendRequest(request) {
        (data: String, error: String?) -> Void in
        if error != nil {
            callback(Dictionary<String, AnyObject>(), error)
        } else {
            let jsonObj = JSONParseDict(data)
            callback(jsonObj, nil)
        }
    }
}

func HTTPGetJSONArray(
    url: String,
    callback: ([AnyObject], String?) -> Void){
    
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    HTTPsendRequest(request) {
        (data: String, error: String?) -> Void in
        if error != nil {
            callback([AnyObject](), error)
        } else {
            let jsonArr = JSONParseArray(data)
            callback(jsonArr, nil)
        }
    }
}

//HTTPGetJSON("http://itunes.apple.com/us/rss/topsongs/genre=6/json") {
//    (data: Dictionary<String, AnyObject>, error: String?) -> Void in
//    if error != nil {
//        print(error)
//    } else {
//        print(data)
//    }
//}



