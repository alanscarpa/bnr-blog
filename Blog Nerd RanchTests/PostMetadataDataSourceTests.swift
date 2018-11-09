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
    
    //var mockPostMetadata = [PostMetadata]()
    
    override func setUp() {
        super.setUp()
        
        
        
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOrderWithNoPosts() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .byPublishDate(recentFirst: false))
        let dataSource = PostMetadataDataSource(ordering: ordering)
        
        XCTAssertEqual(dataSource.numberOfSections(), 1)
        XCTAssertNil(dataSource.titleForSection(0))
        XCTAssertEqual(dataSource.numberOfPostsInSection(0), 0)
    }
    
    func testAuthorOrderAtoZ() {
        let bob = Author.init(name: "Bob", imagePath: "", title: "Wizard")
        let jim = Author.init(name: "Jim", imagePath: "", title: "Knight")
        let amanda = Author.init(name: "Amanda", imagePath: "", title: "Priestess")
        
        let postMetadata1 = PostMetadata.init(title: "Bob's Post", publishDate: Date(), postId: "01", author: bob, summary: "Bob's post is enlightening.")
        let postMetadata2 = PostMetadata.init(title: "Jim's Post", publishDate: Date(), postId: "02", author: jim, summary: "Jim knows everything about everything.")
        let postMetadata3 = PostMetadata.init(title: "Amanda's Post", publishDate: Date(), postId: "03", author: amanda, summary: "Amanda is the master.")
        let mockPostMetadata = [postMetadata1, postMetadata2, postMetadata3]
        
        let ordering = DisplayOrdering(grouping: .none, sorting: .alphabeticalByAuthor(ascending: true))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: mockPostMetadata)
        
        XCTAssertEqual(dataSource.postMetadataList[1].author.name, "Bob")
        XCTAssertEqual(dataSource.postMetadataList[2].author.name, "Jim")
    }
}
