// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

protocol StoryboardSceneType {
    static var storyboardName: String { get }
}

extension StoryboardSceneType {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }
    
    static func initialViewController() -> UIViewController {
        guard let vc = storyboard().instantiateInitialViewController() else {
            fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
        }
        return vc
    }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
    //Nitin
    func tabBarViewController() -> UITabBarController {
        guard let vc = Self.storyboard().instantiateViewController(withIdentifier: self.rawValue) as? UITabBarController else {  fatalError("MainTabBarViewController not found.") }
        return vc
    }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
    func performSegue<S: StoryboardSegueType>(segue: S, sender: AnyObject? = nil) where S.RawValue == String {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}

struct StoryboardScene {
    enum LaunchScreen: StoryboardSceneType {
        static let storyboardName = "LaunchScreen"
    }
    
    enum Main: String, StoryboardSceneType {
        case none

        static let storyboardName = "Main"
        
        static func instantiateDrawerMenuViewController() -> DrawerMenuViewController {
            return DrawerMenuViewController.getVC(.main)
        }

        static func instantiateHomeViewController() -> UIViewController {
           // if AppSettings.shared.app_type > 10 {
             //   return DoctorHomeVC.getVC(.doctorHome)
            //}
            return HomeViewController.getVC(.main)
        }
        
        case EcommerceHomeViewController = "EcommerceHomeViewController"
        static func instantiateEcommerceHomeViewController() -> HomeViewController {
            guard let vc = StoryboardScene.Main.EcommerceHomeViewController.viewController() as? HomeViewController else {
                    fatalError("ViewController 'HomeViewController' is not of the expected class HomeViewController.")
            }
            return vc
        }
        //Nitin
        case MainTabBarViewController = "MainTabBarViewController"
        static func instantiateMainTabBarController() -> MainTabBarViewController {
            guard let vc = StoryboardScene.Main.MainTabBarViewController.tabBarViewController() as? MainTabBarViewController else { fatalError("MainTabBarViewController not found.")
            }
            return vc
        }
        
        static func instantiateMoreViewController() -> MoreViewController {
            return MoreViewController.getVC(.main)
        }
        
        static func instantiateMapViewController() -> MapViewController {
            return MapViewController.getVC(.main)
        }
        
        static func instantiateRoyorentalHomeController() -> RoyoRentalHomeViewController {
            return RoyoRentalHomeViewController.getVC(.main)
        }
        
        static func instantiateRentalSupplierController() -> RentalSupplierListingViewController {
            return RentalSupplierListingViewController.getVC(.main)
        }
        
        static func instantiateRentalSupplierDetailController() -> RentalSupplierDetailViewController {
            return RentalSupplierDetailViewController.getVC(.main)
        }
        
        static func instantiateRentalFavouritesController() -> RentalFavouritesViewController {
            return RentalFavouritesViewController.getVC(.main)
        }
        
        static func instantiateLeftNavigationViewController() -> LeftNavigationViewController {
            return LeftNavigationViewController.getVC(.main)
        }
        
        static func instantiatePackageProductListingViewController() -> PackageProductListingViewController {
            return PackageProductListingViewController.getVC(.main)
        }
        
        static func instantiatePackageSupplierListingViewController() -> PackageSupplierListingViewController {
            return PackageSupplierListingViewController.getVC(.main)
        }
        
        static func instantiateProductDetailViewController() -> ProductDetailViewController {
            return ProductDetailViewController.getVC(.main)
        }
        
        static func instantiateRightNavigationViewController() -> RightNavigationViewController {
            return RightNavigationViewController.getVC(.main)
        }
        
        static func instantiateSearchViewController() -> SearchViewController {
            return SearchViewController.getVC(.main)
        }
        
        static func instantiateServicesViewController() -> ServicesViewController {
            return ServicesViewController.getVC(.main)
        }
        
        static func instantiateSubcategoryViewController() -> SubcategoryViewController {
            return SubcategoryViewController.getVC(.main)
        }
        
        static func instantiateSupplierInfoViewControllerNoFood() -> SupplierInfoViewControllerNoFood {
            return SupplierInfoViewControllerNoFood.getVC(.main)
        }
        
        static func instantiateSupplierInfoViewController() -> SupplierInfoViewController {
            return SupplierInfoViewController.getVC(.main)
        }
        
        static func instantiateSupplierListingViewController() -> SupplierListingViewController {
            return SupplierListingViewController.getVC(.main)
        }
                
        static func instantiateProductVariantVC() -> ProductVariantVC {
            return ProductVariantVC.getVC(.main)
        }
    }
    
   
    
    enum Options: String, StoryboardSceneType {
        case none
        
        static let storyboardName = "Options"
        
        static func instantiateAddCardViewController() -> AddCardViewController {
            return AddCardViewController.getVC(.options)
        }
        
        static func instantiateCustomizationViewController() -> CustomizationViewController {
            return CustomizationViewController.getVC(.options)
        }
        
        static func instantiateCheckCustomizationViewController() -> CheckCustomizationViewController {
            return CheckCustomizationViewController.getVC(.options)
        }
        
        static func instantiateAddressPickerViewController() -> AddressPickerViewController {
            return AddressPickerViewController.getVC(.options)
        }
        
        static func instantiateBarCodeScannerViewController() -> BarCodeScannerViewController {
            return BarCodeScannerViewController.getVC(.options)
        }
        
