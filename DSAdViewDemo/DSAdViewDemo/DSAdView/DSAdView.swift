//
//  DSAdView.swift
//  DSAdViewDemo
//
//  Created by 左得胜 on 2018/8/15.
//  Copyright © 2018年 得胜. All rights reserved.
//

import UIKit

protocol DSAdViewDataSource: class {
    /// 返回显示View的个数
    func numberOfItems(in adView: DSAdView) -> Int
    /// 自行定制cell
    func adView(_ adView: DSAdView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol DSAdViewDelegate: class {
    /// 点击了广告，返回广告信息
    func adView(_ adView: DSAdView, didSelectItemAt index: Int) -> Void
    /// 滑动到的广告的index
    func adView(_ adView: DSAdView, didScrollTo index: Int) -> Void
}

extension DSAdViewDelegate {
    func adView(_ adView: DSAdView, didSelectItemAt index: Int) -> Void {}
    func adView(_ adView: DSAdView, didScrollTo index: Int) -> Void {}
}

class DSAdView: UIView {
    // MARK: - Property
    weak var dataSource: DSAdViewDataSource?
    weak var delegate: DSAdViewDelegate?
    
    /// 分页控制器
    var pageControl: UIPageControl? {
        didSet {
            guard let pageControl = pageControl else { return }
            pageControl.frame = CGRect(x: 0, y: frame.maxY - 20, width: frame.width, height: 10)
            pageControl.hidesForSinglePage = true
            if pageControl.currentPageIndicatorTintColor == nil {
                pageControl.currentPageIndicatorTintColor = UIColor.white
            }
            if pageControl.pageIndicatorTintColor == nil {
                pageControl.pageIndicatorTintColor = UIColor(hexString: "4a4a4a")
            }
            pageControl.isHidden = false
            
            addSubview(pageControl)
        }
    }
    
    class DSAdViewBuilder {
        /// 广告的大小
        var adItemSize: CGSize = CGSize.init(width: UIScreen.main.bounds.width, height: 200)
        /// 最小行间距
        var minimumLineSpacing: CGFloat = 0
        /// 非当前广告的alpha值 如果不需要，填负数
        var secondaryItemMinAlpha: CGFloat = 1
        /// 最小item间距
        var minimumInteritemSpacing: CGFloat = 100000
        /// 3D缩放值，若为0，则为2D广告
        var threeDimensionalScale: CGFloat = 1
        /// 滚动方向 默认为向右
        var scrollDirection: UICollectionView.ScrollDirection = .horizontal
        /// 自动滚动时间间隔
        var autoScrollTimeInterval: TimeInterval = 2
        /// 是否开启无限循环，默认关闭
        var isInfinite: Bool = false
        /// 是否开启自动滚动，默认关闭
        var isAutoPlay: Bool = false
    }
    
    // MARK: Private
    private lazy var builder: DSAdViewBuilder = DSAdViewBuilder.init()
    /// 轮播两侧准备的item倍数
    private let itemTimes: Int = 2
    private lazy var layout: DSAdFlowLayout = {
        let layout = DSAdFlowLayout.init()
        layout.scrollDirection = builder.scrollDirection
        layout.itemSize = builder.adItemSize
        layout.minimumLineSpacing = builder.minimumLineSpacing
        layout.minimumInteritemSpacing = builder.minimumInteritemSpacing
        layout.secondaryItemMinAlpha = builder.secondaryItemMinAlpha
        layout.threeDimensionalScale = builder.threeDimensionalScale
        //        layout.delegate = self
        
        if builder.scrollDirection == .vertical {
            let y_inset = (frame.height - layout.itemSize.height) * 0.5
            layout.sectionInset = UIEdgeInsets(top: y_inset, left: 0, bottom: y_inset, right: 0)
        } else {
            let x_inset = (frame.width - layout.itemSize.width) * 0.5
            layout.sectionInset = UIEdgeInsets(top: 0, left: x_inset, bottom: 0, right: x_inset)
        }
        
        return layout
    }()
    private lazy var myCollectionView: UICollectionView = {
        let myCollectionView = UICollectionView.init(frame: bounds, collectionViewLayout: layout)
        myCollectionView.showsVerticalScrollIndicator = false
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0)
        myCollectionView.isScrollEnabled = true
        myCollectionView.backgroundColor = UIColor.clear
        
        return myCollectionView
    }()
    /// 定时器
    private var myTimer: Timer?
    private var rowCount: Int = 0
    
    //MARK: - LifeCycle
    deinit {
        endTimer()
    }
    
    convenience init(frame: CGRect, builder builderClosure: ((_ builder: DSAdViewBuilder) -> Void)) {
        self.init(frame: frame)
        
        builderClosure(builder)
        
        addSubview(myCollectionView)
    }
    
    // MARK: - Public Method
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        myCollectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        myCollectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return myCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func reloadData() {
        getRowCount()
        
        if builder.isInfinite && rowCount > 3 {
            if layout.scrollDirection == .vertical {
                myCollectionView.contentOffset.y = frame.height - (layout.itemSize.height + layout.sectionInset.top) * 0.5
            } else {
                myCollectionView.contentOffset.x = layout.itemSize.width + layout.minimumLineSpacing
            }
        }
        if builder.isAutoPlay && rowCount > 3 {
            startTimer()
        }
        
        if let pageControl = pageControl, !pageControl.isHidden {
            pageControl.numberOfPages = (builder.isInfinite && rowCount > 3) ? (rowCount - 2) : rowCount
        }
        
        myCollectionView.reloadData()
    }
    
    /// 新需求，只有一张油卡，变大
    func updateLayoutItermSize() {
        if rowCount == 1 {
            layout.itemSize = CGSize(width: builder.adItemSize.width * builder.threeDimensionalScale, height: builder.adItemSize.height * builder.threeDimensionalScale)
        } else {
            layout.itemSize = CGSize(width: builder.adItemSize.width, height: builder.adItemSize.height)
        }
    }
    
    /// 返回指定索引的 cell
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return myCollectionView.cellForItem(at: indexPath)
    }
    
