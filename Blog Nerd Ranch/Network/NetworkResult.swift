//
//  NetworkResult.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case failure(Error)
}
