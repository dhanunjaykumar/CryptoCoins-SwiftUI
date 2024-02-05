//
//  CryptoCoinViewModel.swift
//  CrptoCoins
//
//  Created by Dhanunjay Kumar on 04/02/24.
//

import Foundation

struct CoinViewModel {
    
    var crypto: Cryptocurrency
    
    var title: String {
        return crypto.name
    }
    
    var subtitle: String {
        return crypto.symbol
    }
    
    var image: String {
        switch crypto.type {
        case .coin:
            return "cryptoCoin"
        case .token:
            return crypto.isActive ? "cryptoToken" : "cryptoInactive"
        }
    }
    
    var showOverlay: Bool {
        return crypto.isNew
    }
}



