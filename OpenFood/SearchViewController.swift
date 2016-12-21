//
//  SearchViewController.swift
//  openfoodfacts
//
//  Created by MAFFINI Florian on 11/27/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var foods = [Food]()
    var navigationHairline: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for rootsubview in (self.navigationController?.navigationBar.subviews)! {
            for subview in rootsubview.subviews where subview is UIImageView
                                                                 && (subview as! UIImageView).image == self.navigationController?.navigationBar.shadowImage {
                self.navigationHairline = subview as! UIImageView
            }
        }
        
        FoodDataService.searchProducts("nutella", callback: { (products) in
            
            for product in products! {
                self.foods.append(Food.fromDictionnary(product))
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
        
        FoodDataService.searchProducts(keyworks!, callback: { (products) in
            
            self.foods = [Food]()
            
            for product in products! {
                self.foods.append(Food.fromDictionnary(product))
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodCell
        let food = foods[indexPath.row]
        
        cell.food = food
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "godetail" {
            let detailViewController = segue.destination as! DetailViewController
            if let selectedCell = sender as? FoodCell {
                
                // Disable page controller
                let pageViewController = self.navigationController?.parent as! UIPageViewController
                let pvc = pageViewController.delegate as! PageViewController
                pvc.disable()
                
                let indexPath = tableView.indexPath(for: selectedCell)!
                let selectedFood = foods[indexPath.row]
                detailViewController.food = selectedFood
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let pageViewController = self.navigationController?.parent as! UIPageViewController
        let pvc = pageViewController.delegate as! PageViewController
        pvc.enable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationHairline.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationHairline.isHidden = true
    }

}
