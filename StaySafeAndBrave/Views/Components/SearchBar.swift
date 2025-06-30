//
//  SearchBar.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 5/28/25.

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var placeholder: String = "Search..."
    var onFilter: () -> Void = {}
    var onSearch: () -> Void = {}
    var showDebugButton: Bool = false
    var showFilterButton: Bool = true
    var onDebugButton: () -> Void = {}
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Search container
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .medium))
                
                TextField(placeholder, text: $searchText)
                    .focused($isFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        onSearch()
                    }
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Filter button
            if(showFilterButton){
                Button(action: onFilter) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 20, height: 20)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
            }
            
            // Optional debug button (for development/testing)
            if showDebugButton {
                Button(action: onDebugButton) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 20, height: 20)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
