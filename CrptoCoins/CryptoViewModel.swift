//
//  CryptoViewModel.swift
//  CrptoCoins
//
//  Created by Dhanunjay Kumar on 04/02/24.
//

import Foundation
import Combine

enum TagActionsType {
    case inactiveCoins
    case activeCoins
    case onlyCoins
    case onlyTokens
    case newCoins
}

@MainActor
final class CryptoViewModel: ObservableObject {
    
    private var canecllable = Set<AnyCancellable>()
    
    @Published private(set) var cryptoCurrencies: [Cryptocurrency] = []
    @Published private(set) var filterdCurrencies: [Cryptocurrency] = []
    @Published var showSearchBar = false
    @Published var isLoading = false
    
    @Published var tags = [TagModel(title: "Active Coins", isSelected: false, key: .activeCoins),TagModel(title: "Inactive Coins", isSelected: false, key: .inactiveCoins),TagModel(title: "Only Tokens", isSelected: false, key: .onlyTokens),TagModel(title: "Only Coins", isSelected: false, key: .onlyCoins),TagModel(title: "New Coins", isSelected: false, key: .newCoins)]
    
    @Published var selectedTags : Set<TagModel> = Set() {
        didSet {
            self.applySelectedFilters()
        }
    }
        
    var isSearching: Bool {
        !searchText.isEmpty
    }
    var isFiltersApplied: Bool {
        !selectedTags.isEmpty
    }
    
    @Published var searchText = ""

    private let networkManaer: NetworkHandler
    
    init(networkManaer: NetworkHandler) {
        self.networkManaer = networkManaer
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText.debounce(for: 0.2, scheduler: DispatchQueue.main).sink { [weak self] searchText in
            self?.filterCoins(searchText: searchText)
        }.store(in: &canecllable)
    }
    private func applySelectedFilters() {

        filterdCurrencies = cryptoCurrencies.filter {
            var conditions: [Bool] = []

            var isActiveFilterSelected = false

            for each in selectedTags {
                switch each.key {
                case .inactiveCoins:
                    conditions.append(!$0.isActive)
                case .activeCoins:
                    conditions.append($0.isActive)
                    isActiveFilterSelected = true
                case .onlyCoins:
                    conditions.append($0.type == .coin)
                case .onlyTokens:
                    conditions.append($0.type == .token)
                case .newCoins:
                    conditions.append($0.isNew)
                }
            }
            
            if isActiveFilterSelected {
                return conditions.contains(true)
            } else {
                return conditions.allSatisfy { $0 }
            }
        }
    }
    private func filterCoins(searchText: String) {
        
        guard !searchText.isEmpty else {
            filterdCurrencies = cryptoCurrencies
            return
        }
        
        let search = searchText.lowercased()
        
        var isActiveFilterSelected = false
                
        filterdCurrencies = cryptoCurrencies.filter {
            var conditions: [Bool] = []

            for each in selectedTags {
                switch each.key {
                case .inactiveCoins:
                    conditions.append(!$0.isActive)
                case .activeCoins:
                    conditions.append($0.isActive)
                    isActiveFilterSelected = true
                case .onlyCoins:
                    conditions.append($0.type == .coin)
                case .onlyTokens:
                    conditions.append($0.type == .token)
                case .newCoins:
                    conditions.append($0.isNew)
                }
            }
            
            if isActiveFilterSelected {
                return conditions.contains(true)
            } else {
                return conditions.allSatisfy { $0 }
            }
        }
        
        filterdCurrencies = filterdCurrencies.filter { coin in
            let name = coin.name.lowercased().contains(search)
            let symbol = coin.symbol.lowercased().contains(search)
            return name || symbol
        }
        
    }

    func fetchCoins() async {
        
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            let data : CryptocurrencyResponse = try await networkManaer.request(url: "https://run.mocky.io/v3/ac7d7699-a7f7-488b-9386-90d1a60c4a4b")
            self.cryptoCurrencies = data.cryptoCurrencies
        }catch {
            print("Fetch Product error:", error)
        }
        
    }
}

