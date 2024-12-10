import Foundation

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

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

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
                    urlRequest.url = urlComponents.url
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

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            // Log the HTTP status code
            print("HTTP Status Code: \(httpResponse.statusCode)")

            // Check if the response is successful
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            // Debugging: Log the raw response
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("----- RAW RESPONSE -----")
                print(jsonString)
                print("------------------------")
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed to decode JSON: \(jsonString)")
                }
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }

    func registerUser(parameters: [String: Any], completion: @escaping (Result<RegisterResponse, NetworkError>) -> Void) {
        let urlString = "http://ec2-18-198-208-73.eu-central-1.compute.amazonaws.com/api/register/"
        print("Register API URL: \(urlString)")
        print("Register Payload: \(parameters)")
        
        request(urlString: urlString, method: .post, parameters: parameters) { (result: Result<RegisterResponse, NetworkError>) in
            switch result {
            case .success(let response):
                print("Registration successful: \(response)")
                completion(.success(response))
            case .failure(let error):
                print("Registration error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func login(parameters: [String: Any], completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        let urlString = "http://ec2-18-198-208-73.eu-central-1.compute.amazonaws.com/api/login/"
        print("Login API URL: \(urlString)")
        print("Login Payload: \(parameters)")

        request(urlString: urlString, method: .post, parameters: parameters) { (result: Result<LoginResponse, NetworkError>) in
            switch result {
            case .success(let response):
                print("Login successful. Username: \(response.user.username)")
                print("Access Token: \(response.tokens.access)")
                completion(.success(response))
            case .failure(let error):
                print("Login error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
