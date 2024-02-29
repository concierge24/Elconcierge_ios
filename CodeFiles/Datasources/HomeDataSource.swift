//
//  HomeDataSource.swift
//  Clikat
//
//  Created by Night Reaper on 19/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

enum HomeScreenSection : Int {
    
    case Banners = 0
    case listCategories
    case listCategories1st2
    case listCategoriesFrom3rd
    case Recommended
    case Offers1st3
    case Offers2nd3
    case Offers
    case OffersH
    case Brands
    case None
    case Search
    case Menu
    case ProductList
    case PopularProducts
    
    static var allValues:[HomeScreenSection] { //Nitin
        if (SKAppType.type.isJNJ /*(|| SKAppType.type == .party)*/ || SKAppType.type == .home /*|| SKAppType.type == .gym*/) {
            return [
                HomeScreenSection.Banners,
                .listCategories1st2,
                .OffersH,
                .Brands,
                
                   // .PopularProducts
                
                //.listCategoriesFrom3rd
            ]
            
        } else if SKAppType.type == .food {
            if DeliveryType.shared == .pickup {
                return [
                    HomeScreenSection.Banners,
                    //Nitin
//                    .Search,
                    .Offers1st3,
                    .Offers2nd3,
                    .Offers
                ]
            }
            
            if AppSettings.shared.isSingleVendor{
               return totalSection
            }
            return [
                HomeScreenSection.Banners,
                .listCategories,
                //.Search,
                .Offers1st3,
                .Brands,
//                .Recommended,
                .Offers2nd3,
                .OffersH,
                .Offers
            ]
        }
        else if SKAppType.type == .eCom {
            if AppSettings.shared.isSingleVendor{
                return [
                               HomeScreenSection.Banners,
                               .OffersH,
                               .Brands,
                               .PopularProducts
                           ]
            }
            else {
                return [
                               HomeScreenSection.Banners,
                               .OffersH,
                               .Brands,
                               .Recommended,
                               .PopularProducts
                           ]
            }
           
        }
        return [
            HomeScreenSection.Banners,
            //.listCategories,
            .Menu,
//            .Search,
            .Offers1st3,
            .Brands,
            .Offers2nd3,
            .Recommended,
            .Offers
        ]
    }
    
    static let registerCells = [
        HomeBrandsCollectionTableCell.identifier,
        HomeMenuCollectionTableCell.identifier,
        ProductListingCell.identifier,
        LoadMorePTableCell.identifier,
        HomeServiceCategoriesTableCell.identifier,
        HomeOffersHListTableCell.identifier,
        HomeSearchCell.identifier,
        HomeFoodRestaurantTableCell.identifier,
        FlickeringHomeTableViewCell.identifier,
        HomeSkeletonCell.identifier,
        ProductListCell.identifier,
        HomeSupplierTableCell.identifier
    ]

