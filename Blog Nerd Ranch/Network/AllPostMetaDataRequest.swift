//
//  APIRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

struct AllPostMetaDataRequest: APIRequest, NetworkRequest {
    func load(_ url: URL, completion: @escaping (NetworkResult<[PostMetadata]>) -> Void) -> URLSessionDataTask {
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
    
    func decode(_ data: Data) -> NetworkResult<[PostMetadata]> {
        let metadataList : [PostMetadata]?
        do {
            metadataList = try self.decoder().decode(Array.self, from: data)
        } catch {
            return .failure(error)
        }
        if let metadataList = metadataList {
            return .success(metadataList)
        } else {
            return .failure(BNRError.nilObject)
        }
    }
}
