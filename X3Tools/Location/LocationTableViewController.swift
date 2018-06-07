//
//  LocationTableViewController.swift
//  X3Tools
//
//  Created by Alex Hirzel on 6/4/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {

    @IBOutlet weak var locationID: UINavigationItem!
    
    var location: Location!
    
    var query: String!
    
    var sections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    //Find the unique pallets in a location and add them to the sections array
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let location = location {
            
            for item in location.items {
                if !sections.contains(item.pallet) {
                    sections.append(item.pallet)
                }
            }
            
            return sections.count
        } else {
            return 0
        }
    }

    //Create and format headers for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.textColor = UIColor.black
    }
    
    //Find pallets in the location that match each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows = location.items.filter { (item) -> Bool in
            return item.pallet == sections[section]
        }
        
        return rows.count
    }

    //Generate the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
        
        let rows = location.items.filter { (item) -> Bool in
            return item.pallet == sections[indexPath.section]
        }
        
        let item = rows[indexPath.row]
        
        cell.update(with: item)
        
        return cell
    }
 
    //When the view is going to appear, try to update the Location ID
    override func viewWillAppear(_ animated: Bool) {
        self.updateLocationID()
    }

    // After the view appears, reload the table data. This ensures enough time for updated data to be processed
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    // Set the information for the Palnum view when tapping on a pallet row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getPalnum" {
            let indexPath = tableView.indexPathForSelectedRow!
            let item = location.items[indexPath.row]
            let palnumView = segue.destination as? PalnumTableViewController
            let query = item.pallet
            palnumView?.query = query
        }
    }
    
    // MARK: - Functions
    
    // Query the server with a user provided query and return the location
    func updateLocationID() {
        if let query = query {
            sections = []
            self.locationID.title = "Loading"
            let location = LocationLookup()
            location.fetchItems(matching: query) { (location) in
                if let location = location {
                    self.location = location
                    DispatchQueue.main.async {
                        self.locationID.title = location.id
                    }
                } else {
                    self.locationID.title = "Location not found"
                }
            }
        } else {
            locationID.title = "Location Search"
        }
    }
    
    // MARK: - Interface actions
    
    //Return the query from the search view
    @IBAction func unwindToSearchTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "getBarcode" else { return }
        
        let sourceViewController = segue.source as! ScannerViewController
        
        query = sourceViewController.query
        
    }
    
}
