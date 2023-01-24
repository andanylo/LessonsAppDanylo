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
    
    var isDownloading = false
    var progress: Float = 0.0
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
    
    ///Checks if video exists locally
    ///- Returns: A boolean which indicates if video was downloaded
}
