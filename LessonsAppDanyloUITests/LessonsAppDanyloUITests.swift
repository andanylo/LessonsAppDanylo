//
//  LessonsAppDanyloUITests.swift
//  LessonsAppDanyloUITests
//
//  Created by Danil Andriuschenko on 23.01.2023.
//

import XCTest

final class LessonsAppDanyloUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
 
        continueAfterFailure = false
        app.launch()
    }
    
    //Test navigation title name
    func testNavigationTitle(){
        XCTAssert(app.navigationBars.staticTexts["Lessons"].exists)
    }

    //Test table view cell content
    func testTableViewCell(){
        
        XCTAssert(app.tables.cells.firstMatch.staticTexts["The Key To Success In iPhone Photography"].exists)
        XCTAssert(app.tables.cells.firstMatch.images.firstMatch.exists)
    }
    
    //Test navigation
    func testNavigation(){

        app.tables.cells.firstMatch.tap()
        
        app.navigationBars.buttons["Lessons"].tap()
        
        app.tables.cells.element(boundBy: 2).tap()
        
        app.navigationBars.buttons["Lessons"].tap()
    }
    
    //Test detail view for first cell
    func testDetailView(){
    
        app.tables.cells.firstMatch.tap()
        
        let title = "The Key To Success In iPhone Photography"
        
        XCTAssert(app.staticTexts[title].exists)
        XCTAssert(app.buttons["Next lesson"].exists)
        XCTAssert(app.buttons["Download"].exists)
        
    }
    
    //Test next button presentation
    func testNextLessonDetailScreen(){
        app.tables.cells.firstMatch.tap()
        
        app.buttons["Next lesson"].tap()
        
        let nextTitle = "How To Choose The Correct iPhone Camera Lens"
        
        XCTAssert(app.staticTexts[nextTitle].exists)
    }
    
    //Test downloading view appearance
    func testDownloadingView(){
        app.tables.cells.firstMatch.tap()
        
        app.buttons["Download"].tap()
        
        XCTAssert(app.progressIndicators.firstMatch.exists)
        XCTAssert(app.activityIndicators.firstMatch.exists)
        
        app.buttons["Cancel downloading"].tap()
    }
    
    
}
