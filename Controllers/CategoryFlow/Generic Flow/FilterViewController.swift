//
//  FilterViewController.swift
//  Clikat
//
//  Created by Night Reaper on 18/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

enum Sort : Int {
    case MinOrderAmount = 0
    case MinDelTime
    case DoesntMatter
    static let allValues : [Sort] = [.MinOrderAmount,.MinDelTime]
    func string() -> String?{
        switch self {
        case .MinOrderAmount :
            return L10n.MinOrderAmount.string
        case .MinDelTime:
            return L10n.MinDeliveryTime.string
        default:
            return nil
        }
    }
}

enum Rating : Int {
    
    case Star1 = 1 , Star2 = 2 , Star3 = 3 , Star4Above = 4 , DoesntMatter
    
    static let allValues = [L10n._1Star.string, L10n._2Star.string,L10n._3Star.string,L10n._4StarAndAbove.string]
    
    func stringRating () -> String{
        switch self {
        case .Star1:
            return L10n._1Star.string
        case .Star2:
            return L10n._2Star.string
        case .Star3:
            return L10n._3Star.string
        case .Star4Above:
            return L10n._4StarAndAbove.string
        
        default : return ""
        }
    }
}


enum Filter : Int {
    
    static let allValues = [L10n.Status.string , L10n.PaymentMethod.string , L10n.LoyaltyPointsType.string , L10n.Rating.string,L10n.Sort.string]
    
    case Discoverability = 0
    case Delivery = 1
    case SupplierType = 2
    case SuppRating = 3
    case Sort = 4
    
}

enum FilterAssocitedValue {
    case Filter([Status] ,[PaymentMethod] ,[CommissionPackage] ,[Rating],Sort)
}

protocol FilterViewControllerDelegate : class {
    func filterApplied (withFilter filter : FilterAssocitedValue)
}

class FilterViewController: BaseViewController {

    weak var delegate : FilterViewControllerDelegate?
    @IBOutlet var tableViewLeft: UITableView!
    @IBOutlet var tableViewRight: UITableView!
    @IBOutlet weak var btnApply : UIButton!
    @IBOutlet weak var btnClear : UIButton!
    
    
    var currentState : Filter = .Discoverability{
        didSet{
            tableViewRight.reloadData()
            tableViewLeft.reloadData()
        }
    }
    
    var filters : FilterAssocitedValue = .Filter([.DoesntMatter],[.DoesntMatter],[.DoesntMatter],[.DoesntMatter],.DoesntMatter)

    var selectedPath = [[Int]](repeating: [], count: Filter.allValues.count) {
        didSet{
            tableViewRight.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnApply.kern(kerningValue: ButtonKernValue)
        btnClear.kern(kerningValue: ButtonKernValue)

        
        if case .Filter(let status , let payment , let commission , let rating,let sortBy) = filters {
            
            if !status.isEmpty{
                selectedPath[0] = status.flatMap{ $0.indexValue() }
            }
            if !payment.isEmpty{
                selectedPath[1] = payment.flatMap{ $0.indexValue() }
            }
            if !commission.isEmpty{
            
                selectedPath[2] = commission.flatMap{ $0.indexValue() }
            }
            if !rating.isEmpty{
                selectedPath[3] = rating.flatMap{ $0.rawValue - 1 }
            }
            
            selectedPath[4] = [sortBy.rawValue]
            tableViewRight.reloadData()
        }
    }
}

extension FilterViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewLeft{
            return Filter.allValues.count
        }
        else{
            if case .Discoverability = currentState {
                return Status.allValues.count
            }
            if case .Delivery = currentState {
                return PaymentMethod.allValues.count
            }
            if case .SupplierType = currentState {
                return CommissionPackage.allValues.count
            }
            if case .SuppRating = currentState{
                return Rating.allValues.count
            }
            if case .Sort = currentState {
                return 2
            }
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableView == tableViewRight ? CellIdentifiers.FilterOptionCell : CellIdentifiers.FilterCell)
        cell?.selectionStyle = .none
        
