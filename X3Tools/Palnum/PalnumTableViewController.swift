//
//  PalnumTableViewController.swift
//  X3Tools
//
//  Created by Alex Hirzel on 5/1/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import UIKit

class PalnumTableViewController: UITableViewController {

    var pallet: Pallet!
    
    var query: String!
    
    var sections: [String] = []
    
    @IBOutlet weak var palletID: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    //Find the unique items in a pallet and add them to the sections array
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let pallet = pallet {
            
            for item in pallet.items {
                if !sections.contains(item.product) {
                    sections.append(item.product)
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
    
    //Find items on the pallet that match each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows = pallet.items.filter { (item) -> Bool in
            return item.product == sections[section]
        }
        
        return rows.count
    }
    
    //Generate the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PalnumCell", for: indexPath) as! PalnumTableViewCell

        let rows = pallet.items.filter { (item) -> Bool in
            return item.product == sections[indexPath.section]
        }

        let item = rows[indexPath.row]

        cell.update(with: item)

        return cell
    }
    
    //When the view is going to appear, try to update the Pallet ID
    override func viewWillAppear(_ animated: Bool) {
        self.updatePalletID()
    }
    
    // After the view appears, reload the table data. This ensures enough time for updated data to be processed
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    // Set the information for the Item Detail view when tapping on a row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let item = pallet.items[indexPath.row]
            let detailView = segue.destination as? ItemDetailTableViewController
            detailView?.pallet = pallet
            detailView?.item = item
            detailView?.title = pallet.id
        }
    }
    
    // MARK: - Functions
    
    // Query the server with a user provided query and return the pallet
    func updatePalletID() {
        if let query = query {
            sections = []
            palletID.title = "Loading"
            let palnum = Palnum()
            palnum.fetchItems(matching: query) { (pallet) in
                if let pallet = pallet {
                    self.pallet = pallet
                    DispatchQueue.main.async {
                        self.palletID.title = pallet.id
                    }
                    
                } else {
                    self.palletID.title = "Unit not found"
                }
            }
        } else {
            self.palletID.title = "Pallet Search"
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
