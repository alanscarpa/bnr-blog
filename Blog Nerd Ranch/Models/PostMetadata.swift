//
//  PostMetadata.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

struct PostMetadata : Codable {
    let title : String
    let publishDate : Date
    let postId : String
    let author : String
    let summary : String
}
