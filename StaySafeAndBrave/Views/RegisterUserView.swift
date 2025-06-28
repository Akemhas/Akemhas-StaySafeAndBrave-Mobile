//
//  RegisterUserView.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 03.06.25.
//

import SwiftUI

struct RegisterUserView: View {
    //@Bindable var user: User
    @State var isEditing: Bool? = false
    @State var Mentor: Bool? = nil
    @State private var new_userName: String = "Name"
    @State private var new_profile_image: String = ""
    @State private var new_score: Float = 0.0
    @State private var new_date_of_birth: Date = Date()
    @State private var new_bio: String = "This is the Bio, write about yourself :)"
    /*@State private var new_languages: [AvailableLanguage] = []
    @State private var language_selection = AvailableLanguage.english
    @State private var new_location: City = .capeTown*/
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeat_password: String = ""
    
    var body: some View {
        if(isEditing!){
            Form {
                TextField("Email", text: .constant(""))
                SecureField("Password", text: .constant(""))
                SecureField("Repeat Password", text: .constant(""))
                
            }
        }
        else{
            Form {
                TextField("Name", text: $new_userName)
                DatePicker("Birthdate", selection: $new_date_of_birth, displayedComponents: .date)
                
                /*Picker("Location", selection: $new_location){
                    ForEach(City.allCases, id: \.self){value in
                        Text(value.rawValue)
                    }
                }
                
                Picker("Language", selection: $language_selection) {
                    ForEach(AvailableLanguage.allCases, id: \.self) { value in
                        Text(value.rawValue)
                    }
                }
                
                
                Button(action: {
                    new_languages.append(AvailableLanguage(rawValue: language_selection.rawValue)!)
                }){
                    Text("Add Language")
                }
                
                
                
                HStack{
                    Text("Languages: ")
                    ForEach(new_languages, id: \.self) {language in
                        Text("\(language)")
                    }
                }
                
                /* Button(action: {
                 new_languages.append(AvailableLanguage(rawValue: language_selection)!)
                 }){
                 Text("Add Language")
                 }
                 */
                
                /* Picker("Language", selection: $language_selection) {
                 ForEach(AvailableLanguage.allCases, id: \.self) {
                 new_languages.append($0.rawValue)
                 }*/
                
                */
                TextField("Email", text: .constant(""))
                SecureField("Password", text: .constant(""))
                SecureField("Repeat Password", text: .constant(""))
                Button(action: registerUser) {
                    Text("Register as user")
                }
                //TextEditor(text: $new_bio)
                
                //DatePicker("Birthdate")
            }
        }
        
    }
    func registerUser() {
        // Register user DTOs
        
        // If successful go to main view
    }
}

#Preview {
    RegisterUserView()
}
