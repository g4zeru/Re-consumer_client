//
//  HeaderFactory.swift
//  NetworkLayer
//
//  Created by iniad on 2019/05/22.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

protocol HeaderFactory {
    func insert(request: URLRequest, header: [String: String]) -> URLRequest
}

class HeaderFactoryImpl: HeaderFactory {
    func insert(request: URLRequest, header: [String : String]) -> URLRequest {
        var request = request
        for item in header {
            request.addValue(item.value, forHTTPHeaderField: item.key)
        }
        return request
    }
}
