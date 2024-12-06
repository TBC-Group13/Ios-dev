//
//  QuestionResponse.swift
//  Stay Connected
//
//  Created by Giorgi Matiashvili on 06.12.24.
//

import Foundation

struct QuestionResponse: Decodable {
    let id: Int
    let title: String
    let tags: [String]
}
