//
//  MovieDetailViewController.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit
import WebKit
class MovieDetailViewController: UIViewController {
    
    private enum Section: String, CaseIterable{
        case detail
        case trailer = "Trailer"
        case review = "Review"
    }
    private var detailDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    private var detailCollection : UICollectionView! = nil
    private var detailVM = MovieDetailViewModel()
    var movieId: Int?{
        didSet{
            detailVM.movieId = self.movieId ?? 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observerViewModel()
        detailVM.loadAllApi()
    }
    
    private func observerViewModel(){
        detailVM.updateData = {[weak self]  in
            DispatchQueue.main.async{
                self?.configureDataSource()
            }
        }
    }
    
    private func setupView(){
        setupCollection()
        setupConstraint()
    }
    
    private func setupCollection(){
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(cell: DetailCollectionViewCell.self)
        collectionView.register(cell: TrailerCollectionViewCell.self)
        collectionView.register(cell: ReviewCollectionViewCell.self)
        collectionView.register(header: TitleSupplementaryView.self)
        collectionView.register(footer: FooterLoadingSupplementaryView.self)
        
        
        collectionView.collectionViewLayout.invalidateLayout()
        detailCollection = collectionView
    }
    private func setupConstraint(){
        self.view.addSubview(detailCollection)
        detailCollection.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 0, right: view.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        
    }
}
extension MovieDetailViewController{
    private func generateLayout() -> UICollectionViewLayout{
        let sectionProvider = {(sectionNumber: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionType = Section.allCases[sectionNumber]
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(30.0))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            switch sectionType{
            case .detail:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.7)), subitems: [item])
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.interGroupSpacing = 10
                
                return section
                
            case .trailer:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.6), heightDimension: .estimated(150)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            case .review:
                let estimatedHeight = CGFloat(150)
                
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(estimatedHeight))
                
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        
        
        return layout
    }
    
    private func configureDataSource(){
        detailDataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: detailCollection){ (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            
            
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType{
            case .detail:
                let cell: DetailCollectionViewCell = collectionView.dequeue(for: indexPath)
                if let movieDetail = self.detailVM.movieDetail{
                    cell.setupData(movieDetail: movieDetail)
                }
                
                return cell
            case .trailer:
                let cell: TrailerCollectionViewCell = collectionView.dequeue(for: indexPath)
                
                cell.setupData(video: self.detailVM.trailers[indexPath.row])
                
                return cell
            case .review:
                let cell: ReviewCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.setupData(review: self.detailVM.reviews[indexPath.row])
                return cell
            }
            
        }
        
        detailDataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType{
            case .trailer:
                switch kind{
                case UICollectionView.elementKindSectionHeader:
                    let headerSupplementaryView : TitleSupplementaryView = self.detailCollection.dequeue(for: indexPath, kind: kind)
                    headerSupplementaryView.label.text = self.detailVM.trailers.count > 0 ? sectionType.rawValue : "Doesn't Have Trailer"
                    
                    return headerSupplementaryView
                default:
                    return nil
                }
            case .review:
                switch kind{
                case UICollectionView.elementKindSectionHeader:
                    let headerSupplementaryView : TitleSupplementaryView = self.detailCollection.dequeue(for: indexPath, kind: kind)
                    headerSupplementaryView.label.text = self.detailVM.reviews.count > 0 ? sectionType.rawValue : "Doesn't Have Review"
                    
                    return headerSupplementaryView
                default:
                    return nil
                }
            default:
                return nil
            }
        }
        reloadCollectionView()
    }
    
    private func reloadCollectionView(){
        let snapshot = snapshotForCurrentState()
        detailDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AnyHashable>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.detail])
        snapshot.appendItems([detailVM.movieDetail], toSection: .detail)
        snapshot.appendSections([.trailer])
        snapshot.appendItems(detailVM.trailers, toSection: .trailer)
        snapshot.appendSections([.review])
        snapshot.appendItems(detailVM.reviews, toSection: .review)
        return snapshot
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = Section.allCases[indexPath.section]
        switch sectionType{
        case .trailer:
            print("Video open")
            if let videoUrl = URL(string: detailVM.trailers[indexPath.row].videoUrl) {
                playYouTubeVideo(videoUrl)
            }
        default:
            break
        }
    }
    
    private func playYouTubeVideo(_ youtubeURL: URL) {
        let webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        webView.load(URLRequest(url: youtubeURL))
        
        let viewController = UIViewController()
        viewController.view.addSubview(webView)
        viewController.modalPresentationStyle = .fullScreen
        
        let closeButton = UIButton(type: .close)
        closeButton.addTarget(self, action: #selector(closeYouTubeVideo), for: .touchUpInside)
        viewController.view.addSubview(closeButton)

        closeButton.anchor(top: viewController.view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: viewController.view.safeAreaLayoutGuide.leadingAnchor, paddingLeft: 16, right: nil, paddingRight: 0, width: 0, height: 0)
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func closeYouTubeVideo() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let sectionType = Section.allCases[indexPath.section]
        switch sectionType{
        case .review:
            if indexPath.row == detailVM.reviews.count - 1{
                detailVM.loadMoreMovieReview()
            }
        default:
            break
        }
    }
}
