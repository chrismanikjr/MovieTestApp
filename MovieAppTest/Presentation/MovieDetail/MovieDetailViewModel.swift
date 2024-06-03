//
//  MovieDetailViewModel.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import Foundation

class MovieDetailViewModel{
    private var networkClient = NetworkSessionClient<MovieEndpoint>()
    var movieId: Int = 0
    var movieDetail: MovieDetail?
    var trailers: [Video] = []
    var reviews: [MovieReview] = []
    var showErrorMessage: ((String) -> ())?
    
    var updateData: (() -> ())?
    private var currentReviewPage: Int = 1
    private var totalReviewPage: Int = 1

    func loadAllApi(){
        let group = DispatchGroup()
        group.enter()
        
        fetchMovieDetail { movieDetail in
            self.movieDetail = movieDetail
            group.leave()
        }
        
        group.enter()
        fetchMovieTrailer { movieTrailers in
            self.trailers = movieTrailers
            group.leave()
        }
        
        group.enter()
        fetchMovieReview { movieReviews in
            self.reviews = movieReviews
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.updateData?()
        }
        
    }
    func fetchMovieDetail(completion: @escaping(MovieDetail) -> ()){
        networkClient.requestData(.fetchMovieDetail(movieId: movieId)) { (_ result: Result<MovieDetail, NetworkError>) in
            switch result{
            case .success(let response):
                completion(response)
            case .failure(let failure):
                self.showErrorMessage?(failure.descriptionString)
            }
        }
    }
    
    func fetchMovieTrailer(completion: @escaping([Video]) -> ()){
        networkClient.requestData(.fetchMovieTrailer(movieId: movieId)) { (_ result: Result<VideoResponse, NetworkError>) in
            switch result{
            case .success(let response):
                completion(response.results)
            case .failure(let failure):
                self.showErrorMessage?(failure.descriptionString)
            }
        }
    }
    func loadMoreMovieReview(){
        guard currentReviewPage != totalReviewPage else {return}
        currentReviewPage += 1
        fetchMovieReview { movieReviews in
            self.reviews.append(contentsOf: movieReviews)
        }
    }
    
    func fetchMovieReview(completion: @escaping([MovieReview]) -> ()){
        let urlParams: Parameters = ["page": currentReviewPage]
        networkClient.requestData(.fetchMovieReview(movieId: movieId, urlParam: urlParams)) { (_ result: Result<MovieReviewsResponse, NetworkError>) in
            switch result{
            case .success(let response):
                self.totalReviewPage = response.totalPages
                completion(response.results)
            case .failure(let failure):
                self.showErrorMessage?(failure.descriptionString)
            }
        }
    }
    
}
