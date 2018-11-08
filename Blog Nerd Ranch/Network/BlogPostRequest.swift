//
//  BlogPostRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

struct BlogPostRequest: NetworkRequest {
    func load(_ url: URL, completion: @escaping (NetworkResult<Post>) -> Void) -> URLSessionDataTask {
        let task = dataTask(with: url) { result in
            switch result {
            case .success(let data):
                let post : Post?
                let decoder = JSONDecoder();
                decoder.dateDecodingStrategy = .iso8601
                do {
                    post = try decoder.decode(Post.self, from: data)
                } catch {
                    completion(.failure(error))
                    return
                }
                if let post = post {
                    completion(.success(post))
                } else {
                    completion(.failure(BNRError.nilObject))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
