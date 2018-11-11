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
    
    private var postMetadataList : [PostMetadata] {
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
    
    mutating func set(postMetadataList: [PostMetadata]) {
        self.postMetadataList = postMetadataList
    }

    private mutating func createGroups() {
        switch ordering.grouping {
        case .none:
            groups = [Group(name: nil, postMetadata: postMetadataList)]
        case .author:
            let authorGrouping = Dictionary(grouping: postMetadataList, by: { $0.author.name })
            groups = groups(fromGrouping: authorGrouping, sortedBy: { $0.name ?? "" < $1.name ?? "" })
        case .month:
            let monthGrouping = Dictionary(grouping: postMetadataList, by: {
                DateHandler.shared.monthString(fromDate: $0.publishDate)
            })
            groups = groups(fromGrouping: monthGrouping, sortedBy: { DateHandler.shared.date(fromMonthString: $0.name ?? "") > DateHandler.shared.date(fromMonthString: $1.name ?? "") })
        }
        
        switch ordering.sorting {
        case .alphabeticalByTitle(let ascending):
            sortGroupsMetadata { ascending ? $0.title < $1.title : $0.title > $1.title }
        case .alphabeticalByAuthor(let ascending):
            sortGroupsMetadata { ascending ? $0.author.name < $1.author.name : $0.author.name > $1.author.name }
        case .byPublishDate(let recentFirst):
            sortGroupsMetadata { recentFirst ? $0.publishDate > $1.publishDate : $0.publishDate < $1.publishDate }
        }
    }
    
    // MARK: Grouping
    
    private func groups(fromGrouping grouping: Dictionary<String, [PostMetadata]>, sortedBy sorter: (PostMetadataDataSource.Group, PostMetadataDataSource.Group) -> Bool) -> [Group] {
        return grouping.map({ Group(name: $0.key, postMetadata: $0.value) }).sorted(by: sorter)
    }
    
    // MARK: Sorting
    
    private mutating func sortGroupsMetadata(_ sorter: (PostMetadata, PostMetadata) -> Bool) {
        for (index, group) in groups.enumerated() {
            groups[index].postMetadata = group.postMetadata.sorted(by: sorter)
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
    
}
