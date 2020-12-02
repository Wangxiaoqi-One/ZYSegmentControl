//
//  ZYSegmentTitleCell.swift
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/9/1.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

import UIKit

class ZYSegmentTitleCell: UICollectionViewCell {
    
    private var  config: Configuration!
    
    public var isChecked: Bool = false{
        didSet {
            self.updateCell(isChecked: self.isChecked)
        }
    }
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: self.contentView.frame)
        label.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .black
        return label
    }()
    
    private var rightline: UIView = {
        let line = UIView()
        line.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        line.backgroundColor = UIColor(red: 233 / 255.0, green: 233 / 255.0, blue: 233 / 255.0, alpha: 1.0)
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSunviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZYSegmentTitleCell {
    
    func setCell(config:Configuration, title: String, isMaxItem: Bool){
        self.config = config
        self.titleLabel.text = title
        self.titleLabel.font = self.config?.titleFont
        self.titleLabel.textColor = self.config.titleColor
        self.rightline.isHidden = self.config.isShowSeparator ? isMaxItem : false

    }
    
    func updateCellTitle(isChecked: Bool, animated: Bool) {
        let color = isChecked ? self.config.selectedColor : self.config.titleColor
        self.titleLabel.textColor = color
        
    }
}

fileprivate extension ZYSegmentTitleCell {
    func createSunviews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.rightline)
        
        //设置frame
        let left = self.bounds.width - 1
        let top = self.bounds.height * 0.3
        let height = self.bounds.height * 0.4
        self.rightline.frame = CGRect(x: left, y: CGFloat(top), width: 1, height: height)
    }
    
    func updateCell(isChecked: Bool){
        
        if isChecked {
            self.titleLabel.textColor = self.config.selectedColor
        }
        else {
            self.titleLabel.textColor = self.config.titleColor
        }
        
    }
    
}
