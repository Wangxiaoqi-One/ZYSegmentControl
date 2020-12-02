//
//  ZYSegementView.swift
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/9/1.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

import UIKit

@objc protocol ZYSegmentViewDelegate: NSObjectProtocol {
    @objc optional func segmentView(_ page: ZYSegementView, at index: Int)
}

class ZYSegementView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public weak var delegate: ZYSegmentViewDelegate?
    
    private let ZYCellID: String = "ZYCellID"
    private var config: Configuration!
    private var titles: [String] = []
    private var titleSizes: [CGSize] = []
    private var cellSizes: [Int: CGSize] = [:]
    private var indicatorRects: [Int: CGRect] = [:]
    private var titlesTotalWidth: CGFloat = 0.0
    private var selectedIndex: Int = 0
    
    
    //懒加载
    private lazy var layout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
        
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ZYSegmentTitleCell.self, forCellWithReuseIdentifier: ZYCellID)
        
        
        return collectionView
        
    }()
    
    private lazy var indicator: UIView = {
        let indicator = UIView()
        indicator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        indicator.backgroundColor = .red
        indicator.layer.cornerRadius = 1.5
        return indicator
    }()

    convenience init(frame: CGRect, config: Configuration, titles: [String]) {
        self.init(frame: frame)
        self.setupSegmentTitleView(config:config, titles:titles)
    }
}

extension ZYSegementView {
    
    func setupSegmentTitleView(config:Configuration, titles: [String]) {
        self.config = config
        self.titles = titles
        self.indicator.backgroundColor = self.config.selectedColor
        self.setupSubviews()
        self.updateConfiguration()
        self.setSelectIndex(at: 0)
    }
    
    func setSelectIndex(at index: Int, animated: Bool = false){
        self.collectionView.performBatchUpdates({
        }){[weak self] (finish) in
            self?.setSelectedCell(at: index, animated: animated)
            self?.setSelectedIndicator(at: index, animated: animated)
        }
    }
    
    func setSegmentTitleView(selectIndex: Int, willSelectIndex: Int, progress: CGFloat){
        self.scrollTo(selectIndex: selectIndex, willSelectIndex: willSelectIndex, progress: progress)
    }
    
    func setConfiguration(config: Configuration){
        self.config = config
        self.updateConfiguration()
        self.collectionView.reloadData()
    }
    
    func setTitles(titles: [String]){
        self.titles = titles
        self.updateConfiguration()
        self.collectionView.reloadData()
    }
    
    func setTitle(title: String, for index: Int) {
        self.titles[index] = title
        self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func titleForIndex(at index: Int) -> String {
        return self.titles[index]
    }
    
}


fileprivate extension ZYSegementView {
    func setupSubviews() {
        self.addSubview(self.collectionView)
        self.collectionView.addSubview(self.indicator)
    }
    
    func updateConfiguration() {
        self.titleSizes.removeAll()
        self.cellSizes.removeAll()
        self.indicatorRects.removeAll()
        
        for title in self.titles {
            let size = self.gx_textSize(title, font: self.config.titleFont)
            self.titleSizes.append(size)
        }
        
        self.titlesTotalWidth = 0.0
        for titleSize in self.titleSizes {
            self.titlesTotalWidth += titleSize.width
        }
        
    }
    
    func cellSize(cellForAt index: Int) -> CGSize {
        if self.cellSizes[index] != nil {
            return self.cellSizes[index]!
        }
        let height = self.collectionView.frame.height
        var width: CGFloat = 0.0
        var titleMargin: CGFloat = 0.0
        if self.titlesTotalWidth < self.collectionView.frame.width {
            let differenceW = self.collectionView.frame.width - self.titlesTotalWidth
            titleMargin += differenceW / CGFloat(self.titles.count)
        }
        width = self.titleSizes[index].width + titleMargin
        let size = CGSize(width: width, height: height)
        self.cellSizes.updateValue(size, forKey: index)
        return size
    }
    
    func rectIndicator(cell: ZYSegmentTitleCell, index: Int) -> CGRect {
        if self.indicatorRects[index] != nil {
            return self.indicatorRects[index]!
        }
        let titleSize = self.titleSizes[index]
        let width = titleSize.width * 0.6
        let height: CGFloat = 3.0
        let left = cell.frame.origin.x + (cell.frame.width - width) * 0.5
        let top = self.collectionView.frame.height - 3.0
        
        let rect = CGRect(x: left, y: top, width: width, height: height)
        
        self.indicatorRects.updateValue(rect, forKey: index)
        return rect
    }
    
    func setSelectedCell(cell: ZYSegmentTitleCell?, at indexPath: IndexPath, animated: Bool){
        self.selectedIndex = indexPath.item
        let seleIndexPath = IndexPath(item: self.selectedIndex, section:0)
        let seleCell = self.collectionView.cellForItem(at: seleIndexPath) as! ZYSegmentTitleCell
        for subCell in self.collectionView.visibleCells {
            if subCell == cell {
                (subCell as? ZYSegmentTitleCell)?.updateCellTitle(isChecked: true, animated: animated)
            }
            else if subCell == seleCell {
                (subCell as? ZYSegmentTitleCell)?.updateCellTitle(isChecked: false, animated: animated)
            }
            else {
                (subCell as? ZYSegmentTitleCell)?.updateCellTitle(isChecked: false, animated: false)
            }
        }
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        
    }
    
    func setSelectedCell(at index: Int, animated: Bool) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? ZYSegmentTitleCell
        self.setSelectedCell(cell: cell, at: indexPath, animated: animated)
    }
    
