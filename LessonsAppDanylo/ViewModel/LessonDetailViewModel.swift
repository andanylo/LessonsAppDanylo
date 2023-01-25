//
//  LessonDetailViewModel.swift
//  LessonsAppDanylo
//
//  Created by Danil Andriuschenko on 24.01.2023.
//

import Foundation

//Lesson detail view model that prepares detail view for a display
class LessonDetailViewModel{
    var lesson: Lesson
    
    weak var mainViewModel: MainViewModel?
    
    var isDownloading = false{
        didSet{
            didChangeDownloadingStatus?(isDownloading)
        }
    }
    
    var progress: Float = 0.0{
        didSet{
            didChangeProgress?(progress)
        }
    }
    
    var didChangeDownloadingStatus: ((Bool) -> Void)?
    var didChangeProgress: ((Float) -> Void)?
    
    ///- Returns: The bool if the video exists locally
    var isDownloaded: Bool{
        get{
            guard let localVideoPath = self.localVideoURL?.path else{
                return false
            }
            
            return FileManager.default.fileExists(atPath: localVideoPath)
        }
    }
    
    ///- Returns: Local video name
    var localVideoName: String{
        get{
            return "lesson-\(lesson.id).mp4"
        }
    }
    
    ///- Returns: Path for loaclly stored video
    var localVideoURL: URL?{
        get{
            guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
                return nil
            }
            let videoUrl = documentDirectoryURL.appendingPathExtension(localVideoName)
            return videoUrl
        }
    }
    
    ///- Returns: A video url that needs to be diplayed
    ///If video exists locally, load from documents
    ///Else load from remote site
    var url: URL?{
        get{
            if isDownloaded{
                return localVideoURL
            }
            return URL(string: lesson.video_url)
        }
    }
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    ///- Returns: Next detail view model
    func returnNextDetailViewModel() -> LessonDetailViewModel?{
        guard let currentIndex = mainViewModel?.detailViewModels.firstIndex(where: {$0 === self}) else{
            return nil
        }
        
        let nextIndex = currentIndex + 1
        if nextIndex < mainViewModel?.detailViewModels.count ?? 0{
            return mainViewModel?.detailViewModels[nextIndex]
        }
        
        return nil
    }
    
    lazy var downloadTask: URLSessionDownloadTask? = {
        if let downloadURL = URL(string: lesson.video_url) {
            let urlRequest = URLRequest(url: downloadURL)
            
            return mainViewModel?.downloadSession.downloadTask(with: urlRequest)
        }
        return nil
    }()
    
    
    ///Starts downloading video
    func startDownloadingVideo(){
        isDownloading = true
        progress = 0
        
        downloadTask?.resume()
        
    }
    
    ///Stops downloading video
    func stopDownloadingVideo(){
        isDownloading = false
        progress = 0
        
        downloadTask?.cancel()
    }

}
