//
//  LearningSequenceCollectionViewCell.swift
//  edX
//
//  Created by Zeeshan Arif on 6/21/18.
//  Copyright © 2018 edX. All rights reserved.
//

import UIKit

class LearningSequenceCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LearningSequenceCollectionViewCell"
    private let IconFontSize : CGFloat = 15
    private let IconSize = CGSize(width: 16, height: 16)
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = OEXStyles.shared().primaryBaseColor()
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    var item: CourseOutlineQuerier.GroupItem? {
        didSet {
            guard let item = item else { return }
            switch item.block.displayType {
            case .Video:
                setContentIcon(icon: .CourseVideoContent)
                break
            case .HTML(.Base):
                setContentIcon(icon: .CourseHTMLContent)
                break
            case .HTML(.Problem):
                setContentIcon(icon: .CourseProblemContent)
                break
            case .Unknown:
                setContentIcon(icon: .CourseUnknownContent)
                break
            case .Outline, .Unit:
                break
            case .Discussion:
                setContentIcon(icon: .Discussions)
                break
            }
        }
    }
    
    func setContentIcon(icon : Icon?) {
        imageView.image = icon?.imageWithFontSize(size: IconFontSize)
        setNeedsUpdateConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(indicatorView)
        addSubview(imageView)
        setConstraints()
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(IconSize.height)
            make.width.equalTo(IconSize.width)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.bottom.equalTo(contentView)
            make.width.equalToSuperview()
        }
    }
    
}
