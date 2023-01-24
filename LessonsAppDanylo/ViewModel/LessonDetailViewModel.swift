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
    
    var isDownloading = false
    var progress: Float = 0.0
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    
    
    ///Checks if video exists locally
    ///- Returns: A boolean which indicates if video was downloaded
}
