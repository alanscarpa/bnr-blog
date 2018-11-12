//
//  APIRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/11/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

protocol APIRequest: NetworkRequest {
    associatedtype Model: Codable
    func decode(_ data: Data) -> NetworkResult<Model>
}

extension APIRequest {
    func load(_ url: URL, completion: @escaping (NetworkResult<Model>) -> Void) -> URLSessionDataTask {
        let task = dataTask(with: url) { result in
            switch result {
            case .success(let data):
                completion(self.decode(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder();
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
