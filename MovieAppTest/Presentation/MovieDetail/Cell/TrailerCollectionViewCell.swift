//
//  TrailerCollectionViewCell.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit
import Combine

class TrailerCollectionViewCell: UICollectionViewCell {
    private lazy var trailerImage : UIImageView = UIImageView()
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trailerImage.image = nil
        trailerImage.alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
    struct Constants{
        static let cornerValue: CGFloat = 5.0
    }
    func setupData(video: Video){
        print("Video \(video.imgURL)")
        cancellable?.cancel()
        cancellable = loadImage(for: video.imgURL).sink { [unowned self] image in self.showImage(image: image) }

    }
    
    private func setupView(){
        setupTrailerImage()
        setupConstraint()
    }
    private func showImage(image: UIImage?){
        trailerImage.alpha = 0.0
        animator?.stopAnimation(false)
        trailerImage.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.trailerImage.alpha = 1.0
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
    
    private func setupTrailerImage(){
        trailerImage.roundCorners(radius: Constants.cornerValue)
    }
    private func setupConstraint(){
        contentView.addSubview(trailerImage)
        trailerImage.anchor(top: contentView.topAnchor, paddingTop: 0, bottom: contentView.bottomAnchor, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: 0, right: contentView.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
}
