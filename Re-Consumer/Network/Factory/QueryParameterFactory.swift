//
//  QueryFactory.swift
//  NetworkLayer
//
//  Created by iniad on 2019/05/22.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

protocol QueryParameterFactory {
    func generate(query: [String: String]) -> String
}

class QueryParameterFactoryImpl: QueryParameterFactory {
    func generate(query: [String : String]) -> String {
        let queryParameters: [String] = query.map { (query) -> String in
            return joinKeyAndValueWithEqual(key: query.key, value: query.value)
        }
        return queryParameters.joined(separator: "&")
    }
    private func joinKeyAndValueWithEqual(key: String, value: String) -> String {
        return key + "=" + value
    }
}
