//
//  MovieCollectionViewCell.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit
import Combine

class MovieCollectionViewCell: UICollectionViewCell {
    private lazy var movieImage: UIImageView = UIImageView()
    private lazy var titleLabel: MovieLabel = MovieLabel(labelText: "Title", color: .black, type: .subtitle, alignment: .left)
    private lazy var infoStackView: MovieStackView = MovieStackView(type: .horizontal, alignmentStack: .center, distributionStack: .fill, spacingStack: 5)
    private lazy var ageStatusLabel: MovieLabel = MovieLabel(labelText: "Age", color: .black, type: .desc)
    private lazy var releaseDate: MovieLabel = MovieLabel(labelText: "ReleaseData", color: .systemGray, type: .desc)
    
    private lazy var ratingStack : MovieStackView = MovieStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)
    private lazy var ratingImage: MovieImage = MovieImage(styleImg: .rating)
    private lazy var ratingLabel: MovieLabel = MovieLabel(labelText: "Rating", color: .black, type: .rating)
    
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    struct Constants{
        static let insetValue: CGFloat = 2.0
        static let padding: CGFloat = 5.0
        static let shadowValue: CGFloat = 4.0
        static let cornerValue: CGFloat = 5.0

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        movieImage.alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
    
    func setupData(movie: Movie){
        titleLabel.text = "\(movie.originalTitle)"
        ageStatusLabel.text = movie.adult ? "D 17+" : "R 13+"
        ageStatusLabel.textColor = movie.adult ? UIColor.red : UIColor.black
        releaseDate.text = movie.releaseDate.extractYear()
        ratingLabel.text = movie.voteAverage.ratingFormat()
        cancellable?.cancel()
        cancellable = loadImage(for: movie.imgURL).sink { [unowned self] image in self.showImage(image: image) }
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
    
    private func setupView(){
        setupContentView()
        setupMovieImage()
        setupTitleLabel()
        setupAgeStatus()
        setupInformation()
        setupRating()
        setupConstraint()
    }
    
    private func setupMovieImage(){
        movieImage.clipsToBounds = true
        movieImage.roundCorners(radius: Constants.padding)
    }
    
    public func setupTitleLabel(){
        titleLabel.numberOfLines = 2
    }
    private func setupContentView(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = Constants.shadowValue
        layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerValue
        contentView.layer.masksToBounds = true
    }
    
    
    private func setupInformation(){
        setupAgeStatus()
        [ageStatusLabel, releaseDate].forEach{infoStackView.addArrangedSubview($0)}
    }
    private func setupAgeStatus(){
        ageStatusLabel.marginInsets = UIEdgeInsets(top: Constants.insetValue, left: Constants.insetValue, bottom: Constants.insetValue, right: Constants.insetValue)
        ageStatusLabel.backgroundColor = UIColor.lightGray
        ageStatusLabel.clipsToBounds = true
        ageStatusLabel.layer.cornerRadius = Constants.insetValue
        ageStatusLabel.text =  ""
    }
    
    private func setupRating(){
        [ratingImage, ratingLabel].forEach{ratingStack.addArrangedSubview($0)}
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint(){
        [movieImage, titleLabel, infoStackView, ratingStack].forEach{contentView.addSubview($0)}
        movieImage.anchor(top: contentView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: 0, right: contentView.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        
        titleLabel.anchor(top: movieImage.bottomAnchor, paddingTop: Constants.padding, bottom: nil, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: Constants.padding, right: contentView.trailingAnchor, paddingRight: -Constants.padding, width: 0, height: 50)
        ageStatusLabel.setSize(width: 40, height: 25)

        infoStackView.anchor(top: titleLabel.bottomAnchor, paddingTop: Constants.padding, bottom: nil, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: Constants.padding, right: contentView.trailingAnchor, paddingRight: -Constants.padding, width: 0, height: 25)
        
        ratingStack.anchor(top: infoStackView.bottomAnchor, paddingTop: Constants.insetValue, bottom: contentView.bottomAnchor, paddingBottom: -Constants.padding, left: contentView.leadingAnchor, paddingLeft: Constants.padding, right: contentView.trailingAnchor, paddingRight: -Constants.padding, width: 0, height: 20)
    }
}
