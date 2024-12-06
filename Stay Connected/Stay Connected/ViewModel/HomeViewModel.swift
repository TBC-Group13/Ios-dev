//
//  HomeViewModel.swift
//  Stay Connected
//
//  Created by Anna Harris on 03.12.24.
//

import Foundation
import Combine

class HomeViewModel {

    @Published var questions: [QuestionResponse] = []
    @Published var tagTitles: [String] = []
    @Published var repliesCount: [Int] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }

}
