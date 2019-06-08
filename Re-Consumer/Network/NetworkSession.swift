//
//  Network.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

public protocol NetworkSessionDelegate: class {
    func responce(json: Data)
    func responce(error: Error)
}

public class NetworkSession {
    let network: NetworkFactory
    let header: HeaderFactory
    let parameter: ParameterFactory
    let query:  QueryParameterFactory
    
    let cachePolicy: URLRequest.CachePolicy
    let timeoutInterval: TimeInterval
    
    public weak var delegate: NetworkSessionDelegate?
    
    private(set) var model: RequestModel
    
    public convenience init(model: RequestModel,
                            timeoutInterval: TimeInterval = 30,
                            cachePolicy: URLRequest.CachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData) {
        self.init(model: model,
                  timeoutInterval: timeoutInterval,
                  cachePolicy: cachePolicy,
                  network: NetworkFactoryImpl(),
                  header: HeaderFactoryImpl(),
                  parameter: ParameterFactoryImpl(),
                  query: QueryParameterFactoryImpl())
    }
    
    init(model: RequestModel,
         timeoutInterval: TimeInterval,
         cachePolicy: URLRequest.CachePolicy,
         network: NetworkFactory,
         header: HeaderFactory,
         parameter: ParameterFactory,
         query: QueryParameterFactory) {
        self.model = model
        self.network = network
        self.header = header
        self.parameter = parameter
        self.query = query
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }
    
    public func updateModel(model: RequestModel) {
        self.model = model
    }
    
    public func startSession() {
        do {
            let request = try buildURLRequest()
            print(request.url)
            network.session(request: request) { [weak self] (responce) in
                self?.assignNetworkResponce(responce: responce)
            }
        } catch {
            return
        }
    }
    
    func assignNetworkResponce(responce: Result<Data, Error>) {
        switch responce {
        case .success(let json):
            self.delegate?.responce(json: json)
        case .failure(let error):
            self.delegate?.responce(error: error)
        }
    }
    
    func buildURLRequest() throws -> URLRequest {
        var request = try generateURLRequest(model: self.model)
        request.httpMethod = self.model.method.rawValue
        request.httpBody = try parameter.generate(prameter: self.model.parameters)
        request = header.insert(request: request, header: self.model.headers)
        return request
    }
    
    func generateURLRequest(model: RequestModel) throws -> URLRequest {
        let queryParameter = query.generate(query: model.query)
        let urlStrings = model.domain + model.path + (queryParameter.isEmpty ? "" : "?" + queryParameter)
        guard let url = URL(string: urlStrings) else {
            throw NetworkError.undefined
        }
        return URLRequest(url: url, cachePolicy: self.cachePolicy, timeoutInterval: self.timeoutInterval)
    }
}
