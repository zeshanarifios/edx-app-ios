//
//  URL+PathExtension.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 20/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation

extension URL {
    
    var hostlessPath: String {
        guard let host = host else {
            return path
        }
        return "\(host)/\(path)"
    }
    
    var isValidAppURLScheme: Bool {
        return self.scheme ?? "" == DiscoverCatalog.appURLScheme ? true : false
    }
    
    var queryParameters: [String: Any]? {
        guard let queryString = query else {
            return nil
        }
        var queryParameters = [String: Any]()
        let parameters = queryString.components(separatedBy: "&")
        for parameter in parameters {
            let keyValuePair = parameter.components(separatedBy: "=")
            // Parameter will be ignored if invalid data for keyValuePair
            if keyValuePair.count == 2 {
                let key = keyValuePair[0]
                let value = keyValuePair[1]
                queryParameters[key] = value
            }
        }
        return queryParameters
    }
    
}
