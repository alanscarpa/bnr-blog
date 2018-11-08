//
//  Author.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

struct Author: Codable {
    let name : String
    let imagePath : String
    let title : String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imagePath = "image"
        case title
    }
}
