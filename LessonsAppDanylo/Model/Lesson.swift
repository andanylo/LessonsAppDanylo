//
//  Lesson.swift
//  LessonsAppDanylo
//
//  Created by Danil Andriuschenko on 23.01.2023.
//

import Foundation


///Lesson stucture with name, description, thumbnail, and video_url
struct Lesson: Decodable{
    var name: String
    var descritption: String
    var thumbnail: String
    var viedo_url: String
}
