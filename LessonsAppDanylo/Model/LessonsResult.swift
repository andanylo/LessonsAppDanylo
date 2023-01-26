//
//  LessonsResult.swift
//  LessonsAppDanylo
//
//  Created by Danylo Andriushchenko on 23.01.2023.
//

import Foundation


///Result struct that is created from fetching JSON from URL
struct LessonsResult: Decodable{
    var lessons: [Lesson]
}
