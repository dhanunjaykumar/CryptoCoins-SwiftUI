////
////  Model.swift
////  CrptoCoins
////
////  Created by Dhanunjay Kumar on 04/02/24.
////
//
//import Foundation
//
import Foundation

enum CryptoType: String, Decodable {
    case coin
    case token
}

struct Cryptocurrency:  Decodable, Identifiable {
    var id = UUID()
    let name, symbol: String
    let isNew, isActive: Bool
    let type: CryptoType
    
    enum CodingKeys: String, CodingKey {
        case name, symbol
        case isNew
        case isActive
        case type
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)
        isNew = try container.decode(Bool.self, forKey: .isNew)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        
        let typeString = try container.decode(String.self, forKey: .type)
        
        if let type = CryptoType(rawValue: typeString) {
            self.type = type
        } else {
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid crypto type")
        }
    }
    
}

struct CryptocurrencyResponse: Decodable {
    let cryptoCurrencies: [Cryptocurrency]
    
    enum CodingKeys: String, CodingKey {
        case cryptoCurrencies = "cryptocurrencies"
    }

}

struct TagModel: Identifiable, Hashable {
    var id = UUID()
    let title: String
    var isSelected: Bool
    let key: TagActionsType
}