        if let tempCell = cell as? FilterCell {
            tempCell.textLabel?.text = Filter.allValues[indexPath.row]
            tempCell.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: Size.Medium.rawValue)
            tempCell.textLabel?.adjustsFontSizeToFitWidth = true
            tempCell.isBgSelected =  indexPath.row == currentState.rawValue ?  true : false
        }
        if let tempCell = cell as? FilterOptionCell {
            selectSubTypes(withIndex: currentState.rawValue ,indexPath : indexPath ,cell: tempCell)

            tempCell.textLabel?.font = UIFont(name: Fonts.ProximaNova.Regular , size: Size.Medium.rawValue)
            switch currentState{
            case .Discoverability:
                tempCell.textLabel?.text = Status.allValues[indexPath.row]
            case .Delivery:
                tempCell.textLabel?.text = PaymentMethod.allValues[indexPath.row]
            case .SupplierType:
                tempCell.textLabel?.text = CommissionPackage.allValues[indexPath.row]
            case .SuppRating:
                tempCell.textLabel?.text = Rating.allValues[indexPath.row]
            case .Sort:
                tempCell.textLabel?.text = Sort.allValues[indexPath.row].string()
            }
        }
        if let tempCell = cell as? FilterSliderCell {
            tempCell.currentState = currentState
            tempCell.selectedPath = selectedPath
            
            tempCell.sliderValueChangedBlock = { [weak self] (value,state) in
                switch state{
                case .Sort:
                    self?.selectedPath[4] = [Int(value)]
                default:
                    break
                }
                
            }
        }
        return cell ?? UITableViewCell()
    }

    
    func selectSubTypes(withIndex index : Int , indexPath : IndexPath , cell : FilterOptionCell){
        if currentState == .Sort {
            cell.tintColor = selectedPath[index][0] == indexPath.row ? Colors.MainColor.color() : UIColor.black
            cell.textLabel?.textColor = selectedPath[index][0] == indexPath.row ? Colors.MainColor.color() : UIColor.black
            cell.accessoryType = selectedPath[index][0] == indexPath.row ? .checkmark : .none
            return
        }else if currentState == .SupplierType{
            switch indexPath.row{
            case 0:
                cell.tintColor = selectedPath[currentState.rawValue].contains(2) ? Colors.MainColor.color() : UIColor.black
                cell.textLabel?.textColor = selectedPath[currentState.rawValue].contains(2) ? Colors.MainColor.color() : UIColor.black
                cell.accessoryType = selectedPath[currentState.rawValue].contains(2) ? .checkmark : .none
            case 1:
                cell.tintColor = selectedPath[currentState.rawValue].contains(0) ? Colors.MainColor.color() : UIColor.black
                cell.textLabel?.textColor = selectedPath[currentState.rawValue].contains(0) ? Colors.MainColor.color() : UIColor.black
                cell.accessoryType = selectedPath[currentState.rawValue].contains(0) ? .checkmark : .none
            case 2:
                cell.tintColor = selectedPath[currentState.rawValue].contains(1) ? Colors.MainColor.color() : UIColor.black
                cell.textLabel?.textColor = selectedPath[currentState.rawValue].contains(1) ? Colors.MainColor.color() : UIColor.black
                cell.accessoryType = selectedPath[currentState.rawValue].contains(1) ? .checkmark : .none
            default: break
            }
            
            return
        }else if selectedPath[currentState.rawValue].contains(indexPath.row){
            cell.tintColor = Colors.MainColor.color()
            cell.textLabel?.textColor = Colors.MainColor.color()
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            cell.tintColor = UIColor.black
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableViewLeft{
            currentState = Filter(rawValue: indexPath.row)!
            tableViewRight.reloadData()
        }else if currentState == .Sort {
            selectedPath[currentState.rawValue] = [indexPath.row]
        }else  if currentState == .SupplierType {
            switch indexPath.row {
            case 0:
                if !selectedPath[currentState.rawValue].contains(2){
                selectedPath[currentState.rawValue].append(2)
                }else {
                    selectedPath[currentState.rawValue].remove(at: 2)
                }
            case 1:
                if !selectedPath[currentState.rawValue].contains(0){
                    selectedPath[currentState.rawValue].append(0)
                }else {
                    selectedPath[currentState.rawValue].remove(at: 0)
                }
            case 2:
                if !selectedPath[currentState.rawValue].contains(1){
                    selectedPath[currentState.rawValue].append(1)
                }else {
                    selectedPath[currentState.rawValue].remove(at: 1)
                }
            default:
                 break
            }
        }else{
            
            let cell = tableView.cellForRow(at: indexPath)
            if selectedPath[currentState.rawValue].contains(indexPath.row){
                selectedPath[currentState.rawValue].remove(at: indexPath.row)
                cell?.tintColor = UIColor.black
                cell?.textLabel?.textColor = UIColor.black
                cell?.accessoryType = UITableViewCell.AccessoryType.none
            }
            else{
                selectedPath[currentState.rawValue].append(indexPath.row)
                cell?.tintColor = Colors.MainColor.color()
                cell?.textLabel?.textColor = Colors.MainColor.color()
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - Button Actions
extension FilterViewController {
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    
    @IBAction func actionDone(sender: AnyObject) {
        var (status,delivery,supplierType,rating) = ([Status](),[PaymentMethod](),[CommissionPackage](),[Rating]())
        var sort : Sort = .DoesntMatter
        for (index,path) in selectedPath.enumerated() {
            let filter = Filter(rawValue: index) ?? .Sort
            for value in path {
                switch filter {
                case .Discoverability:
                    status.append(Status(rawValue : value.toString) ?? .DoesntMatter)
                case .Delivery:
                    delivery.append(PaymentMethod(rawValue: value.toString) ?? .DoesntMatter)
                case .SupplierType:
                    switch value {
                    case 2:
                        supplierType.append(.Gold)
                    case 0:
                        supplierType.append(.Silver)
                    case 1:
                        supplierType.append(.Bronze)
                    default: break
                    }
                    
                case .SuppRating:
                    rating.append(Rating(rawValue: value + 1) ?? .DoesntMatter)
                case .Sort:
                    sort = Sort(rawValue: value) ?? .DoesntMatter
                }
            }
        }
        
        delegate?.filterApplied(withFilter : .Filter(status , delivery, supplierType , rating,sort))
        popVC()
        
    }
    
    @IBAction func actionClear(sender: AnyObject) {
        delegate?.filterApplied(withFilter : .Filter([],[],[],[],.DoesntMatter))
        popVC()

    }
    
}
