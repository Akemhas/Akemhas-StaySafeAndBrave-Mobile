//
//  SearchBar.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var placeholder: String = "Search..."
    var onFilter: () -> Void = {}
    var onSearch: () -> Void = {}
    var onAddDummies: () -> Void = {}
    var onSort: () -> Void = {}
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            
                Button(action: onSearch) {
                    SFSymbol.search
                        .foregroundStyle(.white)
                        .font(.headline)
                }
                .frame(width: 40, height: 40, alignment: .leading)
                .padding(.leading,30)
                
                TextField(placeholder, text: $searchText)
                    .fontDesign(.rounded)
                    .frame(width: 220, height: 40)
                    .foregroundStyle(searchText.isEmpty && !isFocused ? Color.blue : .white)
                    .font(.headline)
                    .focused($isFocused)
            Group{
                Button(action: onFilter) {
                    SFSymbol.filter
                        .foregroundStyle(.white)
                        .font(.headline)
                }
                
               /* Button(action: onSort){
                    SFSymbol.sort
                        .foregroundStyle(.white)
                        .font(.headline)
                }*/
                
                Button(action: onAddDummies) {
                    SFSymbol.addDummyData
                        .foregroundStyle(.white)
                        .font(.headline)
                }
            }
            .frame(width: 0, height: 0, alignment: .trailing)
            .padding(.trailing, 15)
        }
        .frame(width: 350, height: 60)
        .background(Color.teal)
        .cornerRadius(80)
        .padding(.top, 10)
    }
}
