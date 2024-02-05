//
//  ContentView.swift
//  CrptoCoins
//
//  Created by Dhanunjay Kumar on 03/02/24.
//

import SwiftUI

struct CryptoCoinsView: View {
    
    @StateObject private var viewModel: CryptoViewModel = CryptoViewModel(networkManaer: NetworkManager())
    
    @FocusState var isFocused: Bool

    
    var body: some View {
        ZStack {
            NavigationStack{
                VStack{
                    HStack{
                        if !viewModel.showSearchBar{
                            Text("COIN")
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        Spacer(minLength: 0)
                        HStack{
                            
                            if viewModel.showSearchBar{
                                HStack {
                                    
                                    Image("search").padding(.horizontal, 8).frame(width: 44, height: 44)
                                    TextField("Search Coins / Symbols", text:  $viewModel.searchText)
                                        .focused($isFocused)
                                    
                                    Button(action: {
                                        withAnimation {
                                            viewModel.searchText = ""
                                            viewModel.showSearchBar.toggle()
                                            isFocused = false
                                        }
                                    }) {
                                        Image(systemName: "xmark").foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 8)
                                }
                            }
                            else{
                                Button(action: {
                                    withAnimation {
                                        isFocused = true
                                        viewModel.showSearchBar.toggle()
                                        viewModel.searchText = ""
                                    }
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .renderingMode(.original)
                                        .imageScale(.large)
                                        .foregroundColor(Color.white)
                                        .frame(width: 44, height: 44)
                                        .padding(0)
                                    
                                }
                            }
                        }
                        .padding(viewModel.showSearchBar ? 10 : 0)
                        .background(viewModel.showSearchBar ? Color.white : Color.clear)
                        .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .background(Color.init(hex: "6200ed"))
                }
                List ((viewModel.isSearching || viewModel.isFiltersApplied) ? viewModel.filterdCurrencies : viewModel.cryptoCurrencies, id: \.id) { currency in
                    CoinView(crypto: currency)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .alignmentGuide(.listRowSeparatorLeading) { d in
                            d[.leading]
                        }
                }
                .listStyle(PlainListStyle())
                VStack {
                    TagsListingView(tags: $viewModel.tags, selectedTags: $viewModel.selectedTags)
                }.frame(height: 160)
                            
            }
            
            if(viewModel.isLoading) {
                LoadingView()
            }
        }
        .task {
            await viewModel.fetchCoins()
        }
        .overlay{
            if (viewModel.filterdCurrencies.isEmpty && !viewModel.searchText.isEmpty  && !viewModel.isFiltersApplied || ( viewModel.filterdCurrencies.isEmpty && viewModel.isFiltersApplied ))  {

                ContentUnavailableView.search
            }
        }
    }
}

#Preview {
    CryptoCoinsView()
}




struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .scaleEffect(3)
        }
    }
}
