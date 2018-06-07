//
//  PalnumController.swift
//  X3Tools
//
//  Created by Alex Hirzel on 5/24/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import Foundation

//The Palnum class is used to store functions for collecting pallet data from the server. These could probalby be moved into the Pallet structure, but they work fine here

class Palnum {
    
    func fetchItems(matching inputQuery: String, completion: @escaping (Pallet?) -> Void) {
        
        let baseURL = URL(string: "http://web.hirzel.local/X3%20Tools/X3_V9_PALNUM_JSON_RET.php?")!
        
        let query: [String:String] = [
            "f":inputQuery
        ]
        
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            if let data = data,
                let items = try? jsonDecoder.decode([Item].self, from: data) {
                completion(Pallet(id: items[0].pallet, items: items))
            } else {
                print("Either data was not received, or the data was not properly decoded")
                completion(nil)
                return
            }
        }
        task.resume()
    }
    
    func fetchTransactions(matching inputQuery: String, completion: @escaping (Pallet?) -> Void) {
        
        let baseURL = URL(string: "http://web.hirzel.local/X3%20Tools/X3_V9_STOJOU_JSON_RET.php?")!
        
        let query: [String:String] = [
            "f":inputQuery
        ]
        
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            if let data = data,
                let transactions = try? jsonDecoder.decode([Transaction].self, from: data) {
                completion(Pallet(id: transactions[0].pallet, transactions: transactions))
            } else {
                print("Either data was not received, or the data was not properly decoded")
                completion(nil)
                return
            }
        }
        task.resume()
    }
}

var int: Int {
    return 8
}
