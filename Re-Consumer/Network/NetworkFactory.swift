//
//  NetworkFactory.swift
//  NetworkLayer
//
//  Created by iniad on 2019/05/22.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

protocol NetworkFactory {
    func session(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkFactoryImpl: NetworkFactory {
    func session(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task: URLSessionDataTask = generateSessionDataTask(request: request, completion: completion)
        task.resume()
    }
    
    private func generateSessionDataTask(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) {(data, response, error) in
            print(response)
            print(error)
            if let error = error {
                completion(.failure(NetworkErrorGenerator(error: error as NSError).generate()))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.undefined))
                return
            }
            
            completion(.success(data))
        }
    }
}
