//
//  APIRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation
// todo move this
import UIKit

protocol NetworkRequest {
    associatedtype Object
    func load(_ url: URL, completion: @escaping (NetworkResult<Object>) -> Void) -> URLSessionDataTask
}

extension NetworkRequest {
    fileprivate func dataTask(with url: URL, completion: @escaping (NetworkResult<Data>) -> Void) -> URLSessionDataTask {
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

struct AllPostMetaDataRequest: NetworkRequest {
    func load(_ url: URL, completion: @escaping (NetworkResult<[PostMetadata]?>) -> Void) -> URLSessionDataTask {
        let task = dataTask(with: url) { result in
            switch result {
            case .success(let data):
                let metadataList : [PostMetadata]?
                let decoder = JSONDecoder();
                decoder.dateDecodingStrategy = .iso8601
                do {
                    metadataList = try decoder.decode(Array.self, from: data)
                } catch {
                    completion(.failure(error))
                    return
                }
                completion(.success(metadataList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}

struct ImageRequest: NetworkRequest {
    func load(_ url: URL, completion: @escaping (NetworkResult<UIImage>) -> Void) -> URLSessionDataTask {
        let task = dataTask(with: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(BNRError.unableToDecodeData))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
