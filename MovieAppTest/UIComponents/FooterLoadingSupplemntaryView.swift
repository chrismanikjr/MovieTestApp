//
//  FooterLoadingSupplemntaryView.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit

class FooterLoadingSupplementaryView: UICollectionReusableView {
    
    let refreshControl = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

extension FooterLoadingSupplementaryView {
    func configure() {
        addSubview(refreshControl)
        refreshControl.center(centerX: centerXAnchor, centerY: centerYAnchor)
    }
}
