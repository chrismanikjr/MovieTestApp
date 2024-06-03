//
//  Video.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 01/06/24.
//

import Foundation

struct VideoResponse: Codable{
    var id: Int
    var results: [Video]
}

struct Video: Codable, Hashable{
    var name: String
    var type: String
    var site: String
    var key: String
    
    var videoUrl: String {
        return AppConfiguration().videoBaseURL + key
    }
    var imgURL: String{
            return "\(AppConfiguration().imgVideoURL)\(key)/default.jpg"
    }
}
