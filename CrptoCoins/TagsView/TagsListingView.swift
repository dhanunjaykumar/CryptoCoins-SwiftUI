//
//  TagsListingView.swift
//  CrptoCoins
//
//  Created by Dhanunjay Kumar on 04/02/24.
//

import SwiftUI

struct TagsListingView: View {
        
    @Binding var tags: [TagModel]
    
    @Binding var selectedTags: Set<TagModel>
    
    var body: some View {
        ScrollView(.vertical) {
            TagLayout(alignment: .leading, spacing: 10) {
                ForEach(tags, id: \.id) { tag in
                    TagView(tag.title, .blue, "checkmark",isSelected: selectedTags.contains(where: { $0.id == tag.id }))
                        .onTapGesture {
                            withAnimation(.snappy) {
                                if (selectedTags.contains(tag)) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        }
                }
            }
            .padding(15)
        }
        .scrollClipDisabled(false)
        .scrollIndicators(.hidden)
        .background(Color.init(hex: "c8c8c8"))


    }
    
    @ViewBuilder
    func TagView(_ tag: String, _ color: Color, _ icon: String, isSelected: Bool) -> some View {
        HStack(spacing: 4) {
            if (isSelected) {
                Image(systemName: icon)
            }
            Text(tag)
                .font(.callout)
                .fontWeight(.regular)
            
        }
        .frame(height: 40)
        .foregroundStyle(.black)
        .padding(.horizontal, 15)
        .background {
            Capsule()
                .fill(isSelected ? Color.gray.gradient : Color.white.opacity(1).gradient)
        }
    }
}

//#Preview {
//    TagsListingView(tags: <#Binding<[TagModel]>#>, selectedTags: <#Binding<[TagModel]>#>)
//}


