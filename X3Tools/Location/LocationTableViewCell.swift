//
//  LocationTableViewCell.swift
//  X3Tools
//
//  Created by Alex Hirzel on 6/4/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var lotLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func update(with item: Item) {
        itemLabel.text = item.product
        
        //Function for updating a custom Location cell with item information
        if item.lot != " " {
            if item.sublot == " " || item.sublot == nil{
                lotLabel.text = "Lot: \(item.lot)"
            } else {
                lotLabel.text = "Lot: \(item.lot) - \(item.sublot ?? "")"
            }
        } else {
            lotLabel.text = "Lot: N/A"
        }
        
        quantityLabel.text = "\(item.quantity) \(item.units)"
    }

}
