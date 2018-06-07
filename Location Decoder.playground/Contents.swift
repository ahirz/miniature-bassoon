
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension URL {
    func withQueries(_ queries: [String:String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
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
    
    var description: String {
        switch sublot {
        case " ":
            return "product: \(product), lot: \(lot), status: \(status), \(quantity), location: \(location)"
        default:
            return "product: \(product), lot: \(lot)-\(sublot ?? ""), status: \(status), \(quantity), location: \(location)"
        }
    }
}

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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: CodingKeys.id)
        self.site = try container.decode(String.self, forKey: CodingKeys.site)
    }
    
}

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
                completion(Location(id: items[0].pallet, site: items[0].site, items: items))
            } else {
                print("Either location data was not received, or the data was not properly decoded.")
                completion(nil)
                return
            }
        }
        task.resume()
    }
}

func fetchRawData(matching inputQuery: String, completion: @escaping (String?) -> Void) {
    
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
        if let data = data,
            let string = String(data: data, encoding: .utf8) {
            completion(string)
        } else {
            completion(nil)
            return
        }
    }
    task.resume()
}

var query = "OCOOKIL"

let locationLookup = LocationLookup()
locationLookup.fetchItems(matching: query) { (location) in
    print(location)
}

fetchRawData(matching: query) { (string) in
    print(string ?? "")
}
