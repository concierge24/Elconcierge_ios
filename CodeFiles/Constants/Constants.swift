//
//  Constants.swift
//  Clikat Supplier
//
//  Created by Night Reaper on 08/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import UIKit

let LowPadding : CGFloat = 8.0
let MidPadding : CGFloat = 16.0
let HighPadding : CGFloat = 20.0
let ButtonKernValue : CGFloat = 1.4
// let GoogleApiKey = "AIzaSyDs8YqnioeTkumLcPSBIWvFXjW6j6PS05s"
//let GoogleApiKey = "AIzaSyDNjbIaiPB41uhvhD0mb9Xdi2tA7n0AFlo"
//"AIzaSyD49Pfe0ohX_7CwQitpcbVhw2uwtSEmQJ8"
//"AIzaSyBt1gnaGlEbPRwDcCAZDz1vbxSKzt3Xnfo"//"AIzaSyDY4z2mxbk9otYBTCQgvnsPMDoEmHFX3po"//"AIzaSyCNAdSEpIbtSy2rkdGpKqwZMaOv4_WUpJ4"
//AIzaSyDNjbIaiPB41uhvhD0mb9Xdi2tA7n0AFlo

//Nitin
// AIzaSyABTsTfbYhYNrAT18nni9WKP77lf-dNHtM

// GoogleApiKey
var GoogleApiKey : String {
    return FeatureType.googleMapsKey
}
var FacebookKey : String {
    return FeatureType.facebookKey
}

let RemoteNotification = "ClikatUserPush"
let UrlSchemeNotification = "ClikatUserScheme"
let FBUrlScheme = "fb1747479878832188"

//struct Languages {
//    static let Arabic = "ar"
//    static let English = "en"
//}

struct CameraMode {
    static let Camera = L10n.Camera.string
    static let PhotoLibrary = L10n.PhotoLibrary.string
}

struct Fonts {
    struct ProximaNova {
        static let Regular = "ProximaNova-regular"
        static let Bold = "ProximaNova-bold"
        static let Light = "ProximaNova-light"
        static let SemiBold = "ProximaNova-Semibold"
    }
}

enum Size : CGFloat {
    case Small = 12.0
    case Medium = 14.0
    case Large = 16.0
    case XLarge = 18.0
    case XXLarge = 20.0
}

enum Colors : String {
    
    case MainColor = "0x2B8488"
    case YellowColor = "0xfcbf06"
    case GreenColor = "0x48CE8B"
    case RedColor = "0xD66D5F"
    case lightGrayBackgroundColor = "0xF0F0F0"
    case sponsorBackGround = "0xFBFADD"
    case strokeStart = "0xFBC12A"
    case strokeMid = "0xE9C672"
    case strokeEnd = "0xFBCB42"
    
    case AlertButton = "0xAEDEF4"
    
    func color() -> UIColor {
        if self == .MainColor || self == .AlertButton {
            return SKAppType.type.color
        }
        return UIColor(hexString: self.rawValue)!
    }
}

struct DateFormat {
    
    static let TimeFormatUI = "hh : mm a"
    static let DateFormatUI = "MMM dd EEEE"
    static let DateFormatGeneric = "dd MM yyyy"
}

struct ApplicationWebLinks {

    static let cblLink = "http://www.code-brew.com/"
    static let jnjFacebookLink = "https://www.facebook.com/codebrewlabs/"
    static let jnjTwitterLink = "https://twitter.com/codebrewlabs"
    static let jnjInstagramLink = "https://www.instagram.com/codebrewlabs"
    static let jnjYoutubeLink = "https://www.youtube.com/channel/UCh6EaKNcFhtxgF27KUQGw1w"
    static let FacebookLink = "https://www.facebook.com/sneni.saneni.5"
    static let TwitterLink = "https://twitter.com/sn3ni"
    static let InstagramLink = "https://www.instagram.com/sn3ni_/"
    static let YoutubeLink = "https://www.youtube.com/channel/UCunsVs3-1ArxAGeE6_2gpyQ/videos"
}

struct CellIdentifiers  {
    
    static let SideMenuCell = "SideMenuCell"
    static let ServiceTypeCell = "ServiceTypeCell"
    static let ServiceTypeCellHori = "ServiceTypeCellHori"
    static let ServiceTypeCellCat = "ServiceTypeCellCat"
    static let ServiceTypeCellFood = "ServiceTypeCellFood"

    static let ServiceTypeParentCell = "ServiceTypeParentCell"
    static let HomeProductParentCell = "HomeProductParentCell"
    static let HomeProductCell = "HomeProductCell"
    static let HomeProductCellEcommerce = "HomeProductCellEcommerce"
    
