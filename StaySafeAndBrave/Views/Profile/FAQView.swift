//
//  FAQView.swift
//  StaySafeAndBrave
//
//  Created by Alexander Staub on 14.06.25.
//

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

import SwiftUI

struct FAQView: View {
    
    let faq: [FAQItem] = [
        FAQItem(question: "How do I know I can trust my Local Mentor?", answer: "Your Local Mentor has undergone a rigorous background check and is required to complete a mandatory training program."),
        FAQItem(question: "What do I do if my Local Mentor is unavailable?", answer: "Your Local Mentor will respond to all your questions as quickly as possible, and no later than the following day. If you have a pressing matter, please contact your Local Mentor directly."),
        ]
    
    
    var body: some View {
        List {
            
            ForEach(faq) {item in
                DisclosureGroup {

                    Text(item.answer)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                }label: {
                    Text(item.question)
                        .font(.title.bold())
                }
            }
        }
        
        .navigationTitle("FAQ")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    FAQView()
}
