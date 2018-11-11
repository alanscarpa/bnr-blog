//
//  APIRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/11/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

protocol APIRequest {
    associatedtype Model: Codable
    func decode(_ data: Data) -> NetworkResult<Model>
}

extension APIRequest {
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder();
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
