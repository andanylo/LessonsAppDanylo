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

    func testTableViewCell(){
//        sleep(1)
     
        
        XCTAssert(app.tables.cells.firstMatch.staticTexts["The Key To Success In iPhone Photography"].exists)
        XCTAssert(app.tables.cells.firstMatch.images.firstMatch.exists)
    }
    
    func testNavigation(){

//        sleep(1)
        app.tables.cells.firstMatch.tap()
        
        app.navigationBars.buttons["Lessons"].tap()
        
        app.tables.cells.element(boundBy: 2).tap()
        
        app.navigationBars.buttons["Lessons"].tap()
    }
    
    //Test detail view for first cell
    func testDetailView(){
    
//        sleep(1)
        app.tables.cells.firstMatch.tap()
        
        let title = "The Key To Success In iPhone Photography"
        let description = ""
        
        
        
        XCTAssert(app.staticTexts[title].exists)
        XCTAssert(app.buttons["Next lesson"].exists)
        
    }
    
    
    
    
}