    static var totalSection : [HomeScreenSection] {
        
        if let data = GDataSingleton.sharedInstance.homeData {
            var tempArray = [HomeScreenSection]()
            tempArray.append(.Banners)
            if (data.arrayOffersEN?.count ?? 0) > 0 {
                tempArray.append(.OffersH)
            }
            let count = GDataSingleton.sharedInstance.homeProductList?.count ?? 0
            if count > 0 {
                for _ in 0...count-1 {
                    tempArray.append(.ProductList)
                }
            }
            return tempArray
        }
        return [.Banners,.OffersH]
    }
    
    
    func title(witHome home : Home?,section:Int?) -> String? {
        switch self {
        case .Recommended:
            guard let count = home?.arrayRecommendedEN?.count, count > 0 else{return nil}
            if SKAppType.type.isFood {
                return L11n.recommended.string//SKAppType.type.strRecommendedRestaurants
            }
            else {
                return TerminologyKeys.suppliers.localizedValue(prefix: "Popular") as? String
            }
            
        case .Offers1st3:
            let array: [Any]? = SKAppType.type == .food ? home?.arrayAllRecommended : home?.arrayOffersEN
            guard let count = array?.count, count > 0 else{return nil}

            if SKAppType.type == .food {
                let key = count == 1 ? TerminologyKeys.supplier : TerminologyKeys.suppliers
                if let term = key.localizedValue() as? String{
                    let str = "\(count) \(term)"
                    return str
                }
            }
            
            return L11n.discountItems.string
            
        case .Brands:
            if SKAppType.type == .food || SKAppType.type == .home {
                guard let count = home?.arrayRecommendedEN?.count, count > 0 else { return nil }
                if APIConstants.defaultAgentCode == "yummy_0122"{
                    return TerminologyKeys.popularRestaurantes.localizedValue() as? String
                }else{
                    let key = count == 1 ? TerminologyKeys.supplier : TerminologyKeys.suppliers
                    return key.localizedValue(prefix: "Popular") as? String
                }
                // return L11n.popularRestaurants.string
            }
            else if SKAppType.type == .eCom {
                guard let count = home?.arrayBrands?.count, count > 0 else { return nil }
                return TerminologyKeys.brands.localizedValue(prefix: "Popular") as? String
                //return L11n.brands.string//.SpecialOffers.string
            }
            
            guard let count = home?.arrayRecommendedEN?.count, count > 0 else { return nil }
            return L11n.brands.string
            
        case .OffersH:
            //Nitin
            if SKAppType.type == .food {
                guard let count = home?.arrayOffersEN?.count, count > 0 else { return nil }
            } else {
                guard let count = home?.arrayOffersEN?.count, count > 0 else { return nil }
            }
//            guard let count = home?.arrayOffersEN?.count, count > 0 else { return nil }
            if SKAppType.type == .food || SKAppType.type.isJNJ {
                return L11n.specialOffers.string
            }
//            else if SKAppType.type.isJNJ {
//                return L11n.discountItems.string
//            }
            return L11n.specialOffers.string
            
        case .PopularProducts:
            return TerminologyKeys.products.localizedValue(prefix: "Popular") as? String

        case .listCategories1st2:
            guard let count = home?.arrayServiceTypesEN?.count, count > 0 else { return nil }
            return TerminologyKeys.categories.localizedValue() as? String

            //        case .ServiceTypes:
        //            return L11n.categories.string
        
        case .ProductList : //Nitin Check
            if AppSettings.shared.isSingleVendor {
                let offset = HomeScreenSection.allValues.firstIndex(of: .ProductList)
                let products = GDataSingleton.sharedInstance.homeProductList
                 guard let count = products?.count,count > 0 else {return nil}
                 if let itemValue = products,itemValue.count>0 {
                     if /section < /offset {
                         return ""
                     } else {
                        return itemValue[/section - /offset].catName
                     }
                 }
            }
            return TerminologyKeys.products.localizedValue() as? String
        default : return nil
        }
    }
    
    func subTitle(witHome home : Home?) -> String? {
        switch self {
        
        case .listCategories1st2:
            return L11n.categoriesHomeSubTitle.string
            
        case .OffersH:
            return SKAppType.type == .food || SKAppType.type.isJNJ ? nil : L11n.specialOffersHomeSubTitle.string
        
        default: return nil
        }
    }
    
    func identifier(isLast: Bool) -> String {
        switch self {
        case .Banners :
            return CellIdentifiers.BannerParentCell
        case .listCategories :
            return CellIdentifiers.ServiceTypeParentCell
        case .Search:
            return CellIdentifiers.HomeSearchCell
        case .Offers1st3, .Offers2nd3, .Offers:
            return isLast ? LoadMorePTableCell.identifier : (SKAppType.type == .food ? HomeFoodRestaurantTableCell.identifier : ProductListingCell.identifier)
        case .Brands:
            if SKAppType.type == .home {
                return HomeSupplierTableCell.identifier
            }
            return HomeBrandsCollectionTableCell.identifier
        case .Menu:
            return HomeMenuCollectionTableCell.identifier
            
        case .listCategories1st2,
            .listCategoriesFrom3rd:
            return HomeServiceCategoriesTableCell.identifier
        
        case .OffersH:
            return HomeOffersHListTableCell.identifier
        
        case .ProductList:
            return ProductListCell.identifier
            
        case .PopularProducts:
            return HomeOffersHListTableCell.identifier

        default:
            return CellIdentifiers.HomeProductParentCell
        }
    }
    