        static func instantiateCartViewController() -> CartViewController {
            return CartViewController.getVC(Stortyboad.options)
        }
        
        static func instantiateCategorySelectionController() -> CategorySelectionController {
            return CategorySelectionController.getVC(Stortyboad.options)
        }
        
        static func instantiateCompareProductResultController() -> CompareProductResultController {
            return CompareProductResultController.getVC(Stortyboad.options)
        }
        
        static func instantiateCompareProductsController() -> CompareProductsController {
            return CompareProductsController.getVC(.options)
        }
        
        static func instantiateFilterViewController() -> FilterViewController {
            return FilterViewController.getVC(.options)
        }
        
        static func instantiateRentalPaymentSummaryController()-> RentalPaymentSummaryViewController {
            return RentalPaymentSummaryViewController.getVC(.options)
        }
        
        static func instantiateLiveSupportViewController() -> LiveSupportViewController {
            return LiveSupportViewController.getVC(.options)
        }
        
        static func instantiateLoyalityPointsViewController() -> LoyalityPointsViewController {
            return LoyalityPointsViewController.getVC(.options)
        }
        
        static func instantiateLoyaltyPointOrdersController() -> LoyaltyPointOrdersController {
            return LoyaltyPointOrdersController.getVC(.options)
        }
        
        static func instantiateMyFavoritesViewController() -> MyFavoritesViewController {
            return MyFavoritesViewController.getVC(.options)
        }
        
        static func instantiateNotificationsViewController() -> NotificationsViewController {
            return NotificationsViewController.getVC(.options)
        }
        
        static func instantiatePromotionsViewController() -> PromotionsViewController {
            return PromotionsViewController.getVC(.options)
        }
        
        static func instantiateSettingsViewController() -> SettingsViewController {
            return SettingsViewController.getVC(.options)
        }
        
        static func instantiateTermsAndConditionsController() -> TermsAndConditionsController {
            return TermsAndConditionsController.getVC(.options)
        }
    }
    
    enum Order: String, StoryboardSceneType {
        
        case none
        
        static let storyboardName = "Order"
        
        static func instantiateDeliveryViewController() -> DeliveryViewController {
            return DeliveryViewController.getVC(.order)
        }
        
        static func instantiateLoyaltyPointsSummaryController() -> LoyaltyPointsSummaryController {
            return LoyaltyPointsSummaryController.getVC(.order)
        }
        
        static func instantiateOrderDetailController() -> OrderDetailController {
            return OrderDetailController.getVC(.order)
        }
        
        static func instantiateOrderHistoryViewController() -> OrderHistoryViewController {
            return OrderHistoryViewController.getVC(.order)
        }
        
        static func instantiateOrderSchedularViewController() -> OrderSchedularViewController {
            return OrderSchedularViewController.getVC(.order)
        }
        
        static func instantiateOrderSummaryController() -> OrderSummaryController {
            return OrderSummaryController.getVC(.order)
        }
        
        static func instantiatePaymentMethodController() -> PaymentMethodController {
            return PaymentMethodController.getVC(.order)
        }
        
        static func instantiateRateMyOrderController() -> RateMyOrderController {
            return RateMyOrderController.getVC(.order)
        }
        
        static func instantiateScheduledOrderController() -> ScheduledOrderController {
            return ScheduledOrderController.getVC(.order)
        }
        
        static func instantiateTrackMyOrderViewController() -> TrackMyOrderViewController {
            return TrackMyOrderViewController.getVC(.order)
        }
        
        static func instantiateUpcomingOrdersViewController() -> UpcomingOrdersViewController {
            return UpcomingOrdersViewController.getVC(.order)
        }
        
        static func instantiateRateReviews() -> RateReviewsVC {
            return RateReviewsVC.getVC(.order)
        }
        
        static func instantiateAgentTimeSlotVC() -> AgentTimeSlotVC {
            return AgentTimeSlotVC.getVC(.order)
        }
    }
    
    enum Register: String, StoryboardSceneType {
        case none
        static let storyboardName = "Register"
        
        static func instantiateLocationViewController() -> LocationViewController {
            return LocationViewController.getVC(.register)
        }
        
        static func instantiateLoginViewController() -> UIViewController {
            if /AppSettings.shared.appThemeData?.user_register_flow == "1" {
                return SignupSelectionVC.getVC(.register)
            }
            return LoginViewController.getVC(.register)
        }
        
        static func instantiateLoginNewVC() -> LoginNewVC {
            return LoginNewVC.getVC(.register)
        }
        
        static func instantiateOTPViewController() -> OTPViewController {
            return OTPViewController.getVC(.register)
        }
        
        static func instantiatePhoneNoViewController() -> PhoneNoViewController {
            return PhoneNoViewController.getVC(.register)
        }
        
        static func instantiateRegisterFirstStepController() -> RegisterFirstStepController {
            return RegisterFirstStepController.getVC(.register)
        }
        
        static func instantiateRegisterViewController() -> RegisterViewController {
            return RegisterViewController.getVC(.register)
        }
        
        static func instantiateRegisterSingleScreenVC() -> RegisterSingleScreenVC {
            return RegisterSingleScreenVC.getVC(.register)
        }
    }
    
    enum Splash: String, StoryboardSceneType {
        case none
        static let storyboardName = "Splash"
        
        static func instantiateSplashViewController() -> SplashVC {
            return SplashVC.getVC(.splash)
        }
        
    }
    
}
