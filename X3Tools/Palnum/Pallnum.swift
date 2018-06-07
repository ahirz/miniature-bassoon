//
//  Pallnum.swift
//  X3Tools
//
//  Created by Alex Hirzel on 5/1/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import Foundation

// Configure the data models required for Palnum.

struct Pallet {
    var id: String?
    var items: [Item] = []
    var transactions: [Transaction] = []
    
    enum CodingKeys: CodingKey {
        case id
    }
    // Different initializers for Palnum or Stock Journal queries
    init(id: String?) {
        self.id = id
    }
    
    init(id: String?, items: [Item]?) {
        self.id = id
        self.items = items!
    }
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
    
    init(id: String?, transactions: [Transaction]) {
        self.id = id
        self.transactions = transactions
    }
    
    init(id: String?, items: [Item]?, transactions: [Transaction]?) {
        self.id = id
        self.items = items!
        self.transactions = transactions!
    }
    
    //Initilization from decoder is not currently in use
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: CodingKeys.id)
    }
}

struct Item: CustomStringConvertible, Codable {
    
    var pallet: String
    var product: String
    var lot: String
    var sublot: String?
    var status: String
    var quantity: Double
    var units: String
    var expiration: Date
    var site: String
    var location: String
    
    //Map the structure properties to the JSON reply from the server
    enum CodingKeys: String, CodingKey {
        case pallet = "PALLET"
        case product = "ITEM"
        case lot = "LOT"
        case sublot = "SLO"
        case status = "STA"
        case quantity = "QTY"
        case units = "UNITS"
        case expiration = "EXP"
        case site = "SITE"
        case location = "LOC"
    }
    
    //Standard initializer
    init(pallet: String, product: String, lot: String, sublot: String?, status: String, quantity: Double, units: String, expiration: Date, site: String, location: String) {
        self.pallet = pallet
        self.product = product
        self.lot = lot
        self.sublot = sublot ?? ""
        self.status = status
        self.quantity = quantity
        self.units = units
        self.expiration = expiration
        self.site = site
        self.location = location
    }
    
    //Decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pallet = try container.decode(String.self, forKey: CodingKeys.pallet)
        self.product = try container.decode(String.self, forKey: CodingKeys.product)
        self.lot = try container.decode(String.self, forKey: CodingKeys.lot)
        self.sublot = try container.decodeIfPresent(String.self, forKey: CodingKeys.sublot)
        self.status = try container.decode(String.self, forKey: CodingKeys.status)
        self.quantity = try container.decode(Double.self, forKey: CodingKeys.quantity)
        self.units = try container.decode(String.self, forKey: CodingKeys.units)
        self.expiration = try container.decode(Date.self, forKey: CodingKeys.expiration)
        self.site = try container.decode(String.self, forKey: CodingKeys.site)
        self.location = try container.decode(String.self, forKey: CodingKeys.location)
    }
    
    //This allows Items to be returned as custom, formatted strings when printed to the console
    var description: String {
        switch sublot {
        case " ":
            return "product: \(product), lot: \(lot), status: \(status), \(quantity), location: \(location)"
        default:
            return "product: \(product), lot: \(lot)-\(sublot ?? ""), status: \(status), \(quantity), location: \(location)"
        }
    }
}

struct Transaction: Codable { 
    var pallet: String
    var product: String
    var lot: String
    var sublot: String?
    var status: String
    var quantity: Double
    var units: String
    var date: Date
    var site: String
    var location: String
    var user: String
    var document: String
    var type: String
    var group: String
    
    //Map the structure properties to the JSON reply from the server
    enum CodingKeys: String, CodingKey {
        case pallet = "PALLET"
        case product = "ITEM"
        case lot = "LOT"
        case sublot = "SLO"
        case status = "STA"
        case quantity = "QTY"
        case units = "UNITS"
        case date = "DATETIME"
        case site = "SITE"
        case location = "LOC"
        case user = "USR"
        case document = "DOC_NUM"
        case type = "TYPE"
        case group = "GRP"
    }
    
    //Standard initializer
    init(pallet: String, product: String, lot: String, sublot: String?, status: String, quantity: Double, units: String, date: Date, site: String, location: String, user: String, document: String, type: String, group: String) {
        self.pallet = pallet
        self.product = product
        self.lot = lot
        self.sublot = sublot ?? ""
        self.status = status
        self.quantity = quantity
        self.units = units
        self.date = date
        self.site = site
        self.location = location
        self.user = user
        self.document = document
        self.type = type
        self.group = group
    }
    
    //Decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pallet = try container.decode(String.self, forKey: CodingKeys.pallet)
        self.product = try container.decode(String.self, forKey: CodingKeys.product)
        self.lot = try container.decode(String.self, forKey: CodingKeys.lot)
        self.sublot = try container.decodeIfPresent(String.self, forKey: CodingKeys.sublot)
        self.status = try container.decode(String.self, forKey: CodingKeys.status)
        self.quantity = try container.decode(Double.self, forKey: CodingKeys.quantity)
        self.units = try container.decode(String.self, forKey: CodingKeys.units)
        self.date = try container.decode(Date.self, forKey: CodingKeys.date)
        self.site = try container.decode(String.self, forKey: CodingKeys.site)
        self.location = try container.decode(String.self, forKey: CodingKeys.location)
        self.user = try container.decode(String.self, forKey: CodingKeys.user)
        self.document = try container.decode(String.self, forKey: CodingKeys.document)
        self.type = try container.decode(String.self, forKey: CodingKeys.type)
        self.group = try container.decode(String.self, forKey: CodingKeys.group)
    }
    
    //This allows Transactions to be returned as custom, formatted strings when printed to the console
        var description: String {
            return "Lot: \(lot) \(quantity) from \(location), time: \(date)"
        }
}

