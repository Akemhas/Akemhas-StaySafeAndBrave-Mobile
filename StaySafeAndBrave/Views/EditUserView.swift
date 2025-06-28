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
    @State private var selectedLangauges: [myLanguage] = []
    @State private var selectedHobbies: [Hobby] = []
    
    @State private var city: City?
    @State private var bio: String = ""
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    
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
            
            DisclosureGroup("Languages: \(selectedLangauges.map (\.rawValue.capitalized).joined(separator: ", "))"){
                ForEach(myLanguage.allCases) { item in
                    Toggle(isOn: Binding(
                        get: {selectedLangauges.contains(item)},
                        set: {isSelected in if isSelected{
                            selectedLangauges.append(item)
                        }else{
                            selectedLangauges.removeAll { $0 == item }
                        }
                    }
                    )){
                        Text(item.rawValue.capitalized)
                    }
                }
            }
            
            if profile.role == .mentor{
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
                profile = Profile.updateUser(_user_id: profile.user_id, _name: name, _email: email, _role: profile.role!, _birth_date: birth_date, _hobbies: selectedHobbies, _langauges: selectedLangauges, _city: city!, _bio: bio, _rating: profile.rating!)
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
            selectedLangauges = profile.languages!
            city = profile.city!
            bio = profile.bio!
        }
    }
}

#Preview {
    EditUserView(profile: .constant(Profile.testMentor))
}
