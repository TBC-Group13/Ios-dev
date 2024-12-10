//
//  LoginResponse.swift
//  Stay Connected
//
//  Created by Giorgi Matiashvili on 10.12.24.
//

import Foundation

struct LoginResponse: Decodable {
    let tokens: Tokens
    let user: User

    struct Tokens: Decodable {
        let refresh: String
        let access: String
    }

    struct User: Decodable {
        let id: Int
        let username: String
        let email: String
    }
}
