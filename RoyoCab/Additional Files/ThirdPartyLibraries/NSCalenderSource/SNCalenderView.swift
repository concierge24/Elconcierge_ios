//
//  SNCalenderView.swift
//  SNCalenderView
//
//  Created by OSX on 05/06/18.
//  Copyright © 2018 OSX. All rights reserved.
//

import UIKit

protocol SNCalenderViewDelegate {
  
  func getCurrentDate(date : Any  , view : SNCalenderView,indexPath:IndexPath)
}

class SNCalenderView: UIView {
  
  //MARK: - Property
  var collectionViewCalenderDate : UICollectionView?
  var numberOfDayAfter : Int?
  
  var delegate : SNCalenderViewDelegate?
  var dataSource = [Any]()
  var isStaticArray = false
  var dateTextColor = UIColor.black
  var timeTextColor = UIColor.black
  
  
  //MARK: - LifeCycle Function
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setUp(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    collectionViewCalenderDate?.frame  = bounds
  }
  
  
  //MARK: - Method's
  
  func setUp(coder aDecoder: NSCoder) {
    
    // setUp
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout.init()
    collectionViewFlowLayout.scrollDirection = .horizontal
    collectionViewFlowLayout.minimumLineSpacing = 0.0
    collectionViewFlowLayout.minimumInteritemSpacing = 0.0
    
    let rect = CGRect(x: 0, y: 0, width: bounds.width , height: self.bounds.height)
    
    
    collectionViewCalenderDate = UICollectionView.init(frame: rect , collectionViewLayout: collectionViewFlowLayout)
    
    collectionViewCalenderDate?.showsVerticalScrollIndicator = false
    collectionViewCalenderDate?.showsHorizontalScrollIndicator = false
    collectionViewCalenderDate?.delegate = self
    collectionViewCalenderDate?.dataSource = self
    collectionViewCalenderDate?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    collectionViewCalenderDate?.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    collectionViewCalenderDate?.autoresizesSubviews = true
    
    collectionViewCalenderDate?.register(UINib.init(nibName: "CalenderDateCell", bundle: nil), forCellWithReuseIdentifier: "CalenderDateCell")
    self.addSubview(collectionViewCalenderDate!)
  }
  
  
  func reloadCalender(){
    
    // Setting DataSource
    if !isStaticArray {
      
      collectionViewCalenderDate?.contentInset = .init(top: 0, left: 0 , bottom: 0, right: 0)
      DateModel.maxCellCount = numberOfDayAfter ?? 120
      dataSource = DateModel.init().currentDates
    }
    
    
    collectionViewCalenderDate?.reloadData()
  }
  
  
  //MARK: - Custom
  func getCentralScrollingIndex (scrollView : UIScrollView) {
    
    guard let collectionView = collectionViewCalenderDate else {return}
    
    let centerPoint =  CGPoint(x:collectionView.bounds.width / 2 + collectionView.contentOffset.x, y: collectionView.bounds.height / 2)
    
    guard  let indexPath = collectionViewCalenderDate?.indexPathForItem(at: centerPoint) else {return}
    
    self.collectionViewCalenderDate?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    
    self.delegate?.getCurrentDate(date: dataSource[indexPath.row], view: self, indexPath: indexPath)
  }
  
  // get Date & Day Touple
  func dayAndDateString(date : Date) -> (String , String) {
    
    let formatter: DateFormatter = .init()
    
    formatter.locale = Locale.init(identifier: "en_US")
    formatter.dateFormat = "EEE"
    
    let dayString = formatter.string(from: date)
    formatter.dateFormat = "dd"
    
    let dateString = formatter.string(from: date)
    
    return (dayString , dateString)
  }
  
}

extension SNCalenderView: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderDateCell" , for: indexPath) as? CalenderDateCell else {
      return UICollectionViewCell()
    }
    
    cell.lblDate.textColor = self.dateTextColor
    cell.lblDay.textColor = self.timeTextColor
    
    if !self.isStaticArray {
      
      if indexPath.row == 0 || indexPath.row == 1  || indexPath.row == 2  || indexPath.row == dataSource.count - 1 || indexPath.row == dataSource.count - 2  || indexPath.row == dataSource.count - 3 {
        
        cell.lblDate.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.lblDay.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
      } else {
        
        cell.lblDate.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.lblDay.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      }
      
      let dayDate = self.dayAndDateString(date: (dataSource[indexPath.row] as? Date) ?? Date())
      cell.configureCollectionViewCell(day: dayDate.0, date: dayDate.1)
      
    } else {
      
      cell.lblDay.text = " "
      cell.lblDate.text = dataSource[indexPath.row] as? String
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if indexPath.row > 2{
      self.delegate?.getCurrentDate(date: dataSource[indexPath.row], view: self, indexPath: indexPath)
    }
    self.collectionViewCalenderDate?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if isStaticArray {
      
      return CGSize(width: UIScreen.main.bounds.width / 5  , height: UIScreen.main.bounds.width / 5)
      
      
    } else {
      
      return CGSize(width: UIScreen.main.bounds.width / 7 , height: UIScreen.main.bounds.width / 7)
    }
  }
  
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    if !decelerate {
      self.getCentralScrollingIndex(scrollView : scrollView)
      print("draged")
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.getCentralScrollingIndex(scrollView : scrollView)
  }
}

