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
        case rating
    }
    
    public private(set) var styleImg: ImageStyle
    

   struct Constants{
        static let ratingWidthSize: CGFloat = 25
        static let ratingHeightSize: CGFloat = 20
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
        case .rating:
            self.setSize(width: Constants.ratingWidthSize, height: Constants.ratingHeightSize)
            self.image = Constants.ratingImage
        }
    }
    
}
