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

struct SimplePalnum: Codable {
    let results: [SimpleItem]
}

struct SimpleItem: Codable {
    var product: String
    
    enum CodingKeys: String, CodingKey {
        case product = "ITEM"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        product = try container.decode(String.self, forKey: CodingKeys.product)
    }
    
}

class Pallet {
    var id: String
    var items: [Item] = []
    var transactions: [Transaction] = []
    
    init(id: String, items: [Item]) {
        self.id = id
        self.items = items
    }
    
    enum CodingKeys: CodingKey {
        case id
    }
    
    enum PalnumDataItem {
        case items
        case transactions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: CodingKeys.id)
    }
    
    func buildModel() -> [Any] {
        return [items, transactions]
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
//    var type: String
//    var group: String
    
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
//        case type = "TYPE"
//        case group = "GRP"
    }
    
    init(pallet: String, product: String, lot: String, sublot: String?, status: String, quantity: Double, units: String, date: Date, site: String, location: String, user: String, document: String) { //, type: String, group: String
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
//        self.type = type
//        self.group = group
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
        self.date = try container.decode(Date.self, forKey: CodingKeys.date)
        self.site = try container.decode(String.self, forKey: CodingKeys.site)
        self.location = try container.decode(String.self, forKey: CodingKeys.location)
        self.user = try container.decode(String.self, forKey: CodingKeys.user)
        self.document = try container.decode(String.self, forKey: CodingKeys.document)
//        self.type = try container.decode(String.self, forKey: CodingKeys.type)
//        self.group = try container.decode(String.self, forKey: CodingKeys.group)
    }
    
//    var description: String {
//        return "Lot: \(lot) \(quantity) from \(location), time: \(date ?? Date())"
//    }
}

//var palletID: String = "AH8100C39"
//
//let baseURL = URL(string: "http://10.1.5.35/X3%20Tools/X3_V9_PALNUM_JSON_RET.php?")!
//
//var query: [String:String] = [
//    "f":palletID
//]
//
//let url = baseURL.withQueries(query)!


// Print raw output from query
//let rawData = URLSession.shared.dataTask(with: url) { (data, response, error) in
//    if let data = data,
//        let string = String(data: data, encoding: .utf8) {
//        print(string)
//    }
//}
//rawData.resume()

//let rawData = getRawData.resume()
//
//print(rawData)
//
//let decodeTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
//    let jsonDecoder = JSONDecoder()
//    if let data = data,
//        let palnum = try? jsonDecoder.decode(Palnum.self, from: data) {
//        palnum.results
//        print(palnum)
//    } else {
//        print("Either data was not received, or the data was not properly decoded")
//    }
//}

func fetchRawData(matching inputQuery: String, completion: @escaping (String?) -> Void) {
    
    let baseURL = URL(string: "http://web.hirzel.local/X3%20Tools/X3_V9_PALNUM_JSON_RET.php?")!
    
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
        print(url)
        
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
    
    func fetchTransactions(matching inputQuery: String, completion: @escaping ([Transaction]?) -> Void) {
        
        let baseURL = URL(string: "http://web.hirzel.local/X3%20Tools/X3_V9_STOJOU_JSON_RET.php?")!
        
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
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            if let data = data,
                let items = try? jsonDecoder.decode([Transaction].self, from: data) {
                completion(items)
            } else {
                print("Either data was not received, or the data was not properly decoded")
                completion(nil)
                return
            }
        }
        task.resume()
    }
}


//fetchRawData(matching: "AH8100C38") { (items) in
//    if let items = items {
//        rawData = items
//        print(rawData)
//    }
//}
//
//fetchItems(matching: "AH8100C39") { (items) in
//    if let items = items {
//        print(items)
//    }
//}
//
//fetchItems(matching: "AU8051051") { (items) in
//    if let items = items {
//        print(items)
//    }
//}


var palnum = Palnum()
var pallet: Pallet!

palnum.fetchItems(matching: "CU8144006") { (items) in
    if let items = items {
        print(items)
        pallet = items
    }
}
//
//palnum.fetchTransactions(matching: "CU8144006") { (items) in
//    if let items = items {
//        print("\(Date()) \(items)")
//        pallet.transactions = items
//    }
//}

fetchRawData(matching: "CU8144006") { (string) in
    print(string ?? "")
}

