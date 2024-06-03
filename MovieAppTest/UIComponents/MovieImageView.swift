//
//  MovieImageView.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit
import Combine

class MovieImage: UIImageView{
    enum ImageStyle{
        case small
        case medium
        case big
        case rating
    }
    
    public private(set) var styleImg: ImageStyle
    

    private var cancellable: AnyCancellable?

    struct Constants{
        static let widthScreen = UIScreen.main.bounds.width
        static let ratingSize: CGFloat = 20
        static let smallSize: CGFloat = 40
        static let mediumSize: CGFloat = 80
        static let ratingImage = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
    }
    init(styleImg: ImageStyle) {
        self.styleImg = styleImg
        super.init(frame: .zero)
        configureImage()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init coder cant implement")
    }
    
    private func configureImage(){
        switch styleImg {
        case .small:
            self.setSize(width: Constants.smallSize, height: Constants.smallSize)

        case .medium:
            self.setSize(width: Constants.mediumSize, height: Constants.mediumSize * 1.5)

        case .big:
            self.setSize(width: Constants.widthScreen, height: Constants.widthScreen * 0.7)
        case .rating:
            self.setSize(width: Constants.ratingSize + 5.0, height: Constants.ratingSize)
            self.image = Constants.ratingImage
        }
    }
    
}
