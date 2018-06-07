//
//  LocationModel.swift
//  X3Tools
//
//  Created by Alex Hirzel on 6/4/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import Foundation

// Configure the data models required for Location.
struct Location: Codable {
    var id: String?
    var site: String
    var items: [Item] = []
    
    enum CodingKeys: String, CodingKey {
        case id = "LOCATION"
        case site = "SITE"
    }
    
    init?(id: String, site: String, items: [Item]) {
        self.id = id
        self.site = site
        self.items = items
    }
    
    //Initilization from decoder is not currently in use
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: CodingKeys.id)
        self.site = try container.decode(String.self, forKey: CodingKeys.site)
    }
}

//The LocationLookup class is used to store functions for collecting pallet data from the server. These could probalby be moved into the Location structure, but they work fine here
class LocationLookup {
    func fetchItems(matching inputQuery: String, completion: @escaping (Location?) -> Void) {
        let baseURL = URL(string: "http://web.hirzel.local/X3%20Tools/X3_V9_LOCATION_JSON_RET.php?")!
        
        let query: [String:String] = [
            "f":inputQuery
        ]
        
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            if let data = data,
                let items = try? jsonDecoder.decode([Item].self, from: data) {
                completion(Location(id: items[0].location, site: items[0].site, items: items))
            } else {
                print("Either location data was not received, or the data was not properly decoded.")
                completion(nil)
                return
            }
        }
        task.resume()
    }
}
