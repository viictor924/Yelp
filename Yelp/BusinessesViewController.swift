//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate  {
    
    
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var filteredData: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Restaurants"
        
        navigationItem.titleView = searchBar
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredData = self.businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    
                    print(business.name!)
                    print(business.address!)
                }
                
            }
            
        }
        )
        
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredData != nil{
            return filteredData!.count
        }
        
        else if businesses != nil{
            return businesses!.count
        }
        else {return 0}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
       // cell.business = businesses[indexPath.row]
        cell.business = filteredData[indexPath.row]
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Bar text did change")
        self.searchBar.showsCancelButton = true
        
        //I don't understand how this block of code does what it does
        //=============================================================
        filteredData = searchText.isEmpty ? businesses : businesses.filter{ (item: Business) -> Bool in
            return item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        //=============================================================
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search Bar text did end editing")
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Search Bar cancel button was clicked")
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
     }
 
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        let dealsIsOn = filters["deals"] as? Bool
        let distance = filters["distance"] as? Double
        let sortMode = filters["sortMode"] as? YelpSortMode
 
         Business.searchWithTerm(term: "Restaurants", sort: sortMode, categories: categories, deals: dealsIsOn) { (businesses: [Business]?, error: Error?) -> Void in
         self.businesses = businesses
            // /*
            self.filteredData = distance == nil ? self.businesses :self.businesses?.filter {
                (item: Business) -> Bool in
                let strArr = item.distance?.components(separatedBy: " ")
                let dist = Double(strArr![0])
                return dist! < distance!
            }
            // */
            print("reloading table")
         self.tableView.reloadData()
         }
    }
    
}
