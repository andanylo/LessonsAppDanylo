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
    
    //Test creating cell view models
    func testLessonCellViewModels() async throws{
        let mainViewModel = MainViewModel()
        let _ = try await mainViewModel.fetchLessonsFromRemote()
        XCTAssert(mainViewModel.lessons.count == mainViewModel.lessonCellViewModels.count)
    }
    
    //Test creating detail view models
    func testDetailViewModels() async throws{
        let mainViewModel = MainViewModel()
        let _ = try await mainViewModel.fetchLessonsFromRemote()
        XCTAssert(mainViewModel.lessons.count == mainViewModel.detailViewModels.count)
    }
    
    //Test calculating next detail view model
    func testSuccessfulNextDetailViewModel(){
        let mainViewModel = MainViewModel()
        
        let firstDetailViewModel = LessonDetailViewModel(lesson: Lesson(id: 0, name: "", description: "", thumbnail: "", video_url: ""))
        firstDetailViewModel.mainViewModel = mainViewModel
        
        let secondDetailViewModel = LessonDetailViewModel(lesson: Lesson(id: 0, name: "", description: "", thumbnail: "", video_url: ""))
        secondDetailViewModel.mainViewModel = mainViewModel
        
        mainViewModel.detailViewModels = [firstDetailViewModel, secondDetailViewModel]
        
        let result = firstDetailViewModel.returnNextDetailViewModel()
        XCTAssert(result != nil)
    }
    
    //Test calculating next detail view model that is position at the end of array
    func testFailedNextDetailViewModel(){
        let mainViewModel = MainViewModel()
        
        let firstDetailViewModel = LessonDetailViewModel(lesson: Lesson(id: 0, name: "", description: "", thumbnail: "", video_url: ""))
        firstDetailViewModel.mainViewModel = mainViewModel
        
        let secondDetailViewModel = LessonDetailViewModel(lesson: Lesson(id: 0, name: "", description: "", thumbnail: "", video_url: ""))
        secondDetailViewModel.mainViewModel = mainViewModel
        
        mainViewModel.detailViewModels = [firstDetailViewModel, secondDetailViewModel]
        
        let result = secondDetailViewModel.returnNextDetailViewModel()
        XCTAssert(result == nil)
    }
    
    
    //Test loading thumbnail
    func testLoadingThumbnail() async throws{
        let exampleLesson = Lesson(id: 0, name: "Test", description: "Test", thumbnail: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560", video_url: "Test")
        let lessonCellViewModel = LessonCellViewModel(lesson: exampleLesson)
        let thumbnailImage = try await lessonCellViewModel.asyncLoadThumnnailImage(from: exampleLesson.thumbnail)
        
        XCTAssert(thumbnailImage.size != CGSize.zero)
    }
    
    //Test url session initialization
    func checkURLSessionInitialization(){
        let exampleLesson = Lesson(id: 1, name: "Test", description: "Test", thumbnail: "", video_url: "https://embed-ssl.wistia.com/deliveries/f2cd208ce7fddf0c0ea886a8f1d0eabf26271816/2rya8a2tcw.mp4")
        let mainViewModel = MainViewModel()
        let lessonViewModel = LessonDetailViewModel(lesson: exampleLesson)
        lessonViewModel.mainViewModel = mainViewModel
        XCTAssertNotNil(lessonViewModel.downloadTask)
    }
    
    //Test downloading video status
    func testDownloadingVideoStatus(){
        let exampleLesson = Lesson(id: 1, name: "Test", description: "Test", thumbnail: "", video_url: "https://embed-ssl.wistia.com/deliveries/f2cd208ce7fddf0c0ea886a8f1d0eabf26271816/2rya8a2tcw.mp4")
        let mainViewModel = MainViewModel()
        let lessonViewModel = LessonDetailViewModel(lesson: exampleLesson)
        lessonViewModel.mainViewModel = mainViewModel
        lessonViewModel.startDownloadingVideo()
        
        XCTAssert(lessonViewModel.isDownloading)
        lessonViewModel.stopDownloadingVideo()
        XCTAssert(lessonViewModel.isDownloading == false)
    }
    
}
