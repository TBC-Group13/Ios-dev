//
//  LoginViewModel.swift
//  Stay Connected
//
//  Created by Giorgi Matiashvili on 30.11.24.
//

import Foundation
import Combine

class LoginViewModel {
    // Inputs
    @Published var email: String = ""
    @Published var password: String = ""

    // Outputs
    @Published private(set) var isLoginEnabled: Bool = false
    @Published private(set) var errorMessage: String?
    
    @Published private(set) var loggedInUser: User?

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Combine email and password to enable login button when both are non-empty
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return !email.isEmpty && !password.isEmpty
            }
            .assign(to: \.isLoginEnabled, on: self)
            .store(in: &cancellables)
    }

    func login(completion: @escaping (Bool) -> Void) {
        // Mock validation for username "123" and password "123"
        if email == "123" && password == "123" {
            self.loggedInUser = User(id: 1, email: "123", profileImageUrl: nil)
            completion(true)
        } else {
            errorMessage = "Invalid email or password"
            completion(false)
        }
    }
}
