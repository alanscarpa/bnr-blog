//
//  APIRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

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
