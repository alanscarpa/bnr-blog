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
                let sortedPostMetadata = $0.value.sorted(by: { (pm1, pm2) -> Bool in
                    pm1.publishDate > pm2.publishDate
                })
                authorGroupArray.append(Group(name: $0.key, postMetadata: sortedPostMetadata))
            }
            groups = authorGroupArray.sorted { $0.name ?? "" < $1.name ?? "" }
        case .month:
            // todo can this be more stylish?
            let monthGroup = Dictionary(grouping: postMetadataList, by: {
                DateHandler.shared.monthString(fromDate: $0.publishDate)
            })
            var monthGroupArray = [Group]()
            monthGroup.forEach {
                let sortedPostMetadata = $0.value.sorted(by: { (pm1, pm2) -> Bool in
                    pm1.publishDate > pm2.publishDate
                })
                monthGroupArray.append(Group(name: $0.key, postMetadata: sortedPostMetadata))
            }
            groups = monthGroupArray.sorted { DateHandler.shared.date(fromMonthString: $0.name!) > DateHandler.shared.date(fromMonthString: $1.name!) }
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
