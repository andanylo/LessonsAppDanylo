//
//  MainViewModel.swift
//  LessonsAppDanylo
//
//  Created by Danil Andriuschenko on 23.01.2023.
//

import Foundation

///ViewModel that prepares main view for a display
class MainViewModel: NSObject{
    
    var lessons: [Lesson] = []{
        didSet{
            self.lessonCellViewModels = getLessonCellViewModels(from: lessons)
            self.detailViewModels = getLessonDetailViewModels(from: lessons)
        }
    }
    
    ///Lesson cell view models
    var lessonCellViewModels: [LessonCellViewModel] = []
    
    ///Detail view view models
    var detailViewModels: [LessonDetailViewModel] = []
    
    
    ///Get downloading detail view view models videos
    var downloadingVideosDetailViewModels: [LessonDetailViewModel] {
        get{
            return detailViewModels.filter({$0.isDownloading})
        }
    }
    
    ///- Returns: A download session
    lazy var downloadSession: URLSession = {
        let config = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        return session
    }()
  
    
    ///Fetch lessons from the url
    ///- Returns: An array of lessons
    func fetchLessonsFromRemote() async throws -> [Lesson]{
        guard let url = URL(string: "https://iphonephotographyschool.com/test-api/lessons") else{
            throw FetchError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        urlRequest.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let lessonsResult: LessonsResult = try? JSONDecoder().decode(LessonsResult.self, from: data) else{
            throw FetchError.errorDecoding
        }
        
        self.lessons = lessonsResult.lessons
        return lessonsResult.lessons
    }
    
    
    ///- Returns: An array of view models for lesson cell based on number of lesson objects
    ///
    func getLessonCellViewModels(from lessons: [Lesson]) -> [LessonCellViewModel]{
        var lessonCellViewModels: [LessonCellViewModel] = []
        lessons.forEach({lessonCellViewModels.append(LessonCellViewModel(lesson: $0))})
        return lessonCellViewModels
    }
    
    ///- Returns: An array of view models which prepare detail view for display
    ///
    func getLessonDetailViewModels(from lessons: [Lesson]) -> [LessonDetailViewModel]{
        var lessonDetailViewModels: [LessonDetailViewModel] = []
        lessons.forEach({
            let detailViewModel = LessonDetailViewModel(lesson: $0)
            detailViewModel.mainViewModel = self
            lessonDetailViewModels.append(detailViewModel)})
        return lessonDetailViewModels
    }
    
    enum FetchError: Error{
        case invalidURL
        case errorDecoding
    }
    
    ///- Returns: A lesson detail view model based on download task
    func findDownloadingLessonDetailViewModel(downloadTask: URLSessionDownloadTask) -> LessonDetailViewModel?{
        return downloadingVideosDetailViewModels.first(where: {$0.downloadTask === downloadTask})
    }
    
}


///Download delegate
extension MainViewModel: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let currentDetailViewModel: LessonDetailViewModel = findDownloadingLessonDetailViewModel(downloadTask: downloadTask) else{
            return
        }
        
        //Move from location to documents
        if let data = try? Data(contentsOf: location), let localVideoURL = currentDetailViewModel.localVideoURL{
            try? data.write(to: localVideoURL)
            
            //Set status to downloaded
            currentDetailViewModel.isDownloading = false
            currentDetailViewModel.downloadTask = nil
            currentDetailViewModel.progress = 1
        }
        
        
        
        
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let currentDetailViewModel: LessonDetailViewModel = findDownloadingLessonDetailViewModel(downloadTask: downloadTask) else{
            return
        }
        
        //Set progress
        currentDetailViewModel.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let task = task as? URLSessionDownloadTask, let currentDetailViewModel: LessonDetailViewModel = findDownloadingLessonDetailViewModel(downloadTask: task) else{
            return
        }
        
        currentDetailViewModel.isDownloading = false
        currentDetailViewModel.progress = 0
        currentDetailViewModel.downloadTask = nil
    }
   
    
}
