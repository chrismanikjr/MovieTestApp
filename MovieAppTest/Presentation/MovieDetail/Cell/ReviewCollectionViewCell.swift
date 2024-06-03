//
//  ReviewCollectionViewCell.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    
    private lazy var nameLabel: MovieLabel = MovieLabel(labelText: "Name", color: .black, type: .title, alignment: .left)
    private lazy var ratingImage: MovieImage = MovieImage(styleImg: .rating)
    private lazy var ratingLabel: MovieLabel = MovieLabel(labelText: "Rating", color: .black, type: .rating)
    private lazy var ratingStack: MovieStackView = MovieStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)
    private lazy var releasedLabel: MovieLabel = MovieLabel(labelText: "ReleasedDate", color: .systemGray, type: .desc, alignment: .right)
    private lazy var contentLabel: MovieLabel = MovieLabel(labelText: "Content Label", color: .systemGray, type: .desc, alignment: .justified)
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More", for: .normal)
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var profilStack: MovieStackView = MovieStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 10)
    private lazy var fullStack: MovieStackView = MovieStackView(type: .vertical, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)
    
    struct Constants {
        static let padding: CGFloat = 7.0
        static let cornerValue: CGFloat = 5.0
        static let shadowValue: CGFloat = 4.0
    }
    
    private var isExpanded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(review: MovieReview) {
        nameLabel.text = review.author
        ratingLabel.text = "\(review.authorDetails.rating ?? 0)"
        releasedLabel.text = review.createdAt.toDateString()
        contentLabel.attributedText = attributedText(text: review.content)
        contentLabel.numberOfLines = isExpanded ? 0 : 3 // Show 3 lines initially or all lines if expanded
        moreButton.setTitle(isExpanded ? "Less" : "More", for: .normal)
    }
    
    @objc private func didTapMoreButton() {
        isExpanded.toggle()
        contentLabel.numberOfLines = isExpanded ? 0 : 5
        moreButton.setTitle(isExpanded ? "Less" : "More", for: .normal)
        // Notify the collection view to update layout
        if let collectionView = self.superview as? UICollectionView {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func attributedText(text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineSpacing = 1
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    private func setupUI() {
        setupConstraint()
        setupContentView()
    }
    
    private func setupContentView() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = Constants.shadowValue
        layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerValue
        contentView.layer.masksToBounds = true
    }
    
    private func setupConstraint() {
        contentView.addSubview(fullStack)
        [ratingImage, ratingLabel, releasedLabel].forEach { ratingStack.addArrangedSubview($0) }
        [ratingStack, nameLabel, contentLabel, moreButton].forEach { fullStack.addArrangedSubview($0) }
        fullStack.anchor(top: contentView.topAnchor, paddingTop: Constants.padding, bottom: contentView.bottomAnchor, paddingBottom: -Constants.padding, left: contentView.leadingAnchor, paddingLeft: Constants.padding, right: contentView.trailingAnchor, paddingRight: -Constants.padding, width: 0, height: 0)
    }
}
