//  ButtonBarView.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2016 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public enum PagerScroll {
    case No
    case Yes
    case ScrollOnlyIfOutOfScreen
}

public enum SelectedBarAlignment {
    case Left
    case Center
    case Right
    case Progressive
}
public enum ButtonBarItemSpec<CellType: UICollectionViewCell> {
    
    case NibFile(nibName: String, bundle: Bundle?, width:((IndicatorInfo)-> CGFloat))
    case CellClass(width:((IndicatorInfo)-> CGFloat))
    
    public var weight: ((IndicatorInfo) -> CGFloat) {
        switch self {
        case .CellClass(let widthCallback):
            return widthCallback
        case .NibFile(_, _, let widthCallback):
            return widthCallback
        }
    }
}

public class ButtonBarView: UICollectionView {
    
    public lazy var selectedBar: UIView = { [unowned self] in
        let bar  = UIView(frame: CGRect(x: 0, y: self.frame.size.height - CGFloat(self.selectedBarHeight), width: 0, height: CGFloat(self.selectedBarHeight)))
        bar.layer.zPosition = 9999
        return bar
    }()
    
    internal var selectedBarHeight: CGFloat = 4 {
        didSet {
            self.updateSlectedBarYPosition()
        }
    }
    var selectedBarAlignment: SelectedBarAlignment = .Center
    var selectedIndex = 0
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(selectedBar)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addSubview(selectedBar)
    }
    
    public func moveToIndex(toIndex: Int, animated: Bool, swipeDirection: SwipeDirection, pagerScroll: PagerScroll) {
        selectedIndex = toIndex
        updateSelectedBarPosition(animated: animated, swipeDirection: swipeDirection, pagerScroll: pagerScroll)
    }
    
    public func moveFromIndex(fromIndex: Int, toIndex: Int, progressPercentage: CGFloat,pagerScroll: PagerScroll) {
        selectedIndex = progressPercentage > 0.5 ? toIndex : fromIndex
        
        let fromFrame = layoutAttributesForItem(at: IndexPath(item: fromIndex, section: 0))!.frame
        let numberOfItems = dataSource!.collectionView(self, numberOfItemsInSection: 0)
        
        var toFrame: CGRect
        
        if toIndex < 0 || toIndex > numberOfItems - 1 {
            if toIndex < 0 {
                let cellAtts = layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
                toFrame = cellAtts!.frame.offsetBy(dx: -cellAtts!.frame.size.width, dy: 0)
            }
            else {
                let cellAtts = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: 0))
                toFrame = cellAtts!.frame.offsetBy(dx: cellAtts!.frame.size.width, dy: 0)
            }
        }
        else {
            toFrame = layoutAttributesForItem(at: IndexPath(item: toIndex, section: 0))!.frame
        }
        
        var targetFrame = fromFrame
        targetFrame.size.height = selectedBar.frame.size.height
        targetFrame.size.width += (toFrame.size.width - fromFrame.size.width) * progressPercentage
        targetFrame.origin.x += (toFrame.origin.x - fromFrame.origin.x) * progressPercentage
        
        selectedBar.frame = CGRect(x: targetFrame.origin.x, y: selectedBar.frame.origin.y, width: targetFrame.size.width, height: selectedBar.frame.size.height)
        
        var targetContentOffset: CGFloat = 0.0
        if contentSize.width > frame.size.width {
            let toContentOffset = contentOffsetForCell(withFrame: toFrame, andIndex: toIndex)
            let fromContentOffset = contentOffsetForCell(withFrame: fromFrame, andIndex: fromIndex)
            
            targetContentOffset = fromContentOffset + ((toContentOffset - fromContentOffset) * progressPercentage)
        }
        
        let animated = abs(contentOffset.x - targetContentOffset) > 30 || (fromIndex == toIndex)
        setContentOffset(CGPoint(x: targetContentOffset, y: 0), animated: animated)
    }
    
    public func updateSelectedBarPosition(animated: Bool, swipeDirection: SwipeDirection, pagerScroll: PagerScroll) -> Void {
        
     
        var selectedBarFrame = selectedBar.frame
        
        let selectedCellIndexPath = IndexPath(item: selectedIndex, section: 0)
        guard let attributes = layoutAttributesForItem(at: selectedCellIndexPath) else { return }
        let selectedCellFrame = attributes.frame
        
        updateContentOffset(animated: animated, pagerScroll: pagerScroll, toFrame: selectedCellFrame, toIndex: selectedCellIndexPath.row)
        
        selectedBarFrame.size.width = selectedCellFrame.size.width
        selectedBarFrame.origin.x = selectedCellFrame.origin.x
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.selectedBar.frame = selectedBarFrame
            })
        }
        else {
            selectedBar.frame = selectedBarFrame
        }
    }
    
    // MARK: - Helpers
    
    private func updateContentOffset(animated: Bool, pagerScroll: PagerScroll, toFrame: CGRect, toIndex: Int) -> Void {
        guard pagerScroll != .No || (pagerScroll != .ScrollOnlyIfOutOfScreen && (toFrame.origin.x < contentOffset.x || toFrame.origin.x >= (contentOffset.x + frame.size.width - contentInset.left))) else { return }
        let targetContentOffset = contentSize.width > frame.size.width ? contentOffsetForCell(withFrame: toFrame, andIndex: toIndex) : 0
        setContentOffset(CGPoint(x: targetContentOffset, y: 0), animated: animated)
    }
    
    private func contentOffsetForCell(withFrame cellFrame: CGRect, andIndex index: Int) -> CGFloat {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        var alignmentOffset: CGFloat = 0.0
        
        switch selectedBarAlignment {
        case .Left:
            alignmentOffset = sectionInset.left
        case .Right:
            alignmentOffset = frame.size.width - sectionInset.right - cellFrame.size.width
        case .Center:
            alignmentOffset = (frame.size.width - cellFrame.size.width) * 0.5
        case .Progressive:
            let cellHalfWidth = cellFrame.size.width * 0.5
            let leftAlignmentOffset = sectionInset.left + cellHalfWidth
            let rightAlignmentOffset = frame.size.width - sectionInset.right - cellHalfWidth
            let numberOfItems = dataSource!.collectionView(self, numberOfItemsInSection: 0)
            let progress = index / (numberOfItems - 1)
            alignmentOffset = leftAlignmentOffset + (rightAlignmentOffset - leftAlignmentOffset) * CGFloat(progress) - cellHalfWidth
        }
        
        var contentOffset = cellFrame.origin.x - alignmentOffset
        contentOffset = max(0, contentOffset)
        contentOffset = min(contentSize.width - frame.size.width, contentOffset)
        return contentOffset
    }
    
    private func updateSlectedBarYPosition() {
        
        var selectedBarFrame = selectedBar.frame
        selectedBarFrame.origin.y = frame.size.height - selectedBarHeight
        selectedBarFrame.size.height = selectedBarHeight
        selectedBar.frame = selectedBarFrame
        
    }
}