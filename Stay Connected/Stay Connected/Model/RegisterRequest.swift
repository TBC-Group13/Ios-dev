//
//  RegisterRequest.swift
//  Stay Connected
//
//  Created by Giorgi Matiashvili on 06.12.24.
//

import Foundation

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
    let repeat_password: String
}
