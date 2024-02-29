//
//  SJSegmentDataSource.swift
//  Bagant
//
//  Created by MAC_MINI_6 on 10/03/18.
//  Copyright © 2018 OSX. All rights reserved.
//

import UIKit
typealias TabChanged = (_ index : Int) -> ()
typealias Success = () -> ()

class SJSegmentDataSource: SJSegmentedViewControllerDelegate {
  
  var segmentVC: SJSegmentedViewController?
  var selectedSegment: SJSegmentTab?
  var tabChanged: TabChanged?
  var success: Success?
  
  init(segmentVC: SJSegmentedViewController?, containerView: UIView, vc: UIViewController, titles: [String], segmentViewHeight: CGFloat = 48.0, selectedHeight: CGFloat = 1.0, headerHeight: CGFloat = 0.0, scrollingEnabled: Bool? = true, tabChanged: TabChanged? = nil, success: Success? = nil) {
    self.segmentVC = segmentVC
    self.tabChanged = tabChanged
    self.success = success
    segmentVC?.headerViewOffsetHeight = 0
    segmentVC?.isScrollingEnabled = /scrollingEnabled
    segmentVC?.selectedSegmentViewHeight = selectedHeight
//    segmentVC?.segmentTitleFont = R.font.colfaxMedium(size: 14)!
//    segmentVC?.setBackgroundImage("background")
    segmentVC?.selectedSegmentViewColor = UIColor.white
    segmentVC?.headerViewHeight = headerHeight
//    segmentVC?.segmentBackgroundColor = UIColor.clear
    segmentVC?.segmentViewHeight = segmentViewHeight
    segmentVC?.segmentTitleColor = UIColor.white
//    segmentVC?.segmentShadow = SJShadow(offset: CGSize(width: 0, height: 2), color: UIColor.colorDefaultGray(), radius: 2, opacity: 0.3)
    segmentVC?.delegate = self
    segmentVC?.segmentedScrollView.segmentBounces = false
    segmentVC?.segmentedScrollView.alwaysBounceHorizontal = false
    segmentVC?.segmentedScrollView.bounces = false
    segmentVC?.segmentedScrollView.showsVerticalScrollIndicator = false
    for (index, element) in (segmentVC?.segmentControllers ?? []).enumerated() {
      element.title = titles[index]
    }
    vc.addChild(segmentVC!)
    containerView.addSubview((segmentVC?.view)!)
    vc.view.bringSubviewToFront(containerView)
    segmentVC?.view.frame = containerView.bounds
    segmentVC?.didMove(toParent: vc)
    if let block = success {
      block()
    }
  }
  
  func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
    
    if selectedSegment != nil {
      selectedSegment?.titleColor(UIColor.white)
//      selectedSegment?.titleFont(R.font.colfaxRegular(size: 14)!)
    }
    if /segmentVC?.segments.count > 0 {
      selectedSegment = segmentVC?.segments[index]
      selectedSegment?.titleColor(UIColor.white)
//      selectedSegment?.titleFont(R.font.colfaxMedium(size: 14)!)
    }
    if let block = tabChanged {
      block(index)
    }
  }
}
