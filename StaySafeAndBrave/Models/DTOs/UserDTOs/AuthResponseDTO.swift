//
//  AuthResponseDTO.swift
//  StaySafeAndBrave
//
//  Created by Akif Emre Bozdemir on 7/3/25.
//

struct AuthResponseDTO: Codable {
    var user: UserResponseDTO?
    var token: String?
    var message: String?
    
    var isSuccess: Bool {
        return user != nil
    }
    
    init(from userResponse: UserResponseDTO) {
        self.user = userResponse
        self.token = nil
        self.message = nil
    }
}
