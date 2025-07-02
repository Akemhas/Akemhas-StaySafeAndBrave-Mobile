//
//  MentorDetailView.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 26.05.25.
// View displayed after selecting a mentor

import SwiftUI

struct MentorDetailView: View {
    let mentor: Mentor
    @State private var showingBookingRequest: Bool = false
    @State private var selectedDate: Date = Date()
    @State private var message: String = ""
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var isBooking = false
    
    @StateObject private var bookingViewModel = BookingViewModel()
    
    // make sure user is logged in
    @Binding var profile: Profile
    @Binding var activeTab: BottomNavBar.ActiveTab
    
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView {
                /// Reuses the view of the mentor list
                MentorRowListView(mentor: mentor)
                    .padding()
                // Add spaces such that the text is still readable
                let bioSpaced = "\(mentor.bio) \n\n\n\n\n\n"
                
                Text(bioSpaced)
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading) // There is a way to justify the text using UITextView. but it is not being implemented yet
                Spacer().frame(height: 100)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    /// allow booking only if user is logged in
                    if profile != Profile.empty{
                        if(profile.role == .user){
                            // Booking button
                            Button(action: toBookingView) {
                                HStack(spacing: 12) {
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    
                                    Text("Book Mentor")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.teal, Color.teal.opacity(0.9)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: Color.teal.opacity(0.3), radius: 8, x: 0, y: 4)
                                .scaleEffect(isBooking ? 0.95 : 1.0)
                                .opacity(isBooking ? 0.7 : 1.0)
                                .animation(.easeInOut(duration: 0.1), value: isBooking)
                            }
                            .disabled(isBooking)
                            .padding(.trailing, 20)
                        }
                    } else {
                        // Profile redirection
                        Button(action: toProfile) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.badge.key")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                
                                Text("Login to Book")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.gray)
                            .cornerRadius(20)
                            .shadow(color: Color.gray.opacity(0.8), radius: 6, x: 0, y: 3)
                        }
                        .padding(.trailing, 20)
                    }
                }
            }
            .padding(.bottom, 90)
        }
        .sheet(isPresented: $showingBookingRequest){
            bookingRequestView
        }
        .alert("Booking Successful", isPresented: $showingSuccessAlert) {
            Button("OK") {
                showingBookingRequest = false
            }
        } message: {
            Text("Your booking request has been sent successfully!")
        }
        .alert("Booking Error", isPresented: $showingErrorAlert) {
            Button("OK") {
                bookingViewModel.clearErrorMessage()
            }
        } message: {
            Text(bookingViewModel.errorMessage ?? "Unknown error occurred")
        }
        .onChange(of: bookingViewModel.errorMessage) { _, newValue in
            showingErrorAlert = newValue != nil
        }
    }
    
    func toBookingView() {
        showingBookingRequest = true
    }
    
    func toProfile() {
        activeTab = .profile
    }
    
    private var bookingRequestView: some View {
        NavigationView {
            Form {
                Section("Booking Details") {
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
                
                Section("Date Selection"){
                    DatePicker(
                        "Book Date",
                        selection: $selectedDate,
                        in: Date()..., // Only allow future dates
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                }
                
                Section("Message for your mentor (Optional)"){
                    TextEditor(text: $message)
                        .frame(minHeight: 100)
                }
                
                Section{
                    Button(action: createBooking) {
                        HStack {
                            if isBooking {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Sending Request...")
                            } else {
                                Text("Send Booking Request")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(isBooking ? .gray : .teal)
                    }
                    .disabled(isBooking)
                }
            }
            .navigationTitle("Book Mentor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingBookingRequest = false
                    }
                }
            }
        }
    }
    
    private func createBooking() {
        guard let userID = UUID(uuidString: profile.user_id) else {
            print("❌ Invalid user ID: \(profile.user_id)")
            return
        }
        
        isBooking = true
        
        Task {
            let success = await bookingViewModel.createBooking(
                userID: userID,
                mentorID: mentor.id,
                date: selectedDate,
                description: message.isEmpty ? nil : message
            )
            
            await MainActor.run {
                isBooking = false
                
                if success {
                    showingSuccessAlert = true
                    // Reset form
                    selectedDate = Date()
                    message = ""
                }
                // Error alert will be shown automatically through onChange
            }
        }
    }
}

#Preview {
    MentorDetailView(mentor:createMentorPeter(), profile: .constant(Profile.testMentor), activeTab: .constant(.search))
}
