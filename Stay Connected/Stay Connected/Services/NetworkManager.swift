//
//  NetworkManager.swift
//  Stay Connected
//
//  Created by Giorgi Matiashvili on 01.12.24.
//

import Foundation
import Combine

class NetworkManager {

    private let baseURL = URL(string: "http://localhost:3001")!
    
    func fetchQuestions() -> AnyPublisher<[Question], Error> {
        let url = baseURL.appendingPathComponent("/questions")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Question].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
