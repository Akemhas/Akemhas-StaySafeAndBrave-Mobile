//
//  RowListView.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 15.05.25.
//

import SwiftUI

struct MentorRowListView: View {
    let mentor:Mentor
    var body: some View {
        Button(action: goToMentoDetailView){
            VStack{
                HStack{
                    //replaces the AsyncImage implementation
                    AsyncCachedImage(url: URL(string: "\(mentor.profile_image)"),
                    ){ image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 300)
                        
                        
                        //.frame(minWidth: 100, minHeight: 100)
                        // .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                    } placeholder: {
                        ProgressView()
                            .frame(minWidth: 100,minHeight: 100)
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                    }
                    .padding(.bottom,5)
                }
                
                // Name, age and score
                HStack{
                    Text("\(mentor.name), \(mentor.age)")
                        .font(.headline)
                        .foregroundStyle(.teal)
                    
                    Spacer()
                    SFSymbol.star.foregroundStyle(.black)
                    
                    Text("\(mentor.score, specifier: "%.1f")")
                        .foregroundStyle(.black)
                    
                }
                // mentor location
                HStack {
                    Text("(\(mentor.location.description))")
                        .font(.headline)
                        .foregroundStyle(.teal)
                    
                    Spacer()
                }
                //display languages
                HStack{
                    Text("Speaks: ")
                    printLanguages(languages: mentor.languages!)
                    
                    Spacer()
                }.foregroundStyle(.black)
                    .font(.caption)
                // display hobbies
                HStack{
                    Text("Hobbies: ")
                    
                    
                    printHobbies(hobbies: mentor.hobbies ?? [])
                    Spacer()
                }.foregroundStyle(.black)
                    .font(.caption)
            }
        }
        
    }
    /// Receives a list of AvailableLanguages, iterates through then and displays them.
    func printLanguages(languages: [AvailableLanguage])->some View{
        HStack{
            ForEach(languages){language in
                Text("\(language)")
                    .background(.gray)
                    .opacity(0.5)
                
                //Text("\(language.level)")
            }
        }
    }
    // Receives a list of Hobby(ies), iterates through then and displays them.
    func printHobbies(hobbies: [Hobby])->some View{
        HStack{
            ForEach(hobbies){hobbie in
                Text("\(hobbie)")
                    .background(.gray)
                    .opacity(0.5)
                
            }
        }
    }
}

#Preview {
    
    MentorRowListView(mentor:createMentorLeonie())
}

func goToMentoDetailView(){
    
}


