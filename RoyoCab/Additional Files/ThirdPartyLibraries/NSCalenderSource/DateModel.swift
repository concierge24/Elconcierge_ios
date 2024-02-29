//
//  DateModel.swift
//  SNCalenderView
//
//  Created by OSX on 31/05/18.
//  Copyright © 2018 OSX. All rights reserved.
//

import UIKit

public enum MonthType { case previous, current, next }

final class DateModel: NSObject {
  
  //Type properties
  static var maxCellCount   = 120  //number of dates
  
  //
  //Fileprivate properties
  var currentDates : [Date] = []
  var selectedDates: [Date: Bool] = [:]
  
  fileprivate var highlightedDates: [Date] = []
  fileprivate var currentDate: Date = .init()
  
  
  //MARK: - initialise
  override init() {
    super.init()
    setup()
  }
  
  
  // MARK: - Internal Methods -
  func date(at indexPath: IndexPath) -> Date {
    return currentDates[indexPath.row]
  }
  
  func dayAndDateString(at indexPath: IndexPath , date : Date) -> (String , String) {
    
    let formatter: DateFormatter = .init()
    
    formatter.locale = Locale.init(identifier: "en_US")
    formatter.dateFormat = "EEE"
    
    let dayString = formatter.string(from: date)
    formatter.dateFormat = "dd"
    
    let dateString = formatter.string(from: date)
    
    return (dayString , dateString)
  }
}

// MARK: - Private Methods -

private extension DateModel {
  
  var calendar: Calendar {
    
    var calender1 = Calendar.current
    calender1.locale = Locale.init(identifier: "en_US")
    return calender1 }
  
  func setup() {
    
    selectedDates = [:]
    
    let indexAtBeginning = 3  //indexAtBeginning(in: .current) else { return }
    
    var components: DateComponents = .init()
    currentDates = (0..<DateModel.maxCellCount).flatMap { index in
      
      components.weekday = index - indexAtBeginning
      return calendar.date(byAdding: components, to: Date())
      
    }
  }
}
