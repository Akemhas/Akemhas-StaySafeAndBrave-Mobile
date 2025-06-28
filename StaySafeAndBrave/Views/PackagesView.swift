//
//  PackagesView.swift
//  StaySafeAndBrave
//
//  Created by Alexander Staub on 14.06.25.
//

import SwiftUI


struct PackagesView: View {
    
    let basic: [Package] = [
        Package(title: "Information Package", heading:"Information package for travel preparation", details: "The Stay Safe and Brave Information Package provides detailed information about the program, its goals, and how to get involved.", price: 0.0),
        Package(title: "AI Local Mentor", heading:"AI Local Mentor access", details: "The Stay Safe and Brave AI Local Mentor provides personalized support and guidance to travelers.", price: 0.0)
    ]
    
    let standard: [Package] = [
        Package(title: "Welcoming at the airport", heading:"Get a warm welcome from your mentor", details: "Your local Mentor will greet you at the airport and help you get to your destination safely and smoothly.", price: 0.0),
        Package(title: "Personal Meeting", heading:"A meetup with your local Mentor", details: "You will have a in person meetup with your local Mentor and he will show you around town.", price: 0.0)
    ]
    
    let premium: [Package] = [
        Package(title: "Get-Ready-Videocall", heading:"Videocall to make sure you are ready!", details: "Your local Mentor will join you in a Videocall before you leave to make sure you are ready for your trip", price: 0.0),
        Package(title: "Sightseeing Tour", heading:"A planed tour by your local Mentor", details: "Your local Mentor will take you on a prepared Sightseeing Tour to location of your interesst.", price: 0.0)
    ]
    
    var body: some View {
        List {
            Section("Basic"){
                ForEach(basic) {item in
                    DisclosureGroup {
                        Text(item.heading)
                            .font(.title2.bold())
                            .multilineTextAlignment(.leading)
                            .listRowSeparator(.hidden)
                        Text(item.details)
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                    }label: {
                        Text(item.title)
                            .font(.title.bold())
                    }
                }
            }
            
            Section ("Standard (includes above)"){
                ForEach(standard) {item in
                    DisclosureGroup {
                        Text(item.heading)
                            .font(.title2.bold())
                            .multilineTextAlignment(.leading)
                            .listRowSeparator(.hidden)
                        Text(item.details)
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                    }label: {
                        Text(item.title)
                            .font(.title.bold())
                    }
                }
            }
            
            Section ("Premium (includes above)"){
                ForEach(premium) {item in
                    DisclosureGroup {
                        Text(item.heading)
                            .font(.title2.bold())
                            .multilineTextAlignment(.leading)
                            .listRowSeparator(.hidden)
                        Text(item.details)
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                    }label: {
                        Text(item.title)
                            .font(.title.bold())
                    }
                }
            }
                
        }
        
        .navigationTitle("Packages")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    PackagesView()
}
