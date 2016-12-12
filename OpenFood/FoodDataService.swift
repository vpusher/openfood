//
//  FoodDataService.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 12/6/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import Foundation

class FoodDataService {
    
    public static func searchProducts (_ query: String, callback: @escaping (NSArray?) -> Void) {
        
        let urlQuery = query.replacingOccurrences(of: " ", with: "+")
        
        DataService.JSONFromURL("http://world.openfoodfacts.org/cgi/search.pl?search_terms=\(urlQuery)&search_simple=1&action=process&json=1", callback: { (data) in
            let products = data?["products"] as? NSArray
            callback(products)
        })

    }
    
    public static func getProduct (_ barcode: String, callback: @escaping (Dictionary<String, AnyObject>?) -> Void) {
        
        DataService.JSONFromURL("http://fr.openfoodfacts.org/api/v0/produit/\(barcode).json", callback: { (data) in
            let product = data?["product"] as? [String: AnyObject]
            callback(product)
        })
        
    }
    
}
