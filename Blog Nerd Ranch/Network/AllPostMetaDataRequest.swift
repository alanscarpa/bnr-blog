//
//  APIRequest.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

struct AllPostMetaDataRequest: APIRequest {    
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
