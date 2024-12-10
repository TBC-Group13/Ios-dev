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
    @Published var errorMessage: String?
    @Published var isLoginEnabled: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest($email, $password)
            .map { !$0.isEmpty && !$1.isEmpty }
            .assign(to: &$isLoginEnabled)
    }

    func login(completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "identifier": email,
            "password": password
        ]

        NetworkManager.shared.login(parameters: parameters) { [weak self] (result: Result<LoginResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Login successful. Username: \(response.user.username)")
                    print("Access Token: \(response.tokens.access)")
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
}
