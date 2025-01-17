//
//  MovieEndpoint.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 01/06/24.
//

import Foundation

public enum MovieEndpoint{
    case fetchGenre
    case fetchMovie
    case fetchMovieByGenre(urlParam: Parameters)
    case fetchMovieDetail(movieId: Int)
    case fetchMovieReview(movieId: Int, urlParam: Parameters)
    case fetchMovieTrailer(movieId: Int)
}

extension MovieEndpoint: EndPointType{
    var baseUrl: URL {
       return URL(string: AppConfiguration().apiBaseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchGenre:
            return "/3/genre/movie/list"
        case .fetchMovie, .fetchMovieByGenre:
           return "/3/discover/movie"
        case .fetchMovieDetail(let movieId):
            return "/3/movie/\(movieId)"
        case .fetchMovieReview(let movieId, _):
            return  "/3/movie/\(movieId)/reviews"
        case .fetchMovieTrailer(let movieId):
            return "/3/movie/\(movieId)/videos"
        }
    }
    
    var httpMethod: HttpMethodType {
        return .get
    }
    
    var task: HttpTask {
        switch self{
        case .fetchMovieByGenre(let urlParams), .fetchMovieReview(_ , let urlParams):
            return .requestParameters(encoding: .urlEncoding, urlParameters: urlParams, addtionHeaders: headers)
        default:
            return .request(addtionHeaders: headers)
        }
    }
    
    var headers: HttpHeaders? {
        return ["Authorization": "Bearer \(AppConfiguration().apiToken)"]
    }    
}
