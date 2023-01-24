//
//  LessonsAppDanyloTests.swift
//  LessonsAppDanyloTests
//
//  Created by Danil Andriuschenko on 23.01.2023.
//

import XCTest
@testable import LessonsAppDanylo

final class LessonsAppDanyloTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Test fetching and decoding JSON data from URL
    func testFetching() async throws{
        let mainViewModel = MainViewModel()
        let result = try await mainViewModel.fetchLessonsFromRemote()
        XCTAssert(!result.isEmpty)
    }
    
    //Test creating
    func testLessonCellViewModels() async throws{
        let mainViewModel = MainViewModel()
        let lessonsResult = try await mainViewModel.fetchLessonsFromRemote()
        XCTAssert(mainViewModel.lessons.count == mainViewModel.lessonCellViewModels.count)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