    func titleOffer(witHome title : String?) -> String? {
        
        let titleString = title == L10n.Offers.string ? L10n.Offers.string : L10n.SpecialOffers.string
        return titleString
    }
    
    func rowHeight(witHome home : Home?) -> CGFloat {

        switch self {
            
        case .Recommended:
            
            let width = 152.0//((ScreenSize.SCREEN_WIDTH-16-32)/2)
            let height = 48+8+8+(width*3/4)+16
            return CGFloat(height)//(rows*height)+((rows-1)*16)+6+6//265.0
            
        //Nitin
        case .listCategories1st2:

            var width = (UIScreen.main.bounds.width-32.0-60.0)/4.0
            guard let count = home?.arrayServiceTypesEN?.count else {return 0.0}
            width = count/4 == 1 ? width : CGFloat((count.quotientAndRemainder(dividingBy: 4).quotient)+1) * width
            return width + 30
        default:
            return UITableView.automaticDimension
        }
    }
    
    func numberOfRowsInSection(witHome home : Home?,section :Int?) -> Int {
        switch self {
        case HomeScreenSection.OffersH :
            //Nitin
            if SKAppType.type == .food {
                 guard let count = home?.arrayOffersEN?.count, count > 0 else{ return 0 }
            } else {
                guard let count = home?.arrayOffersEN?.count, count > 0 else{ return 0 }
            }
            return 1
            
        case HomeScreenSection.PopularProducts :
            //Nitin
            guard let count = home?.arrPopularProducts?.count, count > 0 else{ return 0 }
            return 1

        case HomeScreenSection.Offers1st3 :

            let array: [Any]? = SKAppType.type == .food ? home?.arrayAllRecommended : home?.arrayOffersEN
            guard let count = array?.count, count > 0 else{return 0}
            if count <= 3 {
                return count
            }
            return 3
            
        case HomeScreenSection.Offers2nd3 :

            let array: [Any]? = SKAppType.type == .food ? home?.arrayAllRecommended : home?.arrayOffersEN
            guard let count = array?.count, count > 3 else{return 0}
            let count2nd = count-3
            if count2nd <= 3 {
                return count2nd
            }
            return 3
            
        case HomeScreenSection.Offers :
            let array: [Any]? = SKAppType.type == .food ? home?.arrayAllRecommended : home?.arrayOffersEN
            guard let count = array?.count, count > 6 else{return 0}
            let count3nd = count-6
//            if count3nd <= 3 {
//                return count3nd+1
//            }
            return count3nd
            
        case HomeScreenSection.Recommended:
            guard let count = home?.arrayRecommendedEN?.count, count > 0 else{return 0}
            return 1
            
        case HomeScreenSection.listCategories :
            guard let count = home?.arrayServiceTypesEN?.count, count > 0 else{ return 0 }
            return 1
            
        case HomeScreenSection.listCategories1st2:
            guard let count = home?.arrayServiceTypesEN?.count, count > 0 else{ return 0 }
            //Nitin
            return 1
            
        case HomeScreenSection.listCategoriesFrom3rd:
            if SKAppType.type.isJNJ {
                guard let count = home?.arrayServiceTypesEN?.count, count > 4 else{ return 0 }
                return 1
            }
            guard let count = home?.arrayServiceTypesEN?.count, count > 0 else{ return 0 }
            return 1
        
        case HomeScreenSection.Banners:
            guard let count = home?.arrayBanners?.count, count > 0 else{ return 0 }
            return 1
        case HomeScreenSection.Menu:
            return 1
        
//        case .Search:
//            return GDataSingleton.sharedInstance.app_type == 1 ? 0 : 0
 
        case HomeScreenSection.Brands:
            if SKAppType.type == .home {
                guard let count = home?.arrayRecommendedEN?.count, count > 0 else{ return 0 }
                return count
            }
            if SKAppType.type == .eCom {
                guard let count = home?.arrayBrands?.count, count > 0 else{return 0}
                return 1
            }
            if SKAppType.type == .food{
                guard let count = home?.arrayRecommendedEN?.count, count > 0 else{return 0}
                return 1
            }
//            guard let count = home?.arrayBrands?.count, count > 0 else{ return 0 }
//            return 1
                guard let count = home?.arrayRecommendedEN?.count, count > 0 else{ return 0 }
                return 1
        case .Search:
            return 1
            
        case .ProductList:
            if AppSettings.shared.isSingleVendor {
                let offset = HomeScreenSection.allValues.firstIndex(of: .ProductList)
                if let itemValue = GDataSingleton.sharedInstance.homeProductList, itemValue.count>0 {
                    if /section < /offset {
                        return 1
                    } else {
                        return itemValue[/section - /offset].productValue?.count ?? 0
                    }
                }
            }
            return 1

        default :
            return 0
        }
        
    }
}

