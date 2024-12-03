//
//  HomeViewModel.swift
//  Stay Connected
//
//  Created by Anna Harris on 03.12.24.
//

import Foundation
import Combine

class HomeViewModel {

    @Published var questions: [Question] = []
    @Published var tagTitles: [String] = []
    @Published var repliesCount: [Int] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchQuestions() {
        networkManager.fetchQuestions()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { questions in
                self.questions = questions
                self.tagTitles = questions.map { $0.tags.first ?? "No Tag" }
                self.repliesCount = questions.map { _ in Int.random(in: 0...50) }
            })
            .store(in: &cancellables)
    }
}


