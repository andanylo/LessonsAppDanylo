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
        let _ = try await mainViewModel.fetchLessonsFromRemote()
        XCTAssert(mainViewModel.lessons.count == mainViewModel.lessonCellViewModels.count)
    }
    
    //Test loading thumbnail
    func testLoadingThumbnail() async throws{
        let exampleLesson = Lesson(id: 0, name: "Test", description: "Test", thumbnail: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560", video_url: "Test")
        let lessonCellViewModel = LessonCellViewModel(lesson: exampleLesson)
        let thumbnailImage = try await lessonCellViewModel.asyncLoadThumnnailImage(from: exampleLesson.thumbnail)
        
        XCTAssert(thumbnailImage.size != CGSize.zero)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