class HomeDataSource: NSObject {
    
    typealias  HomeListCellConfigureBlock = (_ indexPath : IndexPath ,_ cell : Any , _ item : Any , _ type : HomeScreenSection) -> ()
    typealias  HomeDidSelectedRow = (_ indexPath : IndexPath ,_ type : HomeScreenSection) -> ()
    var home : Home?
    var tableView  : UITableView?
    var configureCellBlock : HomeListCellConfigureBlock?
    var aRowSelectedListener : HomeDidSelectedRow?
    
//    var sectionHeader : HomeSectionHeader?
    
    init (home : Home? , tableView : UITableView? , configureCellBlock : @escaping HomeListCellConfigureBlock , aRowSelectedListener : @escaping HomeDidSelectedRow) {
        
        tableView?.registerCells(nibNames: HomeScreenSection.registerCells)
        
        self.tableView = tableView
        self.home = home
        self.configureCellBlock = configureCellBlock
        self.aRowSelectedListener = aRowSelectedListener
    }
    
    override init(){
        super.init()
    }
}

extension HomeDataSource : UITableViewDelegate , SkeletonTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeScreenSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= HomeScreenSection.allValues.count {return 0}
        let sectionCase = HomeScreenSection.allValues[section]
        return sectionCase.numberOfRowsInSection(witHome : home, section: section)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section >= HomeScreenSection.allValues.count {return 0}
        let sectionCase = HomeScreenSection.allValues[indexPath.section]
        let height = sectionCase.rowHeight(witHome : home)
        return (HomeScreenSection.allValues.count ==  0) ? 0: height
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return FlickeringHomeTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section >= HomeScreenSection.allValues.count {return UITableViewCell()}
        let sectionCase = HomeScreenSection.allValues[indexPath.section]
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: sectionCase.identifier(isLast: false), for: indexPath as IndexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if (sectionCase == .Offers1st3 || sectionCase == .Offers2nd3 || sectionCase == .Offers), let item: AnyObject = home {
            
            let products: [Any]? = SKAppType.type == .food ? (item as? Home)?.arrayAllRecommended : (item as? Home)?.arrayOffersEN
//            let products = Localize.currentLanguage() == Languages.Arabic ? (item as? Home)?.arrayOffersAR : (item as? Home)?.arrayOffersEN
            if sectionCase == .Offers1st3 {
                cell = tableView.dequeueReusableCell( withIdentifier: sectionCase.identifier(isLast: indexPath.row == /products?.count), for: indexPath as IndexPath) as UITableViewCell
                if (/products?.count) <= 3 {
                    if indexPath.row != /products?.count, let block = configureCellBlock , let item = products?[indexPath.row] {
                        block(indexPath,cell, item, sectionCase)
                    }
                } else {
                    if let block = configureCellBlock , let item = products?[indexPath.row] {
                        block(indexPath,cell, item, sectionCase)
                    }
                }
            } else if sectionCase == .Offers2nd3 {
                let count2nd = (/products?.count)-3
                let count2ndIndex = indexPath.row+3
                cell = tableView.dequeueReusableCell( withIdentifier: sectionCase.identifier(isLast: count2ndIndex == /products?.count), for: indexPath as IndexPath) as UITableViewCell

                if count2nd <= 3 {
                    if count2ndIndex >= products?.count ?? 0 {return UITableViewCell()}
                    if count2ndIndex != /products?.count, let block = configureCellBlock , let item = products?[count2ndIndex] {
                        block(indexPath,cell, item, sectionCase)
                    }
                } else {
                    if let block = configureCellBlock , let item = products?[count2ndIndex] {
                        block(indexPath,cell, item, sectionCase)
                    }
                }
            } else if sectionCase == .Offers {
                let count2nd = (/products?.count)-6
                let count2ndIndex = indexPath.row+6
                cell = tableView.dequeueReusableCell( withIdentifier: sectionCase.identifier(isLast: count2ndIndex == /products?.count), for: indexPath as IndexPath) as UITableViewCell

                if count2nd <= 3 {
                    if count2ndIndex >= products?.count ?? 0 {return UITableViewCell()}
                    if count2ndIndex != /products?.count, let block = configureCellBlock , let item = products?[count2ndIndex] {
                        block(indexPath,cell, item, sectionCase)
                    }
                } else {
                    if let block = configureCellBlock , let item = products?[count2ndIndex] {
                        block(indexPath,cell, item, sectionCase)
                    }
                }
            }

        } else {
            if let block = configureCellBlock , let item: AnyObject = home {
                block(indexPath,cell, item, sectionCase)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = aRowSelectedListener {
            let sectionCase = HomeScreenSection.allValues[indexPath.section]
            block(indexPath, sectionCase)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionCase = HomeScreenSection.allValues[section]
        guard let _ = sectionCase.title(witHome : home,section: section) else { return 0.01 }
        return SKAppType.type == .home ? 56 : 48
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (HomeScreenSection.allValues.count == 0) || (section >= HomeScreenSection.allValues.count) {return UIView()}
        let sectionCase = HomeScreenSection.allValues[section]

        if SKAppType.type.isJNJ && sectionCase == .listCategories1st2 {
            var header: JNJHomeHeaderTableCell! = tableView.dequeueReusableCell(withIdentifier: JNJHomeHeaderTableCell.identifier) as? JNJHomeHeaderTableCell
            if header == nil {
                tableView.registerCells(nibNames: [JNJHomeHeaderTableCell.identifier])
                header = tableView.dequeueReusableCell(withIdentifier: JNJHomeHeaderTableCell.identifier) as? JNJHomeHeaderTableCell
            }
            return header
        }
        
        guard let title = sectionCase.title(witHome : home, section: section) else { return UIView(frame: CGRect.zero) }
        
        let subTitle = /sectionCase.subTitle(witHome : home)
        
        let sectionHeader = HomeSectionHeader(frame: CGRect(x: 0, y: 0, w: ScreenSize.SCREEN_WIDTH, h: 48))
//SKAppType.type != .food
        var isOffer = (!SKAppType.type.isJNJ && sectionCase == .OffersH)
        if SKAppType.type == .eCom && sectionCase == .PopularProducts {
            isOffer = false
        }
        
        //sectionHeader.lblLine.isHidden = ((SKAppType.type == .home /*|| SKAppType.type == .gym */) || sectionCase == .Offers1st3)
        sectionHeader.lblLine.isHidden = true
        
        sectionHeader.labelTitle.text? = title
        sectionHeader.lblDetail.text = subTitle
        sectionHeader.lblDetail.isHidden = subTitle.isEmpty
        sectionHeader.isOffer = isOffer
        if SKAppType.type.isJNJ && sectionCase == .OffersH {
            sectionHeader.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9843137255, alpha: 1)
        }
        return sectionHeader
    }
    
}
