//
//  LessonsResult.swift
//  LessonsAppDanylo
//
//  Created by Danil Andriuschenko on 23.01.2023.
//

import Foundation


///Result struct that is created from fetching JSON from URL
struct LessonsResult: Decodable{
    var lessons: [Lesson]
}
