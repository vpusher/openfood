//
//  Data.swift
//  openfoodfacts
//
//  Created by MAFFINI Florian on 11/27/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import Foundation

class DataService {
    
    public static func JSONFromURL (_ url: String, callback: @escaping (Dictionary<String, AnyObject>) -> Void) {
        
        let urlFinal = URL(string: url)
        var jsonDictionnary: Dictionary<String, AnyObject>?
        
        let task = URLSession.shared.dataTask(with: urlFinal!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                jsonDictionnary =  jsonData as? [String: AnyObject]
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            if jsonDictionnary != nil {
                callback(jsonDictionnary!)
            }
            
        })
            
        task.resume()
        
    }
    
    public static func ImageFromURL (_ url: String, callback: @escaping (Data) -> Void) {
        
        let url = URL(string: url)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            
            callback(data!)
            
            
        })
        
        task.resume()
        
    }
    
}
