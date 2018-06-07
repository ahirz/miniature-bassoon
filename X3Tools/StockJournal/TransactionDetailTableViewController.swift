//
//  TransactionDetailTableViewController.swift
//  X3Tools
//
//  Created by Alex Hirzel on 6/4/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import UIKit

class TransactionDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var lotNumberLabel: UILabel!
    @IBOutlet weak var sublotNumberLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var documentLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    
    var transaction: Transaction?
    var pallet: Pallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // As long as an item exists, a static table will load data from it. The fields are all mapped and populated.
        
        if let transaction = transaction {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            itemNameLabel.text = transaction.product
            
            lotNumberLabel.text = transaction.lot
            sublotNumberLabel.text = transaction.sublot
            
            statusLabel.text = transaction.status
            
            if transaction.quantity > 0 {
                quantityLabel.text = "+\(transaction.quantity) \(transaction.units)"
                quantityLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            } else if transaction.quantity < 0 {
                quantityLabel.text = "\(transaction.quantity) \(transaction.units)"
                quantityLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            } else {
                quantityLabel.text = "\(transaction.quantity) \(transaction.units)"
            }
            
            timeLabel.text = dateFormatter.string(from: transaction.date)
            
            siteLabel.text = transaction.site
            locationLabel.text = transaction.location
            
            userLabel.text = transaction.user
            
            documentLabel.text = transaction.document
            typeLabel.text = transaction.type
            groupLabel.text = transaction.group
            
            print(transaction)
        }
    }

    
}
