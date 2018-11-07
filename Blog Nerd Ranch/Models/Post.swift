//
//  Post.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

struct Post : Codable {
    let id : String
    let body : String
    var metadata : PostMetadata
}
