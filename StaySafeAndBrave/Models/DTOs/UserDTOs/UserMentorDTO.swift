//
//  UserMentorDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

//import Foundation
//
//struct UserMentorDTO: Codable {
//    var id: UUID?
//    var mentorID: UUID?
//    var name: String?
//    var email: String?
//    var password: String?
//    var role: String?
//    var birth_date: String?
//    var location: String?
//    var bio: String?
//    var profile_image: String?
//    var score: Float?
//    var languages: [String]?
//    var hobbies: [String]?
//
//    init(
//        id: UUID? = nil,
//        mentorID: UUID? = nil,
//        name: String? = nil,
//        email: String? = nil,
//        password: String? = nil,
//        role: String? = nil,
//        birth_date: String? = nil,
//        location: String? = nil,
//        bio: String? = nil,
//        profile_image: String? = nil,
//        score: Float? = nil,
//        languages: [String]? = nil,
//        hobbies: [String]? = nil
//    ) {
//        self.id = id
//        self.mentorID = mentorID
//        self.name = name
//        self.email = email
//        self.password = password
//        self.role = role
//        self.birth_date = birth_date
//        self.location = location
//        self.bio = bio
//        self.profile_image = profile_image
//        self.score = score
//        self.languages = languages
//        self.hobbies = hobbies
//    }
//}
//
//extension UserMentorDTO {
//    func toUserResponseDTO() -> UserResponseDTO {
//          return UserResponseDTO(
//              id: self.id,
//              mentorID: self.mentorID,
//              name: self.name,
//              email: self.email,
//              role: self.role,
//              birth_date: self.birth_date,
//              profile_image: self.profile_image,
//              score: self.score,
//              bio: self.bio,
//              location: self.location,
//              languages: self.languages,
//              hobbies: self.hobbies
//          )
//      }
//      
//      func toAuthResponse() -> AuthResponseDTO {
//          return self.toUserResponseDTO().toAuthResponse()
//      }
//}
