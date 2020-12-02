//
//  ZYPageView.swift
//  ZYSegement
//
//  Created by mac on 2020/9/5.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

import UIKit

@objc protocol ZYPageViewDelegate: NSObjectProtocol{
    @objc optional func pageView(_ pageView: ZYPageView, at index: Int)
}


class ZYPageView: UIView{

    public var delegate: ZYPageViewDelegate!
    
    private lazy var pageViews: UIScrollView = {
        let pageViews = UIScrollView(frame: self.bounds)
        pageViews.isPagingEnabled = true
        pageViews.bounces = false
        pageViews.delegate = self
        return pageViews
    }()
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    convenience init(frame: CGRect, children:[UIView]) {
        self.init(frame:frame)
        self.setupPageView(children: children)
    }
    
    
}

extension ZYPageView{
    
    private func setupPageView(children:[UIView]){
        self.addSubview(self.pageViews)
        self.pageViews.contentSize = CGSize(width: CGFloat(children.count) * self.frame.width, height: self.frame.height)
        for item in children.enumerated() {
            let view = item.element as UIView
            view.frame = CGRect(x: CGFloat(item.offset) * self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
            self.pageViews.addSubview(view)
        }
    }
    
    func setSelectPageIndex(at index: Int, animated:Bool){
        let offset = CGPoint(x: Int(self.frame.width) * index, y: 0)
        
        self.pageViews.setContentOffset(offset, animated: animated)
    }
    
    
    
}


extension ZYPageView: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x, width = scrollView.frame.width
        let selectIndex = Int(offsetX / width)
        if delegate?.responds(to: #selector(delegate?.pageView(_:at:))) ?? false {
            delegate?.pageView?(self, at: selectIndex)
        }
              
    }
    
}
