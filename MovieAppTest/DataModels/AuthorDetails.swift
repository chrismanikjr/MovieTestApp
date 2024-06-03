//
//  AuthorDetails.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 01/06/24.
//

import Foundation

struct AuthorDetails: Codable, Hashable{
    var name: String?
    var username: String
    var avatarPath: String?
    var rating: Int?
    var imgURL: String{
        if let avatarPath = avatarPath{
            return "\(AppConfiguration().imgBaseURL)\(avatarPath)"

        }
        return ""
    }
    enum CodingKeys: String, CodingKey{
        case name, username, rating
        case avatarPath = "avatar_path"
    }
}
