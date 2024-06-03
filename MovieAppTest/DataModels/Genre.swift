//
//  Genre.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 01/06/24.
//

import Foundation

struct GenreResponse: Codable{
    var genres: [Genre]
}

struct Genre: Codable, Hashable{
    var id: Int
    var name: String
}