    /// 手动将指定索引的 cell 滚动到屏幕中央
    func scrollToItem(at indexPath: IndexPath) {
        guard indexPath.row >= 0 || indexPath.row <= rowCount else { return }
        
        let direction: UICollectionView.ScrollPosition = builder.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        if builder.isInfinite && rowCount > 3 {
            myCollectionView.scrollToItem(at: indexPath, at: direction, animated: true)
        } else {
            if indexPath.row == rowCount {
                myCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: direction, animated: true)
                return
            }
            myCollectionView.scrollToItem(at: indexPath, at: direction, animated: true)
        }
    }
    
    // MARK: - Action
    /// 计时器执行方法,增加偏移量
    @objc private func timerAction() {
        guard rowCount > 0, let currentIndexP = getCenterIndexPath() else { return }
        
        if builder.isInfinite && rowCount > 3 && (currentIndexP.row >= rowCount - 2) {
            pageControl?.currentPage = 0
            if builder.scrollDirection == .horizontal {// 水平滚动
                myCollectionView.contentOffset.x = 0
                myCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
            } else {// 垂直滚动
                myCollectionView.contentOffset.y = 0
                myCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredVertically, animated: true)
            }
        } else {
            scrollToItem(at: IndexPath(item: currentIndexP.row + 1, section: 0))
            updatePageControl(currentPage: currentIndexP.row + 1)
        }
        
    }
    
}

// MARK: - Private Method
private extension DSAdView {
    private func updatePageControl(currentPage: Int) {
        guard let pageControl = pageControl else { return }
        if builder.isInfinite {
            switch currentPage {
            case 0:
                pageControl.currentPage = rowCount - 1
            case rowCount - 1:
                pageControl.currentPage = 0
            default:
                pageControl.currentPage = currentPage - 1
            }
        } else {
            pageControl.currentPage = currentPage
        }
        //        pageControl.updateCurrentPageDisplay()
    }
    
    /// 秘密更新偏移量，无动画
    private func secretChangeOffset(_ indexPath: IndexPath) {
        if builder.isInfinite && rowCount > 3 {
            if builder.scrollDirection == .horizontal {// 水平滚动
                let w: CGFloat = (layout.itemSize.width + layout.minimumLineSpacing)
                if indexPath.row >= rowCount - 1 {
                    myCollectionView.contentOffset.x = w
                } else if indexPath.row == 0 {
                    myCollectionView.contentOffset.x = w * CGFloat(rowCount - 2)
                }
                
            } else {// 纵向滚动
                let h: CGFloat = frame.height - (layout.itemSize.height + layout.sectionInset.top) * 0.5
                if indexPath.row >= rowCount - 1 {
                    myCollectionView.contentOffset.y = h
                } else if indexPath.row == 0 {
                    myCollectionView.contentOffset.y = h * CGFloat(rowCount - 2)
                }
            }
        }
    }
    
    /// 获取当前 cell 的数量
    func getRowCount() {
        var numbers = 0
        if let dataSource = dataSource {
            numbers = dataSource.numberOfItems(in: self)
        }
        if builder.isInfinite && numbers > 1 {
            numbers += 2
        }
        rowCount = numbers
    }
    
    /// 获取当前在屏幕中间的索引
    func getCenterIndexPath() -> IndexPath? {
        let centerPoint = convert(myCollectionView.center, to: myCollectionView)
        return myCollectionView.indexPathForItem(at: centerPoint)
    }
    
    func endTimer() {
        if myTimer != nil {
            myTimer?.invalidate()
            myTimer = nil
        }
    }
    
    func startTimer() {
        endTimer()
        
        if rowCount > 0, builder.isAutoPlay, myTimer == nil {
            myTimer = Timer(timeInterval: builder.autoScrollTimeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(myTimer!, forMode: .common)
        }
    }
}

//// MARK: - DSAdFlowLayoutDelegate
//extension DSAdView: DSAdFlowLayoutDelegate {
//    func collectioViewScroll(to index: Int) {
//
//    }
//}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DSAdView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var realIndex = indexPath.row
        if builder.isInfinite && rowCount > 3 {
            if indexPath.row == 0 {
                realIndex = rowCount - 3
            } else if indexPath.row == rowCount - 1 {
                realIndex = 0
            } else {
                realIndex = indexPath.row - 1
            }
        } else {
            realIndex = indexPath.row
        }
        
        return dataSource?.adView(self, cellForItemAt: IndexPath(item: realIndex, section: 0)) ?? DSAdViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let indexpathNew = getCenterIndexPath() else { return }
        
        if indexPath.row == indexpathNew.row {//点击了中间的广告
            if let delegate = delegate {
                let index: Int = (builder.isInfinite && rowCount > 3) ? (indexPath.row - 1) : (indexPath.row)
                delegate.adView(self, didSelectItemAt: index)
            }
        } else {//点击了背后的广告，将会被移动上来
            scrollToItem(at: indexPath)
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if builder.isAutoPlay && rowCount > 3 {
            endTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if builder.isAutoPlay && rowCount > 3 {
            startTimer()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollDidEnd(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDidEnd(scrollView)
    }
    
    private func scrollDidEnd(_ scrollView: UIScrollView) {
        guard let indexPath = getCenterIndexPath() else { return }
        if let delegate = delegate {
            delegate.adView(self, didScrollTo: indexPath.row)
        }
        
        updatePageControl(currentPage: indexPath.row)
        secretChangeOffset(indexPath)
    }
}
