//
//  MovieViewModel.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 01/06/24.
//

import Foundation

protocol MovieListener{
    func fetchGenreMovie()
}
class MovieViewModel: MovieListener{
    private var networkClient = NetworkSessionClient<MovieEndpoint>()
    var genres : [Genre] = [] {
        didSet{
            self.updateData?()
        }
    }
    var movies: [Movie] = []{
        didSet{
            self.updateMovieList?()
        }
    }
    private var currentPage: Int = 1
    private var totalPage: Int = 1
    var genreId: Int = 0
    var updateData: (() -> ())?
    var updateMovieList : (() -> ())?
    var showErrorMessage: ((String) -> ())?
    func fetchGenreMovie(){
        networkClient.requestData(.fetchGenre) { (_ result: Result<GenreResponse, NetworkError>) in
            switch result{
            case .success(let response):
                self.genres = response.genres
            case .failure(let failure):
                self.showErrorMessage?(failure.descriptionString)
            }
        }
    }
    
    func loadMoreMovies(){
        guard currentPage != totalPage else {return}
        currentPage += 1
        fetchMovieList()
    }
    func fetchMovieList(){
        let urlParams: Parameters = ["with_genres": genreId, "page": currentPage]
        networkClient.requestData(.fetchMovieByGenre(urlParam: urlParams)) { (_ result: Result<MovieListResults, NetworkError>) in
            switch result{
            case .success(let response):
                self.totalPage = response.totalPages
                self.movies.append(contentsOf: response.results)
            case .failure(let failure):
                self.showErrorMessage?(failure.descriptionString)
            }
        }
    }
    
}
