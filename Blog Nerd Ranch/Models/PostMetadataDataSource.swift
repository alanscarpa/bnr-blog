//
//  PostMetadataDataSource.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 9/3/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

/// Group & sort posts based on the given ordering.
struct PostMetadataDataSource {
    /// Represents a named group of posts. The nature of the group depends on the ordering it was created with
    private struct Group {
        let name : String?
        var postMetadata: [PostMetadata]
    }
    
    var ordering : DisplayOrdering {
        didSet {
            createGroups()
        }
    }
    var postMetadataList : [PostMetadata] {
        didSet {
            createGroups()
        }
    }
    
    private var groups: [Group] = []
    
    init(ordering: DisplayOrdering, postMetadata: [PostMetadata] = []) {
        self.ordering = ordering
        self.postMetadataList = postMetadata
        createGroups()
    }
    
    private mutating func createGroups() {
        // TODO: Group and sort the posts according to the `ordering` value.
        switch ordering.grouping {
        case .none:
            groups = [Group(name: "No Grouping", postMetadata: postMetadataList)]
        case .author:
            // todo can this be more stylish?
            let authorGroup = Dictionary(grouping: postMetadataList, by: { $0.author.name })
            var authorGroupArray = [Group]()
            authorGroup.forEach {
                authorGroupArray.append(Group(name: $0.key, postMetadata: $0.value))
            }
            groups = authorGroupArray.sorted { $0.name ?? "" < $1.name ?? "" }
        case .month:
            break
        }
    }
    
    // MARK: UICollectionViewDataSource convenience
    
    func numberOfSections() -> Int {
        return groups.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        return groups[section].name
    }
    
    func numberOfPostsInSection(_ section: Int) -> Int {
        return groups[section].postMetadata.count
    }
    
    func postMetadata(at indexPath: IndexPath) -> PostMetadata {
        return groups[indexPath.section].postMetadata[indexPath.row]
    }
 
    // MARK: Grouping
        
    // MARK: Sorting
    
}
