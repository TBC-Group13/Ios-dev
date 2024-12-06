//
//  LoginViewModel.swift
//  Stay Connected
//
//  Created by Giorgi Matiashvili on 30.11.24.
//

import Foundation
import Combine

class LoginViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var isLoginEnabled: Bool = false
    @Published private(set) var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Enable login button only when email and password are not empty
        Publishers.CombineLatest($email, $password)
            .map { !$0.isEmpty && !$1.isEmpty }
            .assign(to: \.isLoginEnabled, on: self)
            .store(in: &cancellables)
    }

    func login(completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "identifier": email,
            "password": password
        ]

        NetworkManager.shared.login(parameters: parameters) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let successMessage):
                    print(successMessage)
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
}
