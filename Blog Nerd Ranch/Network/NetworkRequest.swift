//
//  APIRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    associatedtype Object
    func load(_ url: URL, completion: @escaping (NetworkResult<Object>) -> Void) -> URLSessionDataTask
}

extension NetworkRequest {
    func dataTask(with url: URL, completion: @escaping (NetworkResult<Data>) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let data = data else {
                completion(.failure(BNRError.missingData))
                return
            }
            completion(.success(data))
        }
        task.resume()
        return task
    }
}
