//
//  MainViewModel.swift
//  LessonsAppDanylo
//
//  Created by Danil Andriuschenko on 23.01.2023.
//

import Foundation

///ViewModel that prepares main view for a display
class MainViewModel{
    
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
    
}
