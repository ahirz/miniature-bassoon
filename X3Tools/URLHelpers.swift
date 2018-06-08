//
//  URLHelpers.swift
//  X3Tools
//
//  Created by Alex Hirzel on 5/24/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String:String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
