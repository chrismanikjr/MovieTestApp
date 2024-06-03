//
//  DetailCollectionViewCell.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit
import Combine

class DetailCollectionViewCell: UICollectionViewCell {
    private lazy var movieImage : UIImageView = UIImageView()
    private lazy var titleLabel: MovieLabel = MovieLabel(labelText: "", color: .black, type: .header)
    private lazy var topStack : MovieStackView = MovieStackView(type: .horizontal, alignmentStack: .center, distributionStack: .fill, spacingStack: 5)
    
    private lazy var ratingImage: MovieImage = MovieImage(styleImg: .rating)
    private lazy var ratingLabel: MovieLabel = MovieLabel(labelText: "", color: .black, type: .rating)
    private lazy var ratingStack: MovieStackView = MovieStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)

    private lazy var descLabel: MovieLabel = MovieLabel(labelText: "Desc", color: .black, type: .desc)

    private lazy var releasedLabel: MovieLabel = MovieLabel(labelText: "", color: .black, type: .rating)
    private lazy var runtimeLabel: MovieLabel = MovieLabel(labelText: "", color: .black, type: .rating)
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?

    struct Constants{
        static let padding = 20.0
        static let spacing = 10.0
        static let shadowValue: CGFloat = 4.0
        static let cornerValue: CGFloat = 5.0

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(movieDetail: MovieDetail){
        cancellable?.cancel()
        cancellable = loadImage(for: movieDetail.imgURL).sink { [unowned self] image in self.showImage(image: image) }

        titleLabel.text = movieDetail.title
        ratingLabel.text = movieDetail.voteAverage.ratingFormat()
        releasedLabel.text = movieDetail.releaseDate.extractYear()
        runtimeLabel.text = movieDetail.runtime.toHoursMinutes()
        descLabel.text = movieDetail.overview
    }
    
    func setupUI(){
        self.backgroundColor = .white
        setupConstraint()
        descLabel.numberOfLines = 0

    }
    
    private func showImage(image: UIImage?){
        movieImage.alpha = 0.0
        animator?.stopAnimation(false)
        movieImage.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.movieImage.alpha = 1.0
        })
    }
    
    private func loadImage(for imgUrlString: String) -> AnyPublisher<UIImage?, Never> {
        return Just(imgUrlString)
            .flatMap({ imgUrl -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: imgUrlString)!
                return ImageLoader.shared.loadImage(from: url)
            })
            .eraseToAnyPublisher()
    }
    
    private func setupConstraint(){
        
        [movieImage, titleLabel, topStack, descLabel].forEach{self.addSubview($0)}
        [ratingImage, ratingLabel].forEach{ratingStack.addArrangedSubview($0)}

         [ratingStack, releasedLabel, runtimeLabel].forEach{topStack.addArrangedSubview($0)}
        ratingStack.setSize(width: 80, height: 0)
        releasedLabel.setSize(width: 50, height: 0)
        topStack.setSize(width: 0, height: 25)
        movieImage.anchor(top: self.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: 0, right: self.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        titleLabel.anchor(top: movieImage.bottomAnchor, paddingTop: Constants.spacing, bottom: nil, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: Constants.padding, right: self.trailingAnchor, paddingRight: -Constants.padding, width: 0, height: 25)
        topStack.anchor(top: titleLabel.bottomAnchor, paddingTop: Constants.spacing, bottom: nil, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: Constants.padding, right: self.trailingAnchor, paddingRight: -Constants.padding, width: 0, height: 0)
        
        
        descLabel.anchor(top: topStack.bottomAnchor, paddingTop: Constants.spacing, bottom: self.bottomAnchor, paddingBottom: -Constants.spacing, left: self.leadingAnchor, paddingLeft: Constants.padding, right: self.trailingAnchor, paddingRight: -Constants.padding, width: 0, height: 100)
    }

}
