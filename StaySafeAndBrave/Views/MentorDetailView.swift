//
//  MentorDetailView.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 26.05.25.
//

import SwiftUI

struct MentorDetailView: View {
    let mentor:Mentor
    @State private var showingBookingRequest: Bool = false
    @State private var selectedDate: Date = Date()
    @State private var message: String = ""
    
    // make sure user is logged in
    @Binding var profile: Profile
    
    @Binding var activeTab: BottomNavBar.ActiveTab
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView {
                MentorRowListView(mentor: mentor)
                    .padding()
                // Add spaces such that the text is still readable
                let bioSpaced = "\(mentor.bio) \n\n\n\n\n\n"
                
                Text(bioSpaced)
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading) // There is a way to justify the text using UITextView
                Spacer().frame(height: 100)
            }
            
            
            HStack(alignment: .lastTextBaseline){
                
                Spacer()
                // Button
                if profile != Profile.empty{
                    Button(action: toBookingView){
                        HStack{
                            //Spacer()
                            
                            ZStack{
                                Circle()
                                    .frame(width:130, height: 130)
                                    .foregroundStyle(.teal)
                                
                                HStack{
                                    SFSymbol.booking
                                        .font(.largeTitle)
                                        .padding(.leading)
                                    Text("Book")
                                        .padding(.trailing)
                                        .font(.headline)
                                }
                                .foregroundStyle(.white)
                                
                                
                            }.padding(.horizontal, 30)
                        }
                    }.frame(width: 100, height: 100)
                        .padding(.trailing)
                }else {
                    Button(action: toProfile){
                        HStack{
                            //Spacer()
                            
                            ZStack{
                                Circle()
                                    .frame(width:130, height: 130)
                                    .foregroundStyle(.teal)
                                
                                HStack{
                                    SFSymbol.booking
                                        .font(.largeTitle)
                                        .padding(.leading)
                                    Text("Log in to Book")
                                        .padding(.trailing)
                                        .font(.headline)
                                }
                                .foregroundStyle(.white)
                                
                                
                            }.padding(.horizontal, 30)
                        }
                    }.frame(width: 100, height: 100)
                        .padding(.trailing)
                        
                }
                
            }.padding(.bottom, 75)
                .padding(.trailing,5)
            
            
            
            
        }.sheet(isPresented: $showingBookingRequest){
            bookingRequestView
        }
    }
    func toBookingView() {
            showingBookingRequest = true
    }
    
    func toProfile() {
        activeTab = .profile
    }
    
    private var bookingRequestView: some View {
        Form {
            Section{
                HStack{
                    
                    Button(action: {showingBookingRequest = false}){
                        SFSymbol.backArrow
                            .font(.title)
                            .foregroundStyle(.teal)
                        
                    }
                    
                    Text("Book Mentor")
                        .font(.title)
                        .foregroundStyle(.teal)
                    
                }
            }
            
            Section(header: Text("Booking Details")){
                HStack(){
                    VStack(alignment: .leading){
                        Text("Mentor:")
                        Text("\(mentor.name), \(mentor.age)")
                            .foregroundStyle(.teal)
                        Text("Location:")
                        Text("\(mentor.location.rawValue.localizedCapitalized)")
                            .foregroundStyle(.teal)
                    }
                    
                    Spacer()
                    
                    AsyncImage(url: URL(string: mentor.profile_image),
                    ){ image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(100)
                    } placeholder: {
                        ProgressView()
                            .frame(minWidth: 100,minHeight: 100)
                            .background(Color(.systemBackground))
                            .cornerRadius(100)
                    }
                }
            }
            
            Section("Package section"){
                HStack {
                    VStack(){
                        Text("Package Selection")
                        // Picker
                        
                        
                        
                        
                    }
                    
                    Spacer()
                }
                
            }
            
            Section("Date Selection"){
                HStack(){
                    DatePicker("Book Date", selection: $selectedDate)
                    Spacer()
                }
                
                
            }
            
            Section("Message for your mentor (Optional)"){
                TextEditor(text: $message)
            }
            
            Section{
                HStack(){
                    Spacer()
                    
                    Button(action: {
                        print("Booking added")
                        // if succeeds... showing BookingRequest = false
                        showingBookingRequest = false
                    }){
                        SFSymbol.sendMessage
                            .font(.title)
                            .foregroundStyle(.teal)
                    }
                }
            }
            
            
            }
        }
    
}

#Preview {
    
    MentorDetailView(mentor:createMentorPeter(), profile: .constant(Profile.testMentor), activeTab: .constant(.search))
}
