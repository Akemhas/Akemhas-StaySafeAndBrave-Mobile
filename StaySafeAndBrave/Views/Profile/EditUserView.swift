//
//  EditUserView.swift
//  StaySafeAndBrave
//
//  Created by Alexander Staub on 15.06.25.
//

import SwiftUI
import PhotosUI

struct EditUserView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var profile: Profile
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var cpassword: String = ""
    @State private var birth_date: Date = Date()
    @State private var selectedLanguages: [AvailableLanguage] = []
    @State private var selectedHobbies: [Hobby] = []
    
    @State private var city: City?
    @State private var bio: String = ""
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    private let userAPIService = UserAPIService.shared
    private let mentorAPIService = MentorAPIService.shared
    
    
    var isValid: Bool {
        [name, email].contains(where: \.isEmpty)
    }
    
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: calendar.component(.year, from: Date()) - 100)
        let endComponents = DateComponents(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()), day: calendar.component(.day, from: Date()))
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }
    
    var body: some View {
        Form {
            Group{
                TextField(
                    "Name",
                    text: $name,
                )
                .textContentType(.username)
                TextField(
                    "E-Mail",
                    text: $email,
                )
                .textContentType(.emailAddress)
                .disabled(true)
                .foregroundColor(.secondary)
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            
            DisclosureGroup("Birthdate: \(birth_date.formatted(date: .long, time: .omitted))"){
                DatePicker("Birthdate:",
                           selection: $birth_date,
                           in: dateRange,
                           displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
            }
            
            if profile.role == .mentor{
                VStack{
                    PhotosPicker("Select Profile Picture", selection: $avatarItem, matching: .images)
                    
                    avatarImage?.resizable()
                        .frame(width: 300, height: 300)
                        .scaledToFit()
                        .cornerRadius(400)
                }.task(id: avatarItem) {
                    avatarImage = try? await avatarItem?.loadTransferable(type: Image.self)
                }

                DisclosureGroup("Hobbies: \(selectedHobbies.map (\.rawValue.capitalized).joined(separator: ", "))"){
                    ForEach(Hobby.allCases) { item in
                        Toggle(isOn: Binding(
                            get: {selectedHobbies.contains(item)},
                            set: {isSelected in if isSelected{
                                selectedHobbies.append(item)
                            }else{
                                selectedHobbies.removeAll { $0 == item }
                            }
                        }
                        )){
                            Text(item.rawValue.capitalized)
                        }
                    }
                }
                
                DisclosureGroup("Languages: \(selectedLanguages.map (\.rawValue.capitalized).joined(separator: ", "))"){
                    ForEach(AvailableLanguage.allCases) { item in
                        Toggle(isOn: Binding(
                            get: {selectedLanguages.contains(item)},
                            set: {isSelected in if isSelected{
                                selectedLanguages.append(item)
                            }else{
                                selectedLanguages.removeAll { $0 == item }
                            }
                        }
                        )){
                            Text(item.rawValue.capitalized)
                        }
                    }
                }
                
                Picker(selection: $city, label: Text("City:")) {
                    ForEach(City.allCases){ city in
                        Text("\(city.description)").tag(city)
                    }
                }
                Section{
                    Text("Bio")
                    TextEditor(text: $bio)
                }
            }
            
            Button{
                Task {
                    do {
                        profile = Profile.updateUser(_user_id: profile.user_id, _name: name, _email: email, _role: profile.role!, _birth_date: birth_date, _hobbies: selectedHobbies, _languages: selectedLanguages, _city: city!, _bio: bio, _rating: profile.rating!)
                        
                        if profile.role == .user{
                            let userUpdateDTO = profile.toUserUpdateDTO()
                            
                            let userUpdateResponse = try await userAPIService.updateUser(id: UUID(uuidString: profile.user_id)!, data: userUpdateDTO)
                            let authResponse = userUpdateResponse.toAuthResponse()
                            await MainActor.run {
                                if authResponse.isSuccess, let user = authResponse.user {
                                    print("✅ Updated User successful for id: \(user.name ?? "Unknown User")")
                                }
                            }
                        }else{
                            let mentorUpdateDTO = profile.toMentorUpdateDTO()
                            
                            let mentorUpdateResponse = try await mentorAPIService.updateMentor(id: UUID(uuidString: profile.user_id)!, data: mentorUpdateDTO)
                            let authResponse = mentorUpdateResponse.toMentorAuthResponse()
                            await MainActor.run {
                                if authResponse.isSuccess, let user = authResponse.user {
                                    print("✅ Updated Mentor successful for id: \(user.name ?? "Unknown User")")
                                }
                            }
                        }
                    }
                }
                
                                dismiss()
            }
            label:{
                    Text("Save")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isValid ? .gray : .teal)
                    }
                }.disabled(isValid)
            
            Spacer().frame(height: 50)
                .listRowSeparator(.hidden)
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationTitle("Edit User")
        .onAppear{
            name = profile.name!
            email = profile.email!
            birth_date = profile.birth_date!
            selectedHobbies = profile.hobbies!
            selectedLanguages = profile.languages!
            city = profile.city!
            bio = profile.bio!
        }
    }
}

#Preview {
    EditUserView(profile: .constant(Profile.testMentor))
}
