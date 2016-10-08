//
//  SurpriseMeUITests.swift
//  SurpriseMeUITests
//
//  Created by Evan Grossman on 10/7/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import XCTest

class SurpriseMeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchAndClose() {
        
        let app = XCUIApplication()
        let searchButton = app.buttons["BtSearch"]
        let closeButton = app.buttons["Close"]
        
        let searchCompletionPredicate = NSPredicate(format: "exists == true", argumentArray: nil)
        
        searchButton.tap()
        
        expectation(for: searchCompletionPredicate, evaluatedWith: closeButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        closeButton.tap()
        
        XCTAssert(searchButton.exists)
        
    }
    
    func textNoInternetWarning() {
        
    }
    
}
