//
//  MainViewController.swift
//  openfoodfacts
//
//  Created by MAFFINI Florian on 11/27/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var foods = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.JSONFromURL("http://world.openfoodfacts.org/cgi/search.pl?search_terms=nutella&search_simple=1&action=process&json=1", callback: { (data) in
            
            self.foods = [Food]()
            
            let products = data["products"] as! NSArray
            
            for product in products {
                let p = product as! [String: AnyObject]
                let name = p["product_name"] as? String
                let brand = p["brands"] as? String
                let image = p["image_url"] as? String
                let grades = p["nutrition_grades_tags"] as! NSArray
                let grade = grades[0] as! String
                
                self.foods.append(Food(name: name!, brand: brand, thumbnail: image, nutritionGrade: grade))
            }
            
            DispatchQueue.main.async(){
                self.tableView.reloadData()
            }
            
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyworks = searchBar.text
        let urlKeyworkds = keyworks?.replacingOccurrences(of: " ", with: "+")
        
        DataService.JSONFromURL("http://world.openfoodfacts.org/cgi/search.pl?search_terms=\(urlKeyworkds!)&search_simple=1&action=process&json=1", callback: { (data) in
            
            self.foods = [Food]()
            
            let products = data["products"] as! NSArray
            
            for product in products {
                let p = product as! [String: AnyObject]
                let name = p["product_name"] as? String
                let brand = p["brands"] as? String
                let image = p["image_url"] as? String
                let grades = p["nutrition_grades_tags"] as? NSArray
                let grade = grades?[0] as? String
                
                self.foods.append(Food(name: name!, brand: brand, thumbnail: image, nutritionGrade: grade))
            }
            
            DispatchQueue.main.async(){
                self.tableView.reloadData()
            }
            
        })
        
        self.view.endEditing(true)
        
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodViewCell
        let food = foods[indexPath.row]
        
        cell.food = food
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "godetail" {
            let foodDetailViewController = segue.destination as! FoodDetailViewController
            if let selectedCell = sender as? FoodViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let selectedFood = foods[indexPath.row]
                foodDetailViewController.food = selectedFood
            }
            
        }
    }
    
    
}
