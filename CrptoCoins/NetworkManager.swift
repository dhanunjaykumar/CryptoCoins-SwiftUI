//
//  NetworkManager.swift
//  CrptoCoins
//
//  Created by Dhanunjay Kumar on 04/02/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}

protocol NetworkHandler {
    func request<T: Decodable>(url: String) async throws -> T
}

final class NetworkManager: NetworkHandler {
    
    
    
    func request<T: Decodable>(url: String) async throws -> T {
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
}
