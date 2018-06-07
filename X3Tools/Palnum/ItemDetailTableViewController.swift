//
//  ItemDetailTableViewController.swift
//  X3Tools
//
//  Created by Alex Hirzel on 5/1/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import UIKit

class ItemDetailTableViewController: UITableViewController {

    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var lotNumberLabel: UILabel!
    @IBOutlet weak var sublotNumberLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var expirationDateLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet var detailViewTable: UITableView!
    
    
    var item: Item?
    var pallet: Pallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // As long as an item exists, a static table will load data from it. The fields are all mapped and populated.
        
        if let item = item {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            itemNameLabel.text = item.product
            
            lotNumberLabel.text = item.lot
            sublotNumberLabel.text = item.sublot
            
            statusLabel.text = item.status
            
            quantityLabel.text = "\(item.quantity) \(item.units)"
            
            expirationDateLabel.text = dateFormatter.string(from: item.expiration)
            
            locationLabel.text = item.location
            
            print(item)
        }
    }
}
