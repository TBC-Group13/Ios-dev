//
//  Question.swift
//  Stay Connected
//
//  Created by Anna Harris on 03.12.24.
//

import Foundation

struct Question: Decodable {
    let id: Int
    let title: String
    let body: String
    let tags: [String]
    let tagTitle: String
    let repliesCount: Int
}
