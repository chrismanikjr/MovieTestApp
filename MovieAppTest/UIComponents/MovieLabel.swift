//
//  MovieLabel.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 02/06/24.
//

import UIKit

class MovieLabel: UILabel{
    enum LabelType{
        case header
        case title
        case subtitle
        case desc
        case rating
    }

    public private(set) var labelText: String
    public private(set) var color: UIColor
    public private(set) var type: LabelType
    public private(set) var alignment: NSTextAlignment?
    public var marginInsets = UIEdgeInsets.zero

    init(labelText: String, color: UIColor, type: LabelType, alignment: NSTextAlignment? = .left) {
        self.labelText = labelText
        self.color = color
        self.type = type
        self.alignment = alignment
        super.init(frame: .zero)
        self.configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(){
        self.text = labelText
        self.textColor = color
        self.textAlignment = alignment ?? .left
        configureLabelStyle()
    }
    
    func configureLabelStyle(){
        switch type {
        case .header:
            self.font = UIFont.boldSystemFont(ofSize: 20)
        case .title:
            self.font = UIFont.boldSystemFont(ofSize: 17)
        case .subtitle:
            self.font = UIFont.boldSystemFont(ofSize: 17)
        case .desc:
            self.font = UIFont.systemFont(ofSize: 12)
        case .rating:
            self.font = UIFont.boldSystemFont(ofSize: 13)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0

    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: marginInsets))
    }
    
    open override var intrinsicContentSize: CGSize {
        return addMargins(to: super.intrinsicContentSize)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addMargins(to: super.sizeThatFits(size))
    }
    
    private func addMargins(to size: CGSize) -> CGSize {
        let width = size.width + marginInsets.left + marginInsets.right
        let height = size.height + marginInsets.top + marginInsets.bottom
        return CGSize(width: width, height: height)
    }
    
}
