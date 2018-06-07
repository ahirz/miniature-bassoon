//
//  StockJournalTableViewController.swift
//  X3Tools
//
//  Created by Alex Hirzel on 6/1/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import UIKit

class StockJournalTableViewController: UITableViewController {
    
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
            
            for transaction in pallet.transactions {
                if !sections.contains(transaction.product) {
                    sections.append(transaction.product)
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
        let rows = pallet.transactions.filter { (item) -> Bool in
            return item.product == sections[section]
        }
        
        return rows.count
    }
    
    //Generate the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockJournalCell", for: indexPath) as! StockJournalTableViewCell
        
        let rows = pallet.transactions.filter { (item) -> Bool in
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
    
    // Set the information for the Transaction Detail view when tapping on a row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TransactionDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let transaction = pallet.transactions[indexPath.row]
            let detailView = segue.destination as? TransactionDetailTableViewController
            detailView?.pallet = pallet
            detailView?.transaction = transaction
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
            palnum.fetchTransactions(matching: query) { (pallet) in
                if let pallet = pallet {
                    self.pallet = pallet
                    DispatchQueue.main.async {
                        self.palletID.title = self.pallet.id
                    }
                } else {
                    self.palletID.title = "Unit not found"
                }
            }
        } else {
            palletID.title = "Stock Journal Search"
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
