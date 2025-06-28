//
//  ButtonView.swift
//  StaySafeAndBrave
//
//  Created by Alexander Staub on 14.06.25.
//

import SwiftUI

struct ButtonView: View {
    let label: String
    let icon: String?
    let color: Color?
    let action: () -> Void
    
    init(label: String,
         icon: String? = "",
         color: Color? = Color.teal,
         action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button{
            action()
        }label:{
            HStack(spacing: 0){
                HStack(spacing: 8){
                    Text(label)
                        .font(.system(size: 20,
                                      weight: .regular))
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(height: 46)
                .background{
                    UnevenRoundedRectangle(
                        topLeadingRadius:6,
                        bottomLeadingRadius:6,
                        bottomTrailingRadius:0,
                        topTrailingRadius:0,
                    )
                    .fill(Color(.systemGray6))
                }
                
                
                
                if let icon{
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding(11)
                        .background(color)
                        .clipShape(Circle())
                        .background{
                            UnevenRoundedRectangle(
                                topLeadingRadius:0,
                                bottomLeadingRadius:0,
                                bottomTrailingRadius:100,
                                topTrailingRadius:100,
                            )
                            .fill(Color(.systemGray6))
                        }
                }
                
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(Color.black)
            
            
        }
        
    }
}

#Preview {
    VStack(spacing:20) {
        ButtonView(label: "Test", icon: "cube.box") {}
        ButtonView(label: "Test2", icon: "questionmark", color: Color.red) {}
    }
    .padding()
}
