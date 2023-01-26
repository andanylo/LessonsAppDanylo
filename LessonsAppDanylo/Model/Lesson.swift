//
//  Lesson.swift
//  LessonsAppDanylo
//
//  Created by Danylo Andriushchenko on 23.01.2023.
//

import Foundation


///Lesson stucture with name, description, thumbnail, and video_url
struct Lesson: Decodable{
    var id: Int
    var name: String
    var description: String
    var thumbnail: String
    var video_url: String
}
