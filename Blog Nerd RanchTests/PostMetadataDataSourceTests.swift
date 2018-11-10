//
//  PostMetadataDataSourceTests.swift
//  Blog Nerd RanchTests
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import XCTest
@testable import Blog_Nerd_Ranch

class PostMetadataDataSourceTests: XCTestCase {
    
    var postMetadataList = [PostMetadata]()
    
    override func setUp() {
        super.setUp()
        let bob = Author.init(name: "Bob", imagePath: "", title: "Wizard")
        let jim = Author.init(name: "Jim", imagePath: "", title: "Knight")
        let amanda = Author.init(name: "Amanda", imagePath: "", title: "Priestess")
        
        let postMetadata1 = PostMetadata.init(title: "Bob's Post", publishDate: DateHandler.shared.date(fromMonthString: "January"), postId: "01", author: bob, summary: "Bob's post is enlightening.")
        let postMetadata2 = PostMetadata.init(title: "Jim's Post", publishDate: DateHandler.shared.date(fromMonthString: "February"), postId: "02", author: jim, summary: "Jim knows everything about everything.")
        let postMetadata3 = PostMetadata.init(title: "Amanda's Post", publishDate: DateHandler.shared.date(fromMonthString: "March"), postId: "03", author: amanda, summary: "Amanda is the master.")
        postMetadataList = [postMetadata1, postMetadata2, postMetadata3]
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - No Posts
    
    func testOrderWithNoPosts() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .byPublishDate(recentFirst: false))
        let dataSource = PostMetadataDataSource(ordering: ordering)
        
        XCTAssertEqual(dataSource.numberOfSections(), 1)
        XCTAssertNil(dataSource.titleForSection(0))
        XCTAssertEqual(dataSource.numberOfPostsInSection(0), 0)
    }
    
    // MARK: - Sorting
    
    func testSortAuthorAtoZ() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .alphabeticalByAuthor(ascending: true))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 0, section: 0)).author.name, "Amanda")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 1, section: 0)).author.name, "Bob")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 2, section: 0)).author.name, "Jim")
    }
    
    func testSortAuthorZtoA() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .alphabeticalByAuthor(ascending: false))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 0, section: 0)).author.name, "Jim")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 1, section: 0)).author.name, "Bob")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 2, section: 0)).author.name, "Amanda")
    }
    
    func testSortTitleAtoZ() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .alphabeticalByTitle(ascending: true))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 0, section: 0)).title, "Amanda's Post")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 1, section: 0)).title, "Bob's Post")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 2, section: 0)).title, "Jim's Post")
    }
    
    func testSortTitleZtoA() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .alphabeticalByTitle(ascending: false))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 0, section: 0)).title, "Jim's Post")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 1, section: 0)).title, "Bob's Post")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 2, section: 0)).title, "Amanda's Post")
    }
    
    func testSortChronologically() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .byPublishDate(recentFirst: false))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 0, section: 0)).title, "Bob's Post")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 1, section: 0)).title, "Jim's Post")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 2, section: 0)).title, "Amanda's Post")
    }
    
    func testSortRecentFirst() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .byPublishDate(recentFirst: true))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 0, section: 0)).title, "Amanda's Post")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 1, section: 0)).title, "Jim's Post")
        XCTAssertEqual(dataSource.postMetadata(at: IndexPath(item: 2, section: 0)).title, "Bob's Post")
    }
    
    // MARK: - Grouping
    
    func testGroupNone() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .byPublishDate(recentFirst: false))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.numberOfSections(), 1)
        XCTAssertNil(dataSource.titleForSection(0))
    }
    
    func testGroupByAuthor() {
        let ordering = DisplayOrdering(grouping: .author, sorting: .byPublishDate(recentFirst: false))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.titleForSection(0), "Amanda")
        XCTAssertEqual(dataSource.titleForSection(1), "Bob")
        XCTAssertEqual(dataSource.titleForSection(2), "Jim")
    }
    
    func testGroupByMonth() {
        let ordering = DisplayOrdering(grouping: .month, sorting: .byPublishDate(recentFirst: false))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: postMetadataList)
        
        XCTAssertEqual(dataSource.titleForSection(0), "March")
        XCTAssertEqual(dataSource.titleForSection(1), "February")
        XCTAssertEqual(dataSource.titleForSection(2), "January")
    }

}
