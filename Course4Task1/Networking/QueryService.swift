//
//  QueryService.swift
//  Course4Task1
//

//

import Foundation

//
// MARK: - Query Service
//

/// Runs query data task, and stores results in array of Repository Info or User Info
class QueryService {
    //
    // MARK: - Constants
    //
    let defaultSession = URLSession(configuration: .default)
    let scheme = "https"
    let host = "api.github.com"
    let hostPath = "https://api.github.com"
    let searchRepoPath = "/search/repositories"
    let defaultHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "application/vnd.github.v3+json"
    ]
    
    //
    // MARK: - Variables And Properties
    //
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var repositories: RepositoryShortInfo?
    var user: UserInfo?
    
    //
    // MARK: - Type Alias
    //
    typealias JSONDictionary = [String: Any]
    typealias SearchResult = (RepositoryShortInfo?, String) -> Void
    typealias AuthorizationResult = (UserInfo?, String) -> Void
    
    //
    // MARK: - Internal Methods
    //
    
    func getSearchResults(searchTerm: String, order: String, completion: @escaping SearchResult) {
        
        dataTask?.cancel()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = searchRepoPath        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: order)
        ]
        
            guard let url = urlComponents.url else {
                return
            }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = defaultHeaders
        
        dataTask = defaultSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                self?.parseSearchResults(data)
                
                DispatchQueue.main.async {
                    completion(self?.repositories, self?.errorMessage ?? "")
                }
            }
        }
        
        dataTask?.resume()
        
    }
    
    func makeAuthorizationRequest(credentials: UserCredentials, completion: @escaping AuthorizationResult) {
        let account = credentials.account
        let password = credentials.password
        let loginString = "\(account):\(password)"
        
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        
        let url = URL(string: "https://api.github.com/user")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                self?.parseUserData(data)
                completion(self?.user, self?.errorMessage ?? "")
            }
            else {
                
            }
        }
        
        task.resume()
    }
    
    //
    // MARK: - Private Methods
    //
    
    private func parseUserData(_ data: Data) {
        user = nil
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let userInfo = try decoder.decode(UserInfo.self, from: data)
            user = userInfo
        } catch {
            debugPrint(error)
            errorMessage += "JSONDecoder error: \(error.localizedDescription)\n"
            return
        }
        
    }
    
    private func parseSearchResults(_ data: Data) {
        repositories = nil
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let repositoriesInfo = try decoder.decode(RepositoryShortInfo.self, from: data)
            repositories = repositoriesInfo
        } catch {
            debugPrint(error)
            errorMessage += "JSONDecoder error: \(error.localizedDescription)\n"
            return
        }

    }
}