    static let BannerParentCell = "BannerParentCell"
    static let BannerCell = "BannerCell"
    static let SupplierListingCell = "SupplierListingCell"
    static let OrderParentCell = "OrderParentCell"
    static let OrderImageCell = "OrderImageCell"
    static let FavoritesCell = "FavoritesCell"
    static let NotificationsCell = "NotificationsCell"
    static let PromotionsCell = "PromotionsCell"
    static let SubCategoryListingCell = "SubCategoryListingCell"
    static let ProductCollectionCell = "ProductCollectionCell"
    static let SearchTableCell = "SearchTableCell"
    static let OrderStatusCell = "OrderStatusCell"
    static let OrderDetailCell = "OrderDetailCell"
    static let SupplierInfoCell = "SupplierInfoCell"
    static let SupplierInfoHeaderCollectionCell = "SupplierInfoHeaderCollectionCell"
    static let SupplierInfoTabCell = "SupplierInfoTabCell"
    static let SupplierInfoHeaderView = "SupplierInfoHeaderView"
    static let MyReviewCell = "MyReviewCell"
    static let OtherReviewCell = "OtherReviewCell"
    static let SupplierDescriptionCell = "SupplierDescriptionCell"
    static let ProductInfoHeaderView = "ProductInfoHeaderView"
    static let ProductDetailFirstCell = "ProductDetailFirstCell"
    static let HomeSectionHeader = "HomeSectionHeader"
    static let ProductListingCell = "ProductListingCell"
    static let ServiceCell = "ServiceCell"
    static let LaundryServiceHeaderView = "LaundryServiceHeaderView"
    static let OrderSummaryCell = "OrderSummaryCell"
    static let OrderBillCell = "OrderBillCell"
    static let CartBillCell = "CartBillCell"
    static let LocationSearchCell = "LocationTableCell"
    static let LoyalityPointsCell = "LoyalityPointsCell" 
    static let FilterCell = "FilterCell"
    static let FilterOptionCell = "FilterOptionCell"
    static let DeliveryAddressCell = "DeliveryAddressCell"
    static let DeliverySpeedCell = "DeliverySpeedCell"
    static let TimeAndDateCell = "TimeAndDateCell"
    static let DeliveryAddressCollectionCell = "DeliveryAddressCollectionCell"
    static let PickupDateCell = "PickupDateCell"
    static let SettingsCell = "SettingsCell"
    static let LoyalityPointsHeader = "LoyalityPointsHeader"
    
    static let ProductView = "ProductView"
    static let SupplierRatingPopUp = "SupplierRatingPopUp"
    
    static let LiveSupportMyCell = "LiveSupportMyCell"
    static let LiveSupportOtherCell = "LiveSupportOtherCell"
    
    static let SupplierCollectionCell = "SupplierCollectionCell"
    
    static let OrderDeliveryDetailView = "OrderDeliveryDetailView"
    static let CategorySelectionCell = "CategorySelectionCell"
    
    static let LaundrySupplierInfoCell = "LaundrySupplierInfoCell"
    static let LaundryProductCell = "LaundryProductCell"
    static let LaundryBillCell = "LaundryBillCell"
    static let FilterSliderCell = "FilterSliderCell"
    static let SponsorView = "SponsorView"
    
    static let FloatingSupplierView = "FloatingSupplierView"
    static let CompareProductsCell = "CompareProductsCell"
    static let LaundrySectionHeader = "LaundrySectionHeader"
    static let HomeSearchCell = "HomeSearchCell"
    static let FilterSearchCell = "FilterSearchCell"
    
    static let SearchTableViewCell = "SearchTableViewCell"
    
    static let FilterTableViewSortedCell = "FilterTableViewSortedCell"
    static let PriceRangeTableViewCell = "PriceRangeTableViewCell"
    static let CategoryTableViewCell = "CategoryTableViewCell"
    static let VairantTableViewCell = "VairantTableViewCell"
    static let VariantCollectionViewCell = "VariantCollectionViewCell"
    static let CustomHeaderCell = "CustomHeaderCell"
    static let FilterSubcategoryTableViewCell = "FilterSubcategoryTableViewCell"
    
    static let PorductVariantBannerTblCell = "PorductVariantBannerTblCell"
    
    static let DeliveryLocationTblCell = "DeliveryLocationTblCell"
    static let RatingReviewTblCell = "RatingReviewTblCell"
    static let CartListingCell = "CartListingCell"
    
    static let RateReviewCell = "RateReviewCell"
    static let AgentListingTblCell = "AgentListingTblCell"
  
    static let MoreTableCell = "MoreTableViewCell"
    static let CardTVC = "CardTVC"
    static let CardUICell = "CardUICell"
    static let HomeServiceCategoryCollectionCell = "HomeServiceCategoryCollectionCell"
    static let VariantView = "VariantView"
    static let QuestionCell = "QuestionCell"
}

let CartNotification = "CartNotication"
let FilterNotification = "FilterNotication"
