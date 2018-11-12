//
//  BlogPostRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

struct BlogPostRequest: APIRequest {
    func decode(_ data: Data) -> NetworkResult<Post> {
        let post : Post?
        do {
            post = try decoder().decode(Post.self, from: data)
        } catch {
            return .failure(error)
        }
        if let post = post {
            return .success(post)
        } else {
            return .failure(BNRError.nilObject)
        }
    }
}
