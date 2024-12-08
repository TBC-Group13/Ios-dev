import Foundation
import Combine


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .requestFailed(let underlyingError):
            return "The request failed: \(underlyingError.localizedDescription)"
        case .invalidResponse:
            return "The server returned an invalid response."
        case .decodingFailed:
            return "Failed to decode the response into the expected model."
        }
    }
}

// MARK: - NetworkManager

class NetworkManager {
    static let shared = NetworkManager()
     init() {}
    
    func request<T: Decodable>(
        urlString: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = parameters {
            switch method {
            case .get:
                if var urlComponents = URLComponents(string: urlString) {
                    urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                    if let newURL = urlComponents.url {
                        urlRequest.url = newURL
                    }
                }
            default:
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    urlRequest.httpBody = jsonData
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    completion(.failure(.requestFailed(error)))
                    return
                }
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            #if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print("----- RAW RESPONSE -----")
                print(jsonString)
                print("------------------------")
            }
            #endif
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                #if DEBUG
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed to decode into \(T.self): \(jsonString)")
                }
                #endif
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
    
    //Login API Call
    func login(parameters: [String: Any], completion: @escaping (Result<String, NetworkError>) -> Void) {
        let urlString = "http://ec2-18-198-208-73.eu-central-1.compute.amazonaws.com/api/login/"
        
        request(urlString: urlString, method: .post, parameters: parameters) { (result: Result<LoginResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let message = "Login successful. Access token: \(response.tokens.access)"
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //Registration API Call
    func registerUser(parameters: [String: Any], completion: @escaping (Result<String, NetworkError>) -> Void) {
        let urlString = "http://ec2-18-198-208-73.eu-central-1.compute.amazonaws.com/api/register/"
        
        request(urlString: urlString, method: .post, parameters: parameters) { (result: Result<RegisterResponse, NetworkError>) in
            switch result {
            case .success(let response):
                if response.success {
                    completion(.success(response.message ?? "Registration successful"))
                } else {
                    completion(.failure(.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
