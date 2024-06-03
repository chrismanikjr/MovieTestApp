//
//  TitleSupplementaryView.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit

class TitleSupplementaryView: UICollectionReusableView {
    let label = MovieLabel(labelText: "Title", color: .black, type: .header)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

extension TitleSupplementaryView {
    func configure() {
        addSubview(label)
        let inset = CGFloat(10)
        
        label.anchor(top: topAnchor, paddingTop: inset, bottom: bottomAnchor, paddingBottom: -inset, left: leadingAnchor, paddingLeft: 0, right: trailingAnchor, paddingRight: -inset, width: 0, height: 0)
    }
}