    func setSelectedIndicator(cell: ZYSegmentTitleCell, at index: Int, animated: Bool) {
        let indicatorFrame = self.rectIndicator(cell: cell, index: index)
        if animated {
            UIView.animate(withDuration: 0.5){
                self.indicator.frame = indicatorFrame
            }
        } else {
            self.indicator.frame = indicatorFrame
        }
        
    }
    
    func setSelectedIndicator(at index: Int, animated: Bool) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? ZYSegmentTitleCell
        guard cell != nil else { return }
        self.setSelectedIndicator(cell: cell!, at: index, animated: animated)
    }
    
    
    func scrollTo(selectIndex: Int, willSelectIndex: Int, progress: CGFloat){
        let seleIndexPath = IndexPath(item: selectIndex, section: 0)
        let willIndexPath = IndexPath(item: willSelectIndex, section: 0)
        let seleCell = collectionView.cellForItem(at: seleIndexPath) as? ZYSegmentTitleCell
        let willCell = collectionView.cellForItem(at: willIndexPath) as? ZYSegmentTitleCell
        if progress >= 0.9 {
            self.setSelectedCell(cell: willCell, at: willIndexPath, animated: false)
        }
        else if progress <= 0.1 {
            self.setSelectedCell(cell: seleCell, at: seleIndexPath, animated: false)
        }
        
        guard seleCell != nil && willCell != nil else { return }
        
        
        let seleFrame = self.rectIndicator(cell: seleCell!, index: selectedIndex)
        let willFrame = self.rectIndicator(cell: willCell!, index: willSelectIndex)
        
        
        let differenceW = willFrame.width - seleFrame.width
        let differenceX = willFrame.origin.x - seleFrame.origin.x
        let left = seleFrame.origin.x + differenceX * progress
        let width = seleFrame.width + differenceW * progress
        let frame = CGRect(x: left, y: seleFrame.origin.y, width: width, height: seleFrame.height)
        self.indicator.frame = frame
        
    }
    
    func gx_textSize(_ text: String, font: UIFont) -> CGSize {
        let attributes: [NSAttributedString.Key : Any] = [.font: font]
        let attrString = NSAttributedString(string: text, attributes: attributes)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin,.usesFontLeading]
        return attrString.boundingRect(with: .zero, options: options, context: nil).size
    }
}

// MARK: - UICollectionViewDelegate

extension ZYSegementView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ZYSegmentTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: ZYCellID, for: indexPath) as! ZYSegmentTitleCell
        
        let isMaxItem = indexPath.item == (self.titles.count - 1)
        cell.setCell(config:self.config, title: self.titles[indexPath.item], isMaxItem: isMaxItem)
        cell.isChecked = (indexPath.item == self.selectedIndex)
        
        
        return cell
    }
    
    
}

extension ZYSegementView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ZYSegmentTitleCell
        self.setSelectedCell(cell: cell, at: indexPath, animated: false)
        self.setSelectedIndicator(cell: cell, at: indexPath.row, animated: false)
        if delegate?.responds(to: #selector(delegate?.segmentView(_:at:))) ?? false {
            self.delegate?.segmentView?(self, at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return self.cellSize(cellForAt: indexPath.item)
    }
    
}


// MARK: - segmentview配置
class Configuration: NSObject{
    var isShowSeparator: Bool = false
    var separatorColor: UIColor = UIColor(red: 233 / 255.0, green: 233 / 255.0, blue: 233 / 255.0, alpha: 1.0)
    var titleFont: UIFont = .systemFont(ofSize: 15)
    var titleColor: UIColor = .black
    var selectedColor: UIColor = .red
}




