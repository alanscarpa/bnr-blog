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

struct AllPostMetaDataRequest: NetworkRequest {
    var url : URL
    
    init(url: URL) {
        self.url = url
    }
    
    func load(completion: @escaping ([PostMetadata]?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, MetadataError.missingData)
                return
            }
            
            let metadataList : [PostMetadata]?
            let decoder = JSONDecoder();
            decoder.dateDecodingStrategy = .iso8601
            do {
                metadataList = try decoder.decode(Array.self, from: data)
            } catch {
                completion(nil, error)
                return
            }
            
            if let list = metadataList {
                completion(list, error)
            }
            
        }
        task.resume()
        return task
    }
}

protocol NetworkRequest {
    associatedtype Object
    var url : URL { get set }
    func load(completion: @escaping (Object?, Error?) -> Void) -> URLSessionDataTask
}

struct ImageRequest: NetworkRequest {
    var url : URL
    
    init(url: URL) {
        self.url = url
    }
    
    func load(completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, MetadataError.missingData)
                return
            }
            completion(UIImage(data: data), nil)
        }
        task.resume()
        return task
    }
}
