//
//  PalnumTransactionTableViewCell.swift
//  X3Tools
//
//  Created by Alex Hirzel on 6/1/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import UIKit

class StockJournalTableViewCell: UITableViewCell {

    @IBOutlet weak var lotLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Function for updating a custom Stock Journal cell with item information
    func update(with transaction: Transaction) {
        if transaction.lot != " " {
            if transaction.sublot == " " || transaction.sublot == nil{
                lotLabel.text = "Lot: \(transaction.lot)"
            } else {
                lotLabel.text = "Lot: \(transaction.lot) - \(transaction.sublot ?? "")"
            }
        } else {
            lotLabel.text = "Lot: N/A"
        }
        
        if transaction.quantity > 0 {
            quantityLabel.text = "+\(transaction.quantity) \(transaction.units)"
            quantityLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else if transaction.quantity < 0 {
            quantityLabel.text = "\(transaction.quantity) \(transaction.units)"
            quantityLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else {
            quantityLabel.text = "\(transaction.quantity) \(transaction.units)"
        }
        
        locationLabel.text = transaction.location
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy HH:mm"
        let time = dateFormatter.string(from: transaction.date)
        timeLabel.text = time
        
    }

}
