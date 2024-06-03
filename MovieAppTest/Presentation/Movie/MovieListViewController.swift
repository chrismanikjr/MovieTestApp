//
//  MovieListViewController.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit

class MovieListViewController: UIViewController {
    
    private enum Section: String, CaseIterable{
        case movieList = "MovieList"
    }
    private var movieDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    private var movieCollection : UICollectionView! = nil
    
    var viewModel = MovieViewModel()
    var genre: Genre?
    struct Constants{
        static let padding: CGFloat = 10.0
        static let spacing: CGFloat = 20.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observerViewModel()
        if let genre = genre{
            title = "\(genre.name)'s Movie"
            viewModel.genreId = genre.id
            viewModel.fetchMovieList()
        }
    }
    
    private func observerViewModel(){
        viewModel.updateMovieList  = {[weak self] in
            DispatchQueue.main.async {
                self?.configureDataSource()
            }
        }
        viewModel.showErrorMessage = {[weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func showErrorAlert(message: String){
        DispatchQueue.main.async {
            AlertHelper.present(title: "Error", actions: .close, message: message, from: self)
        }
    }
    
    private func setupView(){
        view.backgroundColor = .white
        navigationItem.backButtonTitle = " "
        setupCollectionView()
        setupConstraint()
    }
    private func setupCollectionView(){
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.register(cell: MovieCollectionViewCell.self)
        movieCollection = collectionView
    }
    
    private func setupConstraint(){
        self.view.addSubview(movieCollection)
        movieCollection.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 0, right: view.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
}

extension MovieListViewController{
    private func generateLayout() -> UICollectionViewLayout{
        let sectionProvider = {(sectionNumber: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            group.interItemSpacing = .fixed(Constants.padding)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = NSDirectionalEdgeInsets(top: Constants.padding, leading: Constants.padding, bottom: 0, trailing: Constants.padding)
            section.interGroupSpacing = Constants.padding
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constants.spacing
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        
        return layout
    }
    
    private func configureDataSource(){
        movieDataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: movieCollection){ (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            let cell : MovieCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.setupData(movie: self.viewModel.movies[indexPath.row])
            return cell
        }
        reloadCollectionView()
    }
    
    private func reloadCollectionView(){
        let snapshot = snapshotForCurrentState()
        movieDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AnyHashable>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.movieList])
        snapshot.appendItems(viewModel.movies, toSection: .movieList)
        return snapshot
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = MovieDetailViewController()
        detailVC.movieId = viewModel.movies[indexPath.row].id
        detailVC.movieName = viewModel.movies[indexPath.row].title
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.count - 1 {
            viewModel.loadMoreMovies()
        }
    }
}

