//
//  LessonCellViewModel.swift
//  LessonsAppDanylo
//
//  Created by Danil Andriuschenko on 23.01.2023.
//

import Foundation
import UIKit
class LessonCellViewModel{
    var lesson: Lesson
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    
    ///Load image from website
    ///- Returns: a thumbnail image
    func asyncLoadThumnnailImage(from path: String) async throws -> UIImage{
        guard let url = URL(string: path) else{
            throw ImageLoadingError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let image = UIImage(data: data) else {
            throw ImageLoadingError.invalidData
        }
        
        return image
    }
    
    
    
    enum ImageLoadingError: Error{
        case invalidURL
        case invalidData
    }
    
}
