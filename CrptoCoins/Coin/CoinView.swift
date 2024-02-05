//
//  CoinView.swift
//  CrptoCoins
//
//  Created by Dhanunjay Kumar on 04/02/24.
//

import SwiftUI

struct CoinView: View {
    var crypto: Cryptocurrency
    
    var viewModel: CoinViewModel {
        return CoinViewModel(crypto: crypto)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.title).font(.title3).foregroundStyle(.gray)
                Text(viewModel.subtitle).font(.title2).fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 0)

            Spacer()
            
            VStack(alignment: .trailing) {
                Image(viewModel.image).resizable().frame(width: 40, height: 40)
            }.padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(12)
        .overlay(
            Group {
                if viewModel.showOverlay {
                    Image("cryptoNew").resizable().frame(width: 40, height: 40).background(Color.clear).padding(0)
                }
            }, alignment: .topTrailing
        )
    }
}

#Preview {
    CryptoCoinsView()
}
