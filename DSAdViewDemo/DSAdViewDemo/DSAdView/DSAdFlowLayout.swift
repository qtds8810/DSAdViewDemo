//
//  DSAdFlowLayout.swift
//  DSAdViewDemo
//
//  Created by 左得胜 on 2018/8/15.
//  Copyright © 2018年 得胜. All rights reserved.
//

import UIKit
/*
protocol DSAdFlowLayoutDelegate: class {
    func collectioViewScroll(to index: Int) -> Void
}
*/
class DSAdFlowLayout: UICollectionViewFlowLayout {
    // MARK: - Property
    /// 非当前广告的alpha值
    var secondaryItemMinAlpha: CGFloat = 0.4
    /// 3D缩放值，若为0，则为2D广告
    var threeDimensionalScale: CGFloat = 1.0
//    weak var delegate: DSAdFlowLayoutDelegate?
    
    // MARK: - LifeCycle
    
    
    // MARK: - Override Method
    
    
    /**
     返回rect中所有元素的布局属性,返回的是包含UICollectionViewLayoutAttributes的NSArray
     params:
     UICollectionViewAttributes可以是cell，追加视图以及装饰视图的信息，通过以下三个不同的方法可以获取到不同类型的UICollectionViewLayoutAttributes属性
     - layoutAttributesForCellWithIndexPath：  返回对应cell的UICollectionViewAttributes布局属性
     - layoutAtttibutesForSupplementaryViewOfKind：withIndexPath： 返回装饰的布局属性 如果没有追加视图可不重载
     - layoutAttributesForDecorationViewOfKind：withIndexPath： 返回装饰的布局属性  如果没有可以不重载
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return super.layoutAttributesForElements(in: rect) }
        //1. 获取可见区域
        let visibleRect = scrollDirection == .horizontal ? CGRect(origin: CGPoint(x: collectionView.contentOffset.x, y: 0), size: collectionView.bounds.size) : CGRect(origin: CGPoint(x: 0, y: collectionView.contentOffset.y), size: collectionView.bounds.size)
        
        //2. 获得这个区域的item
        guard let originalAttributes = super.layoutAttributesForElements(in: visibleRect) else { return super.layoutAttributesForElements(in: visibleRect) }
        
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        for itemAttributes in originalAttributes {
            if let itemAttributesCopy = itemAttributes.copy() as? UICollectionViewLayoutAttributes {
                attributesCopy.append(itemAttributesCopy)
            }
        }
        
        //3. 遍历，让靠近中心线的item方法，离开的缩小
        var closest_index: Int = 0
        var distanceToCenter: CGFloat = 10000.0
        var z_index: Int = 0
        
        for attributes in attributesCopy {
            var scale: CGFloat = 0
            var absOffset: CGFloat = 0
            if scrollDirection == .horizontal {
                //1. 获取每个item距离可见区域左侧边框的距离 有正负
                let leftMargin: CGFloat = attributes.center.x - collectionView.contentOffset.x
                //2. 获取边框距离屏幕中心的距离（固定的）
                let halfCenterX: CGFloat = collectionView.frame.width * 0.5
                //3. 获取距离中心的的偏移量，需要绝对值
                absOffset = abs(halfCenterX - leftMargin)
                //4. 获取的实际的缩放比例 距离中心越多，这个值就越小，也就是item的scale越小 中心是方法最大的
                scale = 1 - absOffset / halfCenterX
            } else {
                //1. 获取每个item距离可见区域左侧边框的距离 有正负
                let topMargin: CGFloat = attributes.center.y - collectionView.contentOffset.y
                //2. 获取边框距离屏幕中心的距离（固定的）
                let halfCenterY: CGFloat = collectionView.frame.height * 0.5
                //3. 获取距离中心的的偏移量，需要绝对值
                absOffset = abs(halfCenterY - topMargin)
                //4. 获取的实际的缩放比例 距离中心越多，这个值就越小，也就是item的scale越小 中心是方法最大的
                scale = 1 - absOffset / halfCenterY
            }
            
            //5. 缩放
            if threeDimensionalScale > 0 {
                attributes.transform3D = CATransform3DMakeScale(1 + scale * (threeDimensionalScale - 1), 1 + scale * (threeDimensionalScale - 1), 1)
            }
            
            //6. 是否需要透明
            if secondaryItemMinAlpha > 0 || secondaryItemMinAlpha < 1 {
                attributes.alpha = scale < secondaryItemMinAlpha ? secondaryItemMinAlpha : (scale > 0.99 ? 1.0 : scale)
            }
            
            //7.层次 : 比较取得最靠近中间的item,重置z-index
            if absOffset < distanceToCenter {
                attributes.zIndex = z_index
                z_index += 1
                distanceToCenter = absOffset
                closest_index = attributesCopy.index(of: attributes)!
            } else {
                z_index -= 1
                attributes.zIndex = z_index
            }
        }
        
        //设置最近的item的z-index
        if attributesCopy.count > 0 {
            let closest_attribute = attributesCopy[closest_index]
            closest_attribute.zIndex = 1000
        }
        
        return attributesCopy
    }
    
    /**
     滚动的时候会一直调用
     当边界发生变化的时候，是否应该刷新布局。如果YES那么就是边界发生变化的时候，重新计算布局信息  这里的newBounds变化的只有偏移量的变化
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        /*
        guard let collectionView = collectionView, let superView = collectionView.superview else { return true }

        // 把collectionView本身的中心位子（固定的）,转换成collectionView整个内容上的point
        let pInView: CGPoint = superView.convert(collectionView.center, to: collectionView)
        // 通过坐标获取对应的indexpath
        let indexPathNow: IndexPath = collectionView.indexPathForItem(at: pInView) ?? IndexPath(row: 0, section: 0)

        if indexPathNow.row == 0 {
            if scrollDirection == .horizontal {
                if newBounds.origin.x < UIScreen.main.bounds.width * 0.5, cycleIndex != indexPathNow.row {
                    cycleIndex = 0
                    delegate?.collectioViewScroll(to: cycleIndex)
                }
            } else {
                if newBounds.origin.y < UIScreen.main.bounds.height * 0.5, cycleIndex != indexPathNow.row {
                    cycleIndex = 0
                    delegate?.collectioViewScroll(to: cycleIndex)
                }
            }
        } else {
            if cycleIndex != indexPathNow.row {
                cycleIndex = indexPathNow.row
                delegate?.collectioViewScroll(to: cycleIndex)
            }
        }
        */
        super.shouldInvalidateLayout(forBoundsChange: newBounds)
        return true
    }
    
    /// 该方法可写可不写，主要是让滚动的item根据距离中心的值，确定哪个必须展示在中心，不会像普通的那样滚动到哪里就停到哪里
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        // ProposeContentOffset是本来应该停下的位子
        // 1. 先给一个字段存储最小的偏移量 那么默认就是无限大
        var minOffset: CGFloat = CGFloat.greatestFiniteMagnitude
        // 2. 获取到可见区域的centerX 和centerY
        let horizontalCenter: CGFloat = proposedContentOffset.x + collectionView.bounds.width * 0.5
        let verticalCenter: CGFloat = proposedContentOffset.y + collectionView.bounds.height * 0.5
        // 3. 拿到可见区域的rect
        let visibleRect = scrollDirection == .horizontal ? (CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView.bounds.size)) : (CGRect(origin: CGPoint(x: 0, y: proposedContentOffset.y), size: collectionView.bounds.size))
        // 4. 获取到所有可见区域内的item数组
        guard let visibleAttributes = super.layoutAttributesForElements(in: visibleRect) else { return proposedContentOffset }
        // 5. 遍历数组，找到距离中心最近偏移量是多少 可以是垂直偏移量也可以是水平偏移量
        for attribute in visibleAttributes {
            if scrollDirection == .horizontal {
                // 可见区域内每个item对应的中心X坐标
                let itemCenterX = attribute.center.x
                // 比较是否有更小的，有的话赋值给minOffset
                if abs(itemCenterX - horizontalCenter) <= abs(minOffset) {
                    minOffset = itemCenterX - horizontalCenter
                }
            } else {
                // 可见区域内每个item对应的中心X坐标
                let itemCenterY = attribute.center.y;
                // 比较是否有更小的，有的话赋值给minOffset
                if abs(itemCenterY - verticalCenter) <= abs(minOffset) {
                    minOffset = itemCenterY - verticalCenter
                }
            }
        }
        
        // 这里需要注意的是  eg水平方向为例：  上面获取到的minOffset有可能是负数，那么代表左边的item还没到中心，如果确定这种情况下左边的item是距离最近的，那么需要左边的item居中，意思就是collectionView的偏移量需要比原本更小才是，例如原先是1000的偏移，但是需要展示前一个item，所以需要1000减去某个偏移量，因此不需要更改偏移的正负
        
        // eg水平方向为例 ：但是当propose小于0的时候或者大于contentSize（除掉左侧和右侧偏移以及单个cell宽度）  、
        // eg水平方向为例 ： 防止当第一个或者最后一个的时候不会有居中（偏移量超过了本身的宽度），直接卡在推荐的停留位置
        if scrollDirection == .horizontal {
            var centerOffsetX = proposedContentOffset.x + minOffset
            if centerOffsetX < 0 {
                centerOffsetX = 0
            }
            
            if centerOffsetX > collectionView.contentSize.width - (sectionInset.left + sectionInset.right + itemSize.width) {
                centerOffsetX = floor(centerOffsetX)
            }
            return CGPoint(x: centerOffsetX, y: proposedContentOffset.y)
        } else {
            var centerOffsetY = proposedContentOffset.y + minOffset
            if centerOffsetY < 0 {
                centerOffsetY = 0
            }
            
            if centerOffsetY > collectionView.contentSize.height - (sectionInset.top + sectionInset.bottom + itemSize.height) {
                centerOffsetY = floor(centerOffsetY)
            }
            return CGPoint(x: proposedContentOffset.x, y: centerOffsetY)
        }
        
    }
    
    
    
}
