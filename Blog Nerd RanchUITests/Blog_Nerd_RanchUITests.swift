//
//  Blog_Nerd_RanchUITests.swift
//  Blog Nerd RanchUITests
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import XCTest

class Blog_Nerd_RanchUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatTappingGroupByButtonPresentsAlertController() {
        let blogPostsNavigationBar = app.navigationBars["Blog Posts"]
        blogPostsNavigationBar.buttons["Group By"].tap()
        let sheetsQuery = app.sheets
        print(app.sheets["Grouping Options"].exists)
        XCTAssert(sheetsQuery.staticTexts["Group the posts by..."].exists)
    }
    
    func testThatTappingSortButtonPresentsAlertController() {
        let blogPostsNavigationBar = app.navigationBars["Blog Posts"]
        blogPostsNavigationBar.buttons["Sort"].tap()
        let sheetsQuery = app.sheets
        
        XCTAssert(sheetsQuery.staticTexts["Sort the posts by..."].exists)
    }
    
    func testThatTappingOnAMetadataCellShowsThatPost() {
        let firstCell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        let titleText = firstCell.staticTexts.element(matching: .any, identifier: "Post Title").label
        firstCell.tap()
        let postDetailTitle = app.scrollViews.otherElements.staticTexts.element(matching: .any, identifier: "Post Title").label
        
        XCTAssertEqual(titleText, postDetailTitle)
    }
    
}
