// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import EZSwiftExtensions
import FlagPhoneNumber

extension UILabel {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized()
        }
    }
    
    func setAlignment() {
        
        if L102Language.isRTL {
            self.textAlignment = .right
        }else {
            self.textAlignment = .left
        }
    }
    
    func setReverseAlignment() {
        
        if L102Language.isRTL {
            self.textAlignment = .left
        }else {
            self.textAlignment = .right
        }
    }
}

class BackButtonImage: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.mirrorTransform()
    }
}
extension UIButton {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized(), for: .normal)
        }
    }
    
//    func setAlignment() {
//        if L102Language.isRTL {
//            self.contentHorizontalAlignment = .right
//        }else {
//            self.contentHorizontalAlignment = .left
//        }
//    }
    
    func setAlignmentWithOffset(space: CGFloat) {
        if L102Language.isRTL {
            self.contentHorizontalAlignment = .right
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
        }else {
            self.contentHorizontalAlignment = .left
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
        }
    }
    
    func adjustImageAndTitleOffsetsForButton(space: CGFloat) {
        
        var spacing: CGFloat = space/2
        
        if L102Language.isRTL {
            spacing = -(space/2)
        }
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
    }
    
}

extension UITextField {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized()
            
        }
    }
    
    func setAlignment() {
        
        if L102Language.isRTL {
            self.textAlignment = .right
        }else {
            self.textAlignment = .left
        }
    }
}

extension FPNTextField {
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        if L102Language.isRTL {
            let newRect: CGRect = CGRect(x: 0, y: (size.height - 28)/2.0, width: 28, height: 28)
            return newRect
        } else {
            //set - open var leftViewSize
            let size = leftViewSize
            let width: CGFloat = min(bounds.size.width, size.width)
            let height: CGFloat = min(bounds.size.height, size.height)
            let newRect: CGRect = CGRect(x: bounds.minX, y: bounds.minY, width: width, height: height)
            return newRect
        }
    }
}

extension UITextView {
    
    func setAlignment() {
        
        if L102Language.isRTL {
            self.textAlignment = .right
            self.semanticContentAttribute = .forceRightToLeft
        }else {
            self.textAlignment = .left
            self.semanticContentAttribute = .forceLeftToRight
        }
    }
}


extension UIView {
    
    func setSemanticContent() {
        
        if L102Language.isRTL {
            self.semanticContentAttribute = .forceRightToLeft
        }else {
            self.semanticContentAttribute = .forceLeftToRight
        }
    }
}

extension UIImageView{
    func mirrorTransform() {
        if L102Language.isRTL {
            self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}


extension UISearchBar {
    
    func setAlignment() {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                if #available(iOS 13, *) {
                    for subvw in subSubView.subviews {
                        if let txtfld = subvw as? UITextField {
                            if L102Language.isRTL {
                                txtfld.textAlignment = .right
                            }else {
                                txtfld.textAlignment = .left
                            }
                            break
                        }
                    }
                } else {
                    if let _ = subSubView as? UITextInputTraits {
                        let textField = subSubView as! UITextField
                        if L102Language.isRTL {
                            textField.textAlignment = .right
                        }else {
                            textField.textAlignment = .left
                        }
                        break
                    }
                }
                
            }
        }
    }
}

enum L11n: String {
    
    case RecommendedExpert = "Recommended Fitness Expert"
    case RecommendedBeautyExpert = "Recommended Beauty Expert"
    case RecommendedSupplier = "Recommended Supplier"
    case RecommendedRestaurants = "Recommended Restaurants"
    case popularRestaurants = "Popular Restaurants"
    case popularProducts = "Popular Products"
    
    case product = "Product"
    case products = "Products"
    
    case supplier = "supplier"
    case suppliers = "suppliers"
    case select = "Select"
    case yearsExperience = "Years Experience"
    
    case result = "Result"
    case results = "Results"
    
    case startOn = "Start on"
    case endOn = "End on"
    case hour = "Hour"
    
    case rate = "Rate"
    case reviews = "Reviews"
    case currentOrders = "Current Orders"
    
    
    case awesomeDealsUnlockedEveryday = "Awesome Deals Unlocked Everyday"
    case checkoutSomeRecommendationsFromOurSide = "Checkout some recommendations from our side"
    
    case categories = "Categories"
    case categoriesHomeSubTitle = "We hand-picked some great services for you."
    
    case recommended = "Royo Recomended"
    case discountItems = "Discount Products"
    case discountItem = "Discount Items"
    case specialOffers = "Special Offers"
    
    case specialOffersHomeSubTitle = "Awesome deals unlocked every day"
    
    case brands = "Popular Brands"
    case Reached
    case pending = "Pending"
    case confirmedOn = "Confirmed On"
    case confirmed = "Confirmed"
    case inTheKitchan = "In The Kitchen"
    case onTheWay = "On The Way"
    case inProgress = "In Progress"
    case Started = "Started"
    case Ended = "Ended"
    case placed = "Placed"
    case wishList = "Wishlist"
    
    case shopByType = "Shop by Type"
    case start = "Start"
    case end = "End"
    case delivered = "Delivered" // Delivered //Nitin
    case nearby = "Near You"
    case shipped = "Shipped"
    case rejected = "Rejected"
    case approved = "Approved"
    case canceled = "Canceled"
    case packed = "Packed"
    case outForDelivery = "Out For Delivery"
    
    case restaurants = "Restaurants"
    
    case pleaseSelectTimeSlot = "Please select Time slot"
    case estimatedEndOn = "Estimated service time"
    case expectedDeliveryOn = "Expected Delivery On"
    case expectedEndOn = "Expected service time"
    
    
    //AddingProductsFromDiffrentSuppliersWillClearYourCart
    case tryToAddDiffrentProductsToCart = "Try to add diffrent type of products to cart will clear your cart"
    var description: String { return self.string }
    
    var string: String {
        return rawValue.localized()
    }
}

enum L10n {
    /// Service Charge
    case ServiceCharge
    /// Min. Service Time
    case MinServiceTime
    /// Visiting Charges
    case VisitingCharges
    /// Min. Delivery Time
    case MinDeliveryTime
    /// Opens at 
    case OpensAt
    /// Please select an Address
    case PleaseSelectAnAddress
    /// Credit/Debit card
    case CreditDebitCard
    /// Your Cart has no items.Please add items to cart to Proceed.
    case YourCartHasNoItemsPleaseAddItemsToCartToProceed
    /// Agents not available for some items.
    case Agentsnotavailableforsomeitems
    /// Landmark
    case Landmark
    /// Address Line First
    case AddressLineFirst
    /// Address Line Second
    case AddressLineSecond
    /// Pincode
    case Pincode
    /// Delivery Address
    case DeliveryAddress
    /// Enter your details.
    case EnterYourDetails
    /// Delivery charges applicable accordingly
    case DeliveryChargesApplicableAccordingly
    /// Delivery charges
    case DeliveryCharges
    /// Select Time and Date
    case SelectTimeAndDate
    /// Please select a booking schedule and time
    case PleaseSelectABookingScheduleAndTime
    /// Select booking time
    case SelectBookingTime
    /// Reordering will clear you cart. Press OK to continue.
    case ReOrderingWillClearYouCart
    /// Pending
    case PENDING
    /// Delivered
    case DELIVERED
    /// Confirmed
    case CONFIRMED
    /// Feedback Given
    case FEEDBACKGIVEN
    /// Rejected
    case REJECTED
    /// Shipped
    case SHIPPED
    /// Near By
    case NEARBY
    /// Tracked
    case TRACKED
    /// Cancelled
    case CUSTOMERCANCELLED
    /// Scheduled
    case SCHEDULED
    /// Order Details
    case OrderDetails
    /// items
    case Items
    /// REORDER
    case REORDER
    /// TRACK
    case TRACK
    /// BOOKED
    case BOOKED
    /// CANCEL ORDER
    case CANCELORDER
    /// CONFIRM ORDER
    case CONFIRMORDER
    case PAYNOW
    /// Monthly
    case Monthly
    /// Weekly
    case Weekly
    /// Pickup
    case Pickup
    
    case PleaseEnterYourEmailAddressOrPhoneNumber
    /// Please enter your email address
    case PleaseEnterYourEmailAddress
    /// Please enter a valid email address
    case PleaseEnterAValidEmailAddress
    /// Please enter your password
    case PleaseEnterYourPassword
    /// Password should be minimum 6 characters.
    case PasswordShouldBeMinimum6Characters
    /// Current session expired \n Please Login to continue.
    case SessionExpiredLoginToContinue
    /// OTP Sent.
    case OTPSent
    /// Select picture
    case SelectPicture
    /// Please select your profile picture.
    case PleaseSelectYourProfilePicture
    /// Please enter your name.
    case PleaseEnterYourName
    /// Please enter your first name.
    case PleaseEnterYourFName
    /// Please enter your  last name.
    case PleaseEnterYourLName
    /// Camera
    case Camera
    /// Photo Library
    case PhotoLibrary
    /// Home
    case Home
    /// Live support
    case LiveSupport
    /// Cart
    case Cart
    /// Promotions
    case Promotions
    /// Notifications
    case Notifications
    /// My Account
    case MyAccount
    /// My favorites
    case MyFavorites
    /// Order history
    case OrderHistory
    /// Track my order
    case TrackMyOrder
    /// Rate my order
    case RateMyOrder
    /// Upcoming orders
    case UpcomingOrders
    /// Loyality points
    case LoyalityPoints
    /// Share app
    case ShareApp
    /// Settings
    case Settings
    /// Guest
    case Guest
    /// Welcome
    case Welcome
    /// Points
    case Points
    /// Grocery
    case Grocery
    /// Laundry
    case Laundry
    /// Household
    case Household
    /// Flowers
    case Flowers
    /// Fitness
    case Fitness
    /// Photography
    case Photography
    /// Baby sitter
    case BabySitter
    /// Cleaning
    case Cleaning
    /// Party
    case Party
    /// Beauty salon
    case BeautySalon
    /// Medicines
    case Medicines
    /// Water delivery
    case WaterDelivery
    /// Packages
    case Packages
    /// OK
    case OK
    /// Save
    case Save
    /// Cancel
    case Cancel
    /// Choose booking cycle
    case ChooseBookingCycle
    ///  Reviews
    case Reviews
    /// AED 
    case AED
    
    /// Each
    case Each
    /// Each
    case EachOnly
    
    
    ///  Mins
    case Mins
    /// Results for 
    case ResultsFor
    /// Days
    case Days
    /// Per
    case Per
    /// Hours
    case Hours
    /// Discoverability
    case Discoverability
    /// Delivery
    case Delivery
    /// Supplier Type
    case SupplierType
    /// Rating
    case Rating
    /// 1 Star
    case _1Star
    /// 2 Star
    case _2Star
    /// 3 Star
    case _3Star
    /// 4 Star and above
    case _4StarAndAbove
    /// Gold
    case Gold
    /// Silver
    case Silver
    /// Platinum
    case Platinum
    /// Cash on delivery
    case CashOnDelivery
    /// Card
    case Card
    /// Both
    case Both
    /// Online
    case Online
    /// Busy
    case Busy
    /// Closed
    case Closed
    /// Cancelled
    case Cancelled
    /// Change Password
    case ChangePassword
    /// Notifications Language
    case NotificationsLanguage
    /// Manage Address
    case ManageAddress
    /// Logout
    case Logout
    /// Select notification language
    case SelectNotificationLanguage
    /// English
    case English
    /// Arabic
    case Arabic
    ///Spanish
    case Spanish
    /// You haven't earned any loyalty points yet.
    case YouHavenTEarnedAnyLoyaltyPointsYet
    /// Please select produts from same supplier
    case SelectProdutsFromSameSupplier
    /// No Remarks
    case NoRemarks
    /// When do you want the service?
    case WhenDoYouWantTheService
    /// Pickup location
    case PickupLocation
    /// Select pickup date and time
    case SelectPickupDateAndTime
    /// Are you sure you want to delete this address.
    case AreYouSureYouWantToDeleteThisAddress
    /// Select Country
    case SelectCountry
    /// Select City
    case SelectCity
    /// Select Zone
    case SelectZone
    /// Select Area
    case SelectArea
    /// Please select all fields above.
    case PleaseSelectAllFieldsAbove
    /// Please select a country
    case PleaseSelectACountry
    /// Please select a city
    case PleaseSelectACity
    /// Please fill all details
    case PleaseFillAllDetails
    /// Please enter valid Pincode
    case PleaseEnterValidPincode
    /// Old Password
    case OldPassword
    /// New Password
    case NewPassword
    /// Confirm Password
    case ConfirmPassword
    /// New Password must not be same as old password
    case NewPasswordMustNotBeSameAsOldPassword
    /// Passwords do not match
    case PasswordsDoNotMatch
    /// Forgot Password
    case ForgotPassword
    /// Password recovery has been sent to your email id
    case PasswordRecoveryHasBeenSentToYourEmailId
    /// The Leading Online Home Services In UAE.. https://itunes.apple.com/us/app/clikat/id1147970115?ls=1&mt=8
    case TheLeadingOnlineHomeServicesInUAE
    /// Vacila la primera app de delivery en Venezuela! Tienen de todo:https://itunes.apple.com/us/app/%@/id1147970115?ls=1&mt=8
    case ShareAppYummy
    /// Please check your internet connection.
    case PleaseCheckYourInternetConnection
    /// Cancel Order
    case CancelOrder
    /// Success
    case Success
    /// Do you really want to cancel this order?
    case DoYouReallyWantToCancelThisOrder
    ///Password Changed Successfully
    case PasswordChangedSuccess
    /// You have cancelled your order successfully
    case YouHaveCancelledYourOrderSuccessfully
    /// Log out!
    case LogOut
    /// Are you sure you want to logout?
    case AreYouSureYouWantToLogout
    /// You are successfully logged out
    case YouAreSuccessfullyLoggedOut
    /// Please enter valid country code followed by phone number
    case PleaseEnterValidCountryCodeFollowedByPhoneNumber
    /// Please enter valid phone number
    case PleaseEnterValidPhoneNumber
    /// Delivery Speed
    case DeliverySpeed
    /// Sorry… Your Order is Below Minimum Order Price.
    case SorryYourOrderIsBelowMinimumOrderPrice
    /// Recommended
    case Recommended
    /// Offers
    case Offers
    /// SpecialOffers
    case SpecialOffers
    /// Select Category
    case selectCategory
    /// Select Cuisine
    case selectCuisine
    /// please
    case please
    
    /// Your order has been placed successfully.
    case YourOrderHaveBeenPlacedSuccessfully
    /// Order placed successfully
    case OrderPlacedSuccessfully
    /// Your order has been scheduled successfully
    case YourOrderHaveBeenSheduledSuccessfully
    /// Are you sure?
    case AreYouSure
    /// Changing the language will clear your cart. Are you sure you want to proceed?
    case ChangingTheLanguageWillClearYourCart
    /// Typing
    case Typing
    /// Offline
    case Offline
    /// Email
    case Email
    /// Not rated yet
    case NotRatedYet
    /// Search
    case Search
    /// Other
    case Other
    /// Status
    case Status
    /// Loyalty Points Type
    case LoyaltyPointsType
    /// Payment Method
    case PaymentMethod
    /// Terms & Conditions
    case TermsAndConditions
    /// About Us
    case AboutUs
    /// Sort
    case Sort
    /// Open
    case Open
    /// Now
    case Now
    
    /// Adding products from different suppliers will clear your cart.
    case AddingProductsFromDiffrentSuppliersWillClearYourCart
    
    /// Adding products from different Agent will clear your cart.
    case AddingProductsFromDiffrentAgentWillClearYourCart
    
    case AddingProductsFromDiffrentCategoryWillClearYourCart

       case SingleProductQuantity

    /// Min. Order Amount
    case MinOrderAmount
    /// Min. Delviery Time
    case MinDelvieryTime
    /// Home Service
    case HOMESERVICE
    /// At Place Service
    case ATPLACESERVICE
    /// Select service
    case SelectService
    /// Ladies Beauty Salon
    case LadiesBeautySalon
    /// City
    case Country
    
    /// City
    case City
    /// Area
    case Area
    /// House No.
    case HouseNo
    /// Compare Products
    case CompareProducts
    /// Somewhere, Somehow, Something Went Wrong
    case SomewhereSomehowSomethingWentWrong
    /// Adding products from promotions will clear your cart.
    case AddingProductsFromPromotionsWillClearYourCart
    /// Please enter your house no.
    case PleaseEnterYourHouseNo
    /// Please enter your building name
    case PleaseEnterYourBuildingName
    /// Please select your location
    case PleaseSelectYourLocation
    /// Please enter a landmark name
    case PleaseEnterALandmarkName
    /// Please enter your city
    case PleaseEnterYourCity
    /// Please enter your counrty
    case PleaseEnterYourCounrty
    /// My Orders
    case MyOrders
    ///  not available 
    case NotAvailable
    /// Your Order will be confirmed during next supplier working hours/day.
    case YourOrderWillBeConfirmedDuringNextSupplierWorkingHoursDay
    /// Changing the current area will clear you cart.
    case ChangingTheCurrentAreaWillClearYouCart
    /// Change pick up time no suppliers are available for this pickup timing
    case ChangePickUpTimeNoSuppliersAreAvailableForThisPickupTiming
    /// No supplier found!
    case NoSupplierFound
    /// My Addresses
    case MyAddresses
    /// Item Detail
    case ItemDetail
    /// Scheduled Orders
    case ScheduledOrders
    /// Sorry, not enough points to redeem.
    case SorryNotEnoughPointsToRedeem
    /// Loading
    case Loading
    /// Looks like your order has been delivered. Would you like to rate your order?
    case LooksLikeYourOrderHasBeenDeliveredWouldYouLikeToRateYourOrder
    /// Rate Order
    case RateOrder
    /// Quantity : 
    case Quantity
    /// Delivered on
    case DeliveredOn
    /// Pending Orders
    case PendingOrders
    /// End
    case IosZDCChatEnd
    /// Email address
    case IosZDCChatEmailPlaceholder
    /// Message
    case IosZDCChatPreChatFormMessagePlaceholder
    /// File type not permitted
    case IosZDCChatUploadErrorType
    /// Could not connect
    case IosZDCChatCantConnectTitle
    /// %@ needs access to your photos
    case IosZDCChatAccessGallery(String)
    /// No agents available
    case IosZDCChatNoAgentsTitle
    /// Back
    case IosZDCChatBackButton
    /// Fields marked with * are required
    case IosZDCChatPreChatFormRequired
    /// Failed to download. Tap to retry.
    case IosZDCChatDownloadFailedMessage
    /// Please enter a valid email address
    case IosZDCChatPreChatFormInvalidEmail
    /// No connection
    case IosZDCChatNoConnectionTitle
    /// Could not send message
    case IosZDCChatSendOfflineMessageErrorTitle
    /// Leave a comment
    case IosZDCChatRatingCommentTitle
    /// Save image
    case IosZDCChatImageViewerSaveButton
    /// Reconnecting...
    case IosZDCChatReconnecting
    /// email@address.com
    case IosZDCChatTranscriptEmailAlertEmailPlaceholder
    /// Cancel
    case IosZDCChatCancelButton
    /// Enable this from the home screen, Settings > %@
    case IosZDCChatAccessHowto(String)
    /// OK
    case IosZDCChatOk
    /// No
    case IosZDCChatNo
    /// Connection lost
    case IosZDCChatChatConnectionLostTitle
    /// %@ *
    case IosZDCChatPreChatFormRequiredTemplate(String)
    /// Done
    case IosZDCChatDone
    /// Before you end this chat, would you like to email a transcript?
    case IosZDCChatTranscriptEmailAlertMessage
    /// Error accessing file
    case IosZDCChatUploadErrorAccess
    /// Please wait for an agent. There are currently %@ visitor(s) waiting to be served.
    case IosZDCChatVisitorQueue(String)
    /// No Internet connection. Please try again when connected
    case IosZDCChatNoConnectionMessage
    /// Name
    case IosZDCChatPreChatFormNamePlaceholder
    /// %@ needs access to your camera
    case IosZDCChatAccessCamera(String)
    /// Send
    case IosZDCChatChatTextEntrySendButton
    /// Retry
    case IosZDCChatRetry
    /// Starting chat...
    case IosZDCChatChatStartingChatMessage
    /// Message
    case IosZDCChatChatTextEntryPlaceholderText
    /// There are no agents currently online.
    case IosZDCChatAgentsOfflineMessage
    /// What can we help you with?
    case IosZDCChatPreChatFormDepartmentPlaceholder
    /// %@ left the chat
    case IosZDCChatAgentLeft(String)
    /// Would you like to retry?
    case IosZDCChatSendOfflineMessageErrorMessage
    /// Failed to send. Tap to retry.
    case IosZDCChatUnsentMessage
    /// Phone number
    case IosZDCChatPreChatFormPhonePlaceholder
    /// Sorry, there are no agents available to chat. Please try again later or leave us a message.
    case IosZDCChatNoAgentsMessage
    /// We've not heard from you for a while so this chat session has been closed. Please start a new chat if you still have questions.
    case IosZDCChatTimeoutMessage
    /// Send
    case IosZDCChatTranscriptEmailAlertSendButton
    /// Take photo
    case IosZDCChatUploadSourceCamera
    /// Leave a comment...
    case IosZDCChatRatingCommentButton
    /// No connection
    case IosZDCChatNetworkConnectionError
    /// Sorry, we can't connect you right now. Please try again later.
    case IosZDCChatCantConnectMessage
    /// End chat
    case IosZDCChatChatEndedTitle
    /// File size too large
    case IosZDCChatUploadErrorSize
    /// Please enter a valid phone number
    case IosZDCChatPreChatFormInvalidPhone
    /// Send
    case IosZDCChatSendOfflineMessageErrorSendButton
    /// Email a transcript
    case IosZDCChatTranscriptEmailAlertTitle
    /// End chat
    case IosZDCChatEndButton
    /// Are you sure you would like to end this chat?
    case IosZDCChatChatEndedMessage
    /// Unable to send message.
    case IosZDCChatOfflineMessageFailedMessage
    /// Leave a comment
    case IosZDCChatRatingCommentPlaceholder
    /// %@ joined the chat
    case IosZDCChatAgentJoined(String)
    /// Leave a message
    case IosZDCChatNoAgentsButton
    /// Message
    case IosZDCChatMessageButton
    /// Chat
    case IosZDCChatTitle
    /// Next
    case IosZDCChatNextButton
    /// Cancel
    case IosZDCChatCancel
    /// There are currently no agents online. Would you like to send a message?
    case IosZDCChatAccountOfflineMessage
    /// Photo library
    case IosZDCChatUploadSourceGallery
    /// We have been unable to reconnect. Do you wish to continue trying?
    case IosZDCChatChatConnectionLostMessage
    /// Rate this chat
    case IosZDCChatRatingTitle
    /// Edit comment...
    case IosZDCChatRatingEditButton
    /// Yes
    case IosZDCChatYes
    /// Don't send
    case IosZDCChatTranscriptEmailAlertDontSendButton
    /// no connection, please check the internet connection
    case InternetConnectionMessage
    /// Sorry, something went wrong please try again!
    case GeneralError
    /// Cancel this payment?
    case TitleMessage
    /// Invalid card number
    case InvaildCard
    /// NO
    case NoBtn
    /// Done
    case DoneBtn
    /// Ok
    case OkBtn
    /// Credit Card number must consist of 16 digits.
    case InvaildCardNumber
    /// Pay
    case PayBtn
    /// Init a secure connection...
    case InitConn
    /// Your Receipt
    case YourReceiptLbl
    /// Required field,cannot be left empty
    case PfCancelRequiredField
    /// Credit Card
    case TitleviewLbl
    /// Alert
    case AlertTitle
    /// EXPIRY DATE
    case ExpDateLbl
    /// The entered credit card type does not match the selected payment option.
    case PfErrorsCardNumberMismatchPo
    /// CARDHOLDER NAME
    case CardNamePl
    /// the date in the past
    case PASTDATEMSG
    /// CARD NUMBER
    case CardNumberPl
    /// Month & Year
    case MonthyearLbl
    /// CVV
    case CVCtxt
    /// SAVE THIS CARD
    case SaveCarLbl
    /// technical problem
    case TechnicalIssue
    /// YES
    case YesBtn
    /// Great
    case PfRespPageGreat
    /// Failed
    case PfRespPageFailed
    /// Invalid Expiry Date
    case InvalidExp
    /// Invalid CVV
    case InvalidCVV
    /// Expected Delivery On
    case ExpectedDeliveryOn
    /// By signing up you agree to the 
    case BySigningUpYouAgreeToThe
    /// Privacy Policy
    case PrivacyPolicy
    /// Terms and conditions.
    case TermsAndConditionsSignUp
    ///  and 
    case And
    /// I would like to recommend using
    case IWouldLikeToRecommendUsing
    /// via Clikat
    case ViaClikat
    /// Warning
    case Warning
    /// Please select dates to schedule.
    case PleaseSelectDatesToSchedule
    /// Bronze
    case Bronze
    /// Notification Language Changed Successfully
    case NotificationLanguageChangedSuccessfully
    /// Order Confirmed Successfully
    case OrderConfirmedSuccessfully
    /// Delivery on
    case DeliveryOn
    /// No Product Found!
    case NoProductFound
    /// Have you Forgot Completing Your Last Shopping Cart?
    case HaveYouForgotCompletingYourLastShoppingCart
    /// Supplier Rated Successfully
    case SupplierRatedSuccessfully
    /// Search for product
    case SearchForProduct
    /// Send
    case Send
    /// Sub Total
    case SubTotal
    /// Camera Unavailable
    case CameraUnavailable
    /// It looks like your privacy settings are preventing us from accessing your camera.
    case ItLooksLikeYourPrivacySettingsArePreventingUsFromAccessingYourCamera
    /// Location Unavailable
    case LocationUnavailable
    /// Please check to see if you have enabled location services.
    case PleaseCheckToSeeIfYouHaveEnabledLocationServices
    
    /// No varient found regarding this poroduct.
    case Novarientfoundregardingthisporoduct
    //By
    case by
    
    //AgentAvailable
    case AgentAvailable
    
    //AgentNotAvailable
    case AgentNotAvailable
    
    case CompletedOrders
    case OrderNo
    case TrackOrder
    case PlacedOn
    case ShopByType
}

extension L10n: CustomStringConvertible {
    var description: String { return self.string }
    
    func stringFor(appType: SKAppType?) -> String {
        let type = appType ?? SKAppType.type
        let orderLocTerm = TerminologyKeys.order.localizedValue() as? String ?? ""
        let ordersLocTerm = TerminologyKeys.orders.localizedValue() as? String ?? ""
        switch self {
        case .PAYNOW:
            return L10n.tr(key: "PAY NOW")
        case .PlacedOn :
            return L10n.tr(key: "Placed on")
        case .ServiceCharge:
            return L10n.tr(key: "Service Charge")
        case .PasswordChangedSuccess:
            return L10n.tr(key: "Password has been updated successfully")
        case .MinServiceTime:
            return L10n.tr(key: "Min. Service Time")
        case .VisitingCharges:
            return L10n.tr(key: "Visiting Charges")
        case .MinDeliveryTime:
            return L10n.tr(key: "Min. Delivery Time")
        case .OpensAt:
            return L10n.tr(key: "Opens at ")
        case .PleaseSelectAnAddress:
            return L10n.tr(key: "Please select an address")
        case .CreditDebitCard:
            return L10n.tr(key: "Credit/Debit card")
            
        case .Agentsnotavailableforsomeitems:
            return L10n.tr(key: "Agents not available for some items.")
            
        case .YourCartHasNoItemsPleaseAddItemsToCartToProceed:
            return L10n.tr(key: "Your cart does not have any item.Please add some items to the cart to proceed.")
        case .Landmark:
            return L10n.tr(key: "Landmark")
        case .AddressLineFirst:
            return L10n.tr(key: "Address Line First")
        case .AddressLineSecond:
            return L10n.tr(key: "Address Line Second")
        case .Pincode:
            return L10n.tr(key: "Pincode")
        case .DeliveryAddress:
            return "\(orderLocTerm) \(L10n.tr(key: "Address"))"
            //return type == .home ? L10n.tr(key: "Booking Address") : L10n.tr(key: "Order Address")
        case .EnterYourDetails:
            return L10n.tr(key: "Enter your details.")
        case .DeliveryChargesApplicableAccordingly:
            return L10n.tr(key: "Delivery charges applicable accordingly")
        case .DeliveryCharges:
            return L10n.tr(key: "Delivery charges")
        case .SelectTimeAndDate:
            return L10n.tr(key: "Select Time and Date")
        case .PleaseSelectABookingScheduleAndTime:
            return L10n.tr(key: "Please select a booking schedule and time")
        case .SelectBookingTime:
            return L10n.tr(key: "Select booking time")
        case .ReOrderingWillClearYouCart:
            return type == .home ? L10n.tr(key: "Booking again will clear you cart") : L10n.tr(key: "Reordering will clear you cart")
        case .PENDING:
            return L10n.tr(key: "PENDING")
        case .DELIVERED:
            return L10n.tr(key: "DELIVERED")
        case .CONFIRMED:
            return L10n.tr(key: "CONFIRMED")
        case .FEEDBACKGIVEN:
            return L10n.tr(key: "FEEDBACKGIVEN")
        case .REJECTED:
            return L10n.tr(key: "REJECTED")
        case .SHIPPED:
            return L10n.tr(key: "SHIPPED")
        case .NEARBY:
            return L10n.tr(key: "NEARBY")
        case .TRACKED:
            return L10n.tr(key: "TRACKED")
        case .CUSTOMERCANCELLED:
            return L10n.tr(key: "CUSTOMER CANCELLED")
        case .SCHEDULED:
            return L10n.tr(key: "SCHEDULED")
        case .OrderDetails:
            return "\(orderLocTerm) \(L10n.tr(key: "Details"))"
            //return type == .home ? L10n.tr(key: "Booking Details") : L10n.tr(key: "Order Details")
        case .Items:
            return L10n.tr(key: "items")
        case .REORDER:
            return type == .home ? L10n.tr(key: "BOOK AGAIN") : L10n.tr(key: "REORDER")
        case .TRACK:
            return L10n.tr(key: "TRACK")
        case .BOOKED:
            return L10n.tr(key: "BOOKED")
        case .CANCELORDER:
            return "\(L10n.tr(key: "CANCEL")) \(orderLocTerm)".uppercased()
            //return type == .home ? L10n.tr(key: "CANCEL BOOKING") : L10n.tr(key: "CANCEL ORDER")
        case .CONFIRMORDER:
            return "\(L10n.tr(key: "CONFIRM")) \(orderLocTerm)".uppercased()
            //return type == .home ? L10n.tr(key: "CONFIRM BOOKING") : L10n.tr(key: "CONFIRM ORDER")
        case .Monthly:
            return L10n.tr(key: "Monthly")
        case .Weekly:
            return L10n.tr(key: "Weekly")
        case .Pickup:
            return L10n.tr(key: "Pickup")
                
        case .PleaseEnterYourEmailAddressOrPhoneNumber:
            return L10n.tr(key: "Please enter email address/phone number")
            
        case .PleaseEnterYourEmailAddress:
            return L10n.tr(key: "Please enter email address")
        case .PleaseEnterAValidEmailAddress:
            return L10n.tr(key: "Please enter valid email address")
        case .PleaseEnterYourPassword:
            return L10n.tr(key: "Please enter password")
        case .PasswordShouldBeMinimum6Characters:
            return L10n.tr(key: "Password length must be at least 6 characters long.")
        case .SessionExpiredLoginToContinue:
            return L10n.tr(key: "Sorry, your account has been logged in other device! Please login again to continue.")
        case .OTPSent:
            return L10n.tr(key: "OTP has been sent successfully.")
        case .SelectPicture:
            return L10n.tr(key: "Select picture")
        case .PleaseSelectYourProfilePicture:
            return L10n.tr(key: "Please select profile picture")
        case .PleaseEnterYourName:
            return L10n.tr(key: "Please enter name")
        case .PleaseEnterYourFName:
            return L10n.tr(key: "Please enter first name")
        case .PleaseEnterYourLName:
            return L10n.tr(key: "Please enter last name")
        case .Camera:
            return L10n.tr(key: "Camera")
        case .PhotoLibrary:
            return L10n.tr(key: "Photo Library")
        case .Home:
            return L10n.tr(key: "Home")
        case .LiveSupport:
            return L10n.tr(key: "Live Support")
        case .Cart:
            return L10n.tr(key: "Cart")
        case .Promotions:
            return L10n.tr(key: "Promotions")
        case .Notifications:
            return L10n.tr(key: "Notifications")
        case .MyAccount:
            return L10n.tr(key: "My Account")
        case .MyFavorites:
            return L10n.tr(key: "My Favorites")
        case .OrderHistory:
            return "\(orderLocTerm) \(L10n.tr(key: "History"))"
            //return type == .home ? L10n.tr(key: "Booking History") : L10n.tr(key: "Order History")
        case .TrackMyOrder:
            return "\(L10n.tr(key: "Track My")) \(orderLocTerm)"
            //return type == .home ? L10n.tr(key: "Track My Booking") : L10n.tr(key: "Track My Order")
        case .RateMyOrder:
            return "\(L10n.tr(key: "Rate My")) \(orderLocTerm)"
            //return type == .home ? L10n.tr(key: "Rate My Booking") : L10n.tr(key: "Rate My Order")
        case .UpcomingOrders:
            return "\(L10n.tr(key: "Upcoming")) \(ordersLocTerm)"
            //return type == .home ? L10n.tr(key: "Upcoming Bookings") : L10n.tr(key: "Upcoming Orders")
        case .LoyalityPoints:
            return L10n.tr(key: "Loyality Points")
        case .ShareApp:
            return L10n.tr(key: "Share App")
        case .Settings:
            return L10n.tr(key: "Settings")
        case .Guest:
            return L10n.tr(key: "Guest")
        case .Welcome:
            return L10n.tr(key: "Welcome")
        case .Points:
            return L10n.tr(key: "Points")
        case .Grocery:
            return L10n.tr(key: "Grocery")
        case .Laundry:
            return L10n.tr(key: "Laundry")
        case .Household:
            return L10n.tr(key: "Household")
        case .Flowers:
            return L10n.tr(key: "Flowers")
        case .Fitness:
            return L10n.tr(key: "Fitness")
        case .Photography:
            return L10n.tr(key: "Photography")
        case .BabySitter:
            return L10n.tr(key: "Baby sitter")
        case .Cleaning:
            return L10n.tr(key: "Cleaning")
        case .Party:
            return L10n.tr(key: "Party")
        case .BeautySalon:
            return L10n.tr(key: "Beauty salon")
        case .Medicines:
            return L10n.tr(key: "Medicines")
        case .WaterDelivery:
            return L10n.tr(key: "Water delivery")
        case .Packages:
            return L10n.tr(key: "Packages")
        case .OK:
            return L10n.tr(key: "OK")
        case .Save:
            return L10n.tr(key: "Save")
        case .Cancel:
            return L10n.tr(key: "Cancel")
        case .ChooseBookingCycle:
            return L10n.tr(key: "Choose booking cycle")
        case .Reviews:
            return L10n.tr(key: "reviews")
        case .AED:
            return L10n.tr(key: "$") // Nitin
        case .Mins:
            return L10n.tr(key: "mins")
        case .ResultsFor:
            return L10n.tr(key: "Results for ")
        case .Days:
            return L10n.tr(key: "days")
        case .Per:
            return L10n.tr(key: "per")
        case .Hours:
            return L10n.tr(key: "Hours")
        case .Discoverability:
            return L10n.tr(key: "Discoverability")
        case .Delivery:
            return L10n.tr(key: "Delivery")
        case .SupplierType:
            return L10n.tr(key: "Supplier Type")
        case .Rating:
            return L10n.tr(key: "Rating")
        case ._1Star:
            return L10n.tr(key: "1 Star")
        case ._2Star:
            return L10n.tr(key: "2 Star")
        case ._3Star:
            return L10n.tr(key: "3 Star")
        case ._4StarAndAbove:
            return L10n.tr(key: "4 Star and above")
        case .Gold:
            return L10n.tr(key: "Gold")
        case .Silver:
            return L10n.tr(key: "Silver")
        case .Platinum:
            return L10n.tr(key: "Platinum")
        case .CashOnDelivery:
            return L10n.tr(key: "Cash on Delivery")
        case .Card:
            return L10n.tr(key: "Card")
        case .Both:
            return L10n.tr(key: "Both")
        case .Online:
            return L10n.tr(key: "Online")
        case .Busy:
            return L10n.tr(key: "Busy")
        case .Closed:
            return L10n.tr(key: "Closed")
        case .Cancelled:
            return L10n.tr(key: "Cancelled")
        case .ChangePassword:
            return L10n.tr(key: "Change Password")
        case .NotificationsLanguage:
            return L10n.tr(key: "Notifications Language")
        case .ManageAddress:
            return L10n.tr(key: "Saved Address")
        case .Logout:
            return L10n.tr(key: "Logout")
        case .SelectNotificationLanguage:
            return L10n.tr(key: "Select notification language")
        case .English:
            return L10n.tr(key: "English")
        case .Arabic:
            return L10n.tr(key: "Arabic")
        case .Spanish:
            return L10n.tr(key: "Spanish")
        case .YouHavenTEarnedAnyLoyaltyPointsYet:
            return L10n.tr(key: "You haven't earned any loyalty points yet")
            
        case .SelectProdutsFromSameSupplier:
            return L10n.tr(key: "Select \(L11n.products.rawValue) from same \(L11n.supplier.rawValue)")
            
        case .NoRemarks:
            return L10n.tr(key: "No Remarks")
        case .WhenDoYouWantTheService:
            return L10n.tr(key: "When do you want the service?")
        case .PickupLocation:
            return L10n.tr(key: "Choose Location")
        case .SelectPickupDateAndTime:
            return L10n.tr(key: "Select pickup date and time")
        case .AreYouSureYouWantToDeleteThisAddress:
            return L10n.tr(key: "Are you sure you want to delete this address?")
        case .SelectCountry:
            return L10n.tr(key: "Select Country")
        case .SelectCity:
            return L10n.tr(key: "Select City")
        case .SelectZone:
            return L10n.tr(key: "Select Zone")
        case .SelectArea:
            return L10n.tr(key: "Select Area")
        case .PleaseSelectAllFieldsAbove:
            return L10n.tr(key: "Please select all fields above")
        case .PleaseSelectACountry:
            return L10n.tr(key: "Please select a country")
        case .PleaseSelectACity:
            return L10n.tr(key: "Please select a city")
        case .PleaseFillAllDetails:
            return L10n.tr(key: "Please fill all details")
        case .PleaseEnterValidPincode:
            return L10n.tr(key: "Please enter valid Pincode")
        case .OldPassword:
            return L10n.tr(key: "Old Password")
        case .NewPassword:
            return L10n.tr(key: "New Password")
        case .ConfirmPassword:
            return L10n.tr(key: "Confirm Password")
        case .NewPasswordMustNotBeSameAsOldPassword:
            return L10n.tr(key: "New Password must not be the same as old password")
        case .PasswordsDoNotMatch:
            return L10n.tr(key: "Passwords do not match")
        case .ForgotPassword:
            return L10n.tr(key: "Forgot Password")
        case .PasswordRecoveryHasBeenSentToYourEmailId:
            return L10n.tr(key: "Reset password details has been sent to your email id")
        case .TheLeadingOnlineHomeServicesInUAE:
            return String(format: L10n.tr(key: "The Leading Online Home Services In UAE"), /ez.appDisplayName?.replacingOccurrences(of: " ", with: ""))
        case .ShareAppYummy:
            return String(format: L10n.tr(key: "ShareAppYummy"), /ez.appDisplayName?.replacingOccurrences(of: " ", with: ""))
        case .PleaseCheckYourInternetConnection:
            return L10n.tr(key: "Please check your internet connection")
        case .CancelOrder:
            return "\(L10n.tr(key: "Cancel")) \(orderLocTerm)"
            //return type == .home ?  L10n.tr(key: "Cancel Booking") : L10n.tr(key: "Cancel Order")
        case .Success:
            return L10n.tr(key: "Success")
        case .DoYouReallyWantToCancelThisOrder:
            return type == .home ?  L10n.tr(key: "Do you really want to cancel this booking?") : L10n.tr(key: "Do you really want to cancel this order?")
        case .YouHaveCancelledYourOrderSuccessfully:
            return type == .home ?  L10n.tr(key: "Your booking has been canceled successfully.") : L10n.tr(key: "Your order has been canceled successfully.")
        case .LogOut:
            return L10n.tr(key: "Logout")
        case .AreYouSureYouWantToLogout:
            return L10n.tr(key: "Are you sure you want to logout?")
        case .YouAreSuccessfullyLoggedOut:
            return L10n.tr(key: "You are logged out successfully")
        case .PleaseEnterValidCountryCodeFollowedByPhoneNumber:
            return L10n.tr(key: "Please enter valid country code followed by phone number")
        case .PleaseEnterValidPhoneNumber:
            return L10n.tr(key: "Please enter valid phone number")
        case .DeliverySpeed:
            return L10n.tr(key: "Delivery Speed")
        case .SorryYourOrderIsBelowMinimumOrderPrice:
            return L10n.tr(key: "Sorry… Your order is below minimum order price.")
        case .Recommended:
            return L10n.tr(key: "Recommended")
        case .Offers:
            return L10n.tr(key: "Offers")
        case .YourOrderHaveBeenPlacedSuccessfully:
            return type == .home ? L10n.tr(key: "Your booking has been placed successfully") : L10n.tr(key: "Your order has been placed successfully")
        case .OrderPlacedSuccessfully:
            if type == .home {
                return L10n.tr(key: "Booking placed successfully")
            }
            return L10n.tr(key: "Order placed successfully")
        case .YourOrderHaveBeenSheduledSuccessfully:
            return L10n.tr(key: "Your order has been scheduled successfully")
        case .AreYouSure:
            return L10n.tr(key: "Are you sure")
        case .ChangingTheLanguageWillClearYourCart:
            return L10n.tr(key: "Changing the language will clear your cart.")
        case .Typing:
            return L10n.tr(key: "Typing")
        case .Offline:
            return L10n.tr(key: "Offline")
        case .Email:
            return L10n.tr(key: "Email")
        case .NotRatedYet:
            return L10n.tr(key: "Not rated yet")
        case .Search:
            return L10n.tr(key: "Search")
        case .Other:
            return L10n.tr(key: "Other")
        case .Status:
            return L10n.tr(key: "Status")
        case .LoyaltyPointsType:
            return L10n.tr(key: "Loyalty Points Type")
        case .PaymentMethod:
            return L10n.tr(key: "Payment Method")
        case .TermsAndConditions:
            return L10n.tr(key: "Terms and Conditions")
        case .AboutUs:
            return L10n.tr(key: "About Us")
        case .Sort:
            return L10n.tr(key: "Sort")
        case .Open:
            return L10n.tr(key: "Open")
        case .Now:
            return L10n.tr(key: "Now")
        case .SingleProductQuantity:
            return L10n.tr(key: "Adding different service will clear your cart")
        case .AddingProductsFromDiffrentAgentWillClearYourCart:
            return L10n.tr(key: "Adding \(L11n.products.rawValue) from different Agent will clear your cart")
        case .AddingProductsFromDiffrentSuppliersWillClearYourCart:
            if AppSettings.shared.isSingleProduct {
                return L10n.tr(key: "Adding different service will clear your cart")
            }
            return L10n.tr(key: "Adding \(L11n.products.rawValue) from different \(type.isFood ? "restaurant" : "supplier") will clear your cart") // \(L11n.suppliers.rawValue)
        case .MinOrderAmount:
            return L10n.tr(key: "Min. Order Amount")
        case .MinDelvieryTime:
            return L10n.tr(key: "Min. Delivery Time")
        case .HOMESERVICE:
            return L10n.tr(key: "HOME SERVICE")
        case .ATPLACESERVICE:
            return L10n.tr(key: "AT PLACE SERVICE")
        case .SelectService:
            return L10n.tr(key: "Select service")
        case .LadiesBeautySalon:
            return L10n.tr(key: "Ladies Beauty Salon")
        case .Country:
            return L10n.tr(key: "Country")
        case .City:
            return L10n.tr(key: "City")
        case .Area:
            return L10n.tr(key: "Area")
        case .HouseNo:
            return L10n.tr(key: "House No")
        case .CompareProducts:
            return L10n.tr(key: "Compare Products")
        case .SomewhereSomehowSomethingWentWrong:
            return L10n.tr(key: "Somewhere Somehow Something Went Wrong")
        case .AddingProductsFromPromotionsWillClearYourCart:
            return L10n.tr(key: "Adding \(L11n.products.rawValue) from promotions will clear your cart")
        case .PleaseEnterYourHouseNo:
            return L10n.tr(key: "Please enter your house no.")
        case .PleaseEnterYourBuildingName:
            return L10n.tr(key: "Please enter your building name")
        case .PleaseSelectYourLocation:
            return L10n.tr(key: "Please select your location")
        case .PleaseEnterALandmarkName:
            return L10n.tr(key: "Please enter landmark name")
        case .PleaseEnterYourCity:
            return L10n.tr(key: "Please enter your city")
        case .PleaseEnterYourCounrty:
            return L10n.tr(key: "Please enter your country")
        case .MyOrders:
            return "\(L10n.tr(key: "My")) \(ordersLocTerm)"
            //return type == .home ? L10n.tr(key: "My Bookings") : L10n.tr(key: "My Orders")
        case .NotAvailable:
            return L10n.tr(key: "Not Available")
        case .YourOrderWillBeConfirmedDuringNextSupplierWorkingHoursDay:
            return L10n.tr(key: "Your order will be confirmed during \(L11n.supplier.rawValue)’s next working hours/day.")
        case .ChangingTheCurrentAreaWillClearYouCart:
            return L10n.tr(key: "Changing the current area will clear you cart")
        case .ChangePickUpTimeNoSuppliersAreAvailableForThisPickupTiming:
            return L10n.tr(key: "Change pick up time no \(L11n.suppliers.rawValue) are available for this pickup timing")
        case .NoSupplierFound:
            return L10n.tr(key: "No \(L11n.supplier.rawValue) found")
        case .MyAddresses:
            return L10n.tr(key: "My Addresses")
        case .ItemDetail:
            return L10n.tr(key: "Item Detail")
        case .ScheduledOrders:
            return type == .home ? L10n.tr(key: "Scheduled Bookings") : L10n.tr(key: "Scheduled Orders")
        case .SorryNotEnoughPointsToRedeem:
            return L10n.tr(key: "Sorry! You don’t have enough points to redeem.")
        case .Loading:
            return L10n.tr(key: "Loading")
        case .LooksLikeYourOrderHasBeenDeliveredWouldYouLikeToRateYourOrder:
            return type == .home ? L10n.tr(key: "Looks like your service had been completed. Would you like to rate the service?") : L10n.tr(key: "Looks like your order has been delivered. Would you like to rate your order?")
        case .RateOrder:
            return "\(L10n.tr(key: "Rate")) \(ordersLocTerm)"
            //return type == .home ? L10n.tr(key: "Rate Booking") : L10n.tr(key: "Rate Order")
        case .Quantity:
            return L10n.tr(key: "Quantity")
        case .DeliveredOn:
            return L10n.tr(key: "Delivered on")
        case .PendingOrders:
            return "\(L10n.tr(key: "Pending")) \(ordersLocTerm)"
            //return type == .home ? L10n.tr(key: "Pending Bookings") : L10n.tr(key: "Pending Orders")
        case .CompletedOrders:
            return "\(L10n.tr(key: "Completed")) \(ordersLocTerm)"
            //return type == .home ? L10n.tr(key: "Completed Bookings") : L10n.tr(key: "Completed Orders")
        case .OrderNo:
            return "\(orderLocTerm) \(L10n.tr(key: "No."))"
            //return type == .home ? L10n.tr(key: "Booking No.") : L10n.tr(key: "Order No.")
        case .IosZDCChatEnd:
            return L10n.tr(key: "ios.ZDCChat.end")
        case .IosZDCChatEmailPlaceholder:
            return L10n.tr(key: "ios.ZDCChat.emailPlaceholder")
        case .IosZDCChatPreChatFormMessagePlaceholder:
            return L10n.tr(key: "ios.ZDCChat.preChatForm.messagePlaceholder")
        case .IosZDCChatUploadErrorType:
            return L10n.tr(key: "ios.ZDCChat.upload.error.type")
        case .IosZDCChatCantConnectTitle:
            return L10n.tr(key: "ios.ZDCChat.cantConnectTitle")
        case .IosZDCChatAccessGallery(let p0):
            return L10n.tr(key: "ios.ZDCChat.access.gallery", p0)
        case .IosZDCChatNoAgentsTitle:
            return L10n.tr(key: "ios.ZDCChat.noAgentsTitle")
        case .IosZDCChatBackButton:
            return L10n.tr(key: "ios.ZDCChat.backButton")
        case .IosZDCChatPreChatFormRequired:
            return L10n.tr(key: "ios.ZDCChat.preChatForm.required")
        case .IosZDCChatDownloadFailedMessage:
            return L10n.tr(key: "ios.ZDCChat.download.failedMessage")
        case .IosZDCChatPreChatFormInvalidEmail:
            return L10n.tr(key: "ios.ZDCChat.preChatForm.invalidEmail")
        case .IosZDCChatNoConnectionTitle:
            return L10n.tr(key: "ios.ZDCChat.noConnectionTitle")
        case .IosZDCChatSendOfflineMessageErrorTitle:
            return L10n.tr(key: "ios.ZDCChat.sendOfflineMessageError.title")
        case .IosZDCChatRatingCommentTitle:
            return L10n.tr(key: "ios.ZDCChat.rating.comment.title")
        case .IosZDCChatImageViewerSaveButton:
            return L10n.tr(key: "ios.ZDCChat.imageViewer.saveButton")
        case .IosZDCChatReconnecting:
            return L10n.tr(key: "ios.ZDCChat.reconnecting")
        case .IosZDCChatTranscriptEmailAlertEmailPlaceholder:
            return L10n.tr(key: "ios.ZDCChat.transcriptEmailAlert.emailPlaceholder")
        case .IosZDCChatCancelButton:
            return L10n.tr(key: "ios.ZDCChat.cancelButton")
        case .IosZDCChatAccessHowto(let p0):
            return L10n.tr(key: "ios.ZDCChat.access.howto", p0)
        case .IosZDCChatOk:
            return L10n.tr(key: "ios.ZDCChat.ok")
        case .IosZDCChatNo:
            return L10n.tr(key: "ios.ZDCChat.no")
        case .IosZDCChatChatConnectionLostTitle:
            return L10n.tr(key: "ios.ZDCChat.chatConnectionLost.title")
        case .IosZDCChatPreChatFormRequiredTemplate(let p0):
            return L10n.tr(key: "ios.ZDCChat.preChatForm.requiredTemplate", p0)
        case .IosZDCChatDone:
            return L10n.tr(key: "ios.ZDCChat.done")
        case .IosZDCChatTranscriptEmailAlertMessage:
            return L10n.tr(key: "ios.ZDCChat.transcriptEmailAlert.message")
        case .IosZDCChatUploadErrorAccess:
            return L10n.tr(key: "ios.ZDCChat.upload.error.access")
        case .IosZDCChatVisitorQueue(let p0):
            return L10n.tr(key: "ios.ZDCChat.visitorQueue", p0)
        case .IosZDCChatNoConnectionMessage:
            return L10n.tr(key: "ios.ZDCChat.noConnectionMessage")
        case .IosZDCChatPreChatFormNamePlaceholder:
            return L10n.tr(key: "ios.ZDCChat.preChatForm.namePlaceholder")
        case .IosZDCChatAccessCamera(let p0):
            return L10n.tr(key: "ios.ZDCChat.access.camera", p0)
        case .IosZDCChatChatTextEntrySendButton:
            return L10n.tr(key: "ios.ZDCChat.chatTextEntry.sendButton")
        case .IosZDCChatRetry:
            return L10n.tr(key: "ios.ZDCChat.retry")
        case .IosZDCChatChatStartingChatMessage:
            return L10n.tr(key: "ios.ZDCChat.chat.startingChatMessage")
        case .IosZDCChatChatTextEntryPlaceholderText:
            return L10n.tr(key: "ios.ZDCChat.chatTextEntry.placeholderText")
        case .IosZDCChatAgentsOfflineMessage:
            return L10n.tr(key: "ios.ZDCChat.agentsOffline.message")
        case .IosZDCChatPreChatFormDepartmentPlaceholder:
            return L10n.tr(key: "ios.ZDCChat.preChatForm.departmentPlaceholder")
        case .IosZDCChatAgentLeft(let p0):
            return L10n.tr(key: "ios.ZDCChat.agentLeft", p0)
        case .IosZDCChatSendOfflineMessageErrorMessage:
            return L10n.tr(key: "ios.ZDCChat.sendOfflineMessageError.message")
        case .IosZDCChatUnsentMessage:
            return L10n.tr(key: "ios.ZDCChat.unsentMessage")
        case .IosZDCChatPreChatFormPhonePlaceholder:
            return L10n.tr(key: "ios.ZDCChat.preChatForm.phonePlaceholder")
        case .IosZDCChatNoAgentsMessage:
            return L10n.tr(key: "ios.ZDCChat.noAgentsMessage")
        case .IosZDCChatTimeoutMessage:
            return L10n.tr(key: "ios.ZDCChat.timeoutMessage")
        case .IosZDCChatTranscriptEmailAlertSendButton:
            return L10n.tr(key: "ios.ZDCChat.transcriptEmailAlert.sendButton")
        case .IosZDCChatUploadSourceCamera:
            return L10n.tr(key: "ios.ZDCChat.upload.source.camera")
        case .IosZDCChatRatingCommentButton:
            return L10n.tr(key: "ios.ZDCChat.rating.commentButton")
        case .IosZDCChatNetworkConnectionError:
            return L10n.tr(key: "ios.ZDCChat.network.connectionError")
        case .IosZDCChatCantConnectMessage:
            return L10n.tr(key: "ios.ZDCChat.cantConnectMessage")
        case .IosZDCChatChatEndedTitle:
            return L10n.tr(key: "ios.ZDCChat.chatEndedTitle")
        case .IosZDCChatUploadErrorSize:
            return L10n.tr(key: "ios.ZDCChat.upload.error.size")
        case .IosZDCChatPreChatFormInvalidPhone:
            return L10n.tr(key: "ios.ZDCChat.preChatForm.invalidPhone")
        case .IosZDCChatSendOfflineMessageErrorSendButton:
            return L10n.tr(key: "ios.ZDCChat.sendOfflineMessageError.sendButton")
        case .IosZDCChatTranscriptEmailAlertTitle:
            return L10n.tr(key: "ios.ZDCChat.transcriptEmailAlert.title")
        case .IosZDCChatEndButton:
            return L10n.tr(key: "ios.ZDCChat.endButton")
        case .IosZDCChatChatEndedMessage:
            return L10n.tr(key: "ios.ZDCChat.chatEndedMessage")
        case .IosZDCChatOfflineMessageFailedMessage:
            return L10n.tr(key: "ios.ZDCChat.offlineMessageFailed.message")
        case .IosZDCChatRatingCommentPlaceholder:
            return L10n.tr(key: "ios.ZDCChat.rating.comment.placeholder")
        case .IosZDCChatAgentJoined(let p0):
            return L10n.tr(key: "ios.ZDCChat.agentJoined", p0)
        case .IosZDCChatNoAgentsButton:
            return L10n.tr(key: "ios.ZDCChat.noAgentsButton")
        case .IosZDCChatMessageButton:
            return L10n.tr(key: "ios.ZDCChat.messageButton")
        case .IosZDCChatTitle:
            return L10n.tr(key: "ios.ZDCChat.title")
        case .IosZDCChatNextButton:
            return L10n.tr(key: "ios.ZDCChat.nextButton")
        case .IosZDCChatCancel:
            return L10n.tr(key: "ios.ZDCChat.cancel")
        case .IosZDCChatAccountOfflineMessage:
            return L10n.tr(key: "ios.ZDCChat.accountOffline.message")
        case .IosZDCChatUploadSourceGallery:
            return L10n.tr(key: "ios.ZDCChat.upload.source.gallery")
        case .IosZDCChatChatConnectionLostMessage:
            return L10n.tr(key: "ios.ZDCChat.chatConnectionLost.message")
        case .IosZDCChatRatingTitle:
            return L10n.tr(key: "ios.ZDCChat.rating.title")
        case .IosZDCChatRatingEditButton:
            return L10n.tr(key: "ios.ZDCChat.rating.editButton")
        case .IosZDCChatYes:
            return L10n.tr(key: "ios.ZDCChat.yes")
        case .IosZDCChatTranscriptEmailAlertDontSendButton:
            return L10n.tr(key: "ios.ZDCChat.transcriptEmailAlert.dontSendButton")
        case .InternetConnectionMessage:
            return L10n.tr(key: "internetConnectionMessage")
        case .GeneralError:
            return L10n.tr(key: "general_error")
        case .TitleMessage:
            return L10n.tr(key: "titleMessage")
        case .InvaildCard:
            return L10n.tr(key: "InvaildCard")
        case .NoBtn:
            return L10n.tr(key: "noBtn")
        case .DoneBtn:
            return L10n.tr(key: "doneBtn")
        case .OkBtn:
            return L10n.tr(key: "okBtn")
        case .InvaildCardNumber:
            return L10n.tr(key: "InvaildCardNumber")
        case .PayBtn:
            return L10n.tr(key: "PayBtn")
        case .InitConn:
            return L10n.tr(key: "Init_conn")
        case .YourReceiptLbl:
            return L10n.tr(key: "YourReceiptLbl")
        case .PfCancelRequiredField:
            return L10n.tr(key: "pf_cancel_required_field")
        case .TitleviewLbl:
            return L10n.tr(key: "titleviewLbl")
        case .AlertTitle:
            return L10n.tr(key: "alertTitle")
        case .ExpDateLbl:
            return L10n.tr(key: "ExpDateLbl")
        case .PfErrorsCardNumberMismatchPo:
            return L10n.tr(key: "pf_errors_card_number_mismatch_po")
        case .CardNamePl:
            return L10n.tr(key: "CardNamePl")
        case .PASTDATEMSG:
            return L10n.tr(key: "PAST_DATE_MSG")
        case .CardNumberPl:
            return L10n.tr(key: "CardNumberPl")
        case .MonthyearLbl:
            return L10n.tr(key: "monthyearLbl")
        case .CVCtxt:
            return L10n.tr(key: "CVCtxt")
        case .SaveCarLbl:
            return L10n.tr(key: "saveCarLbl")
        case .TechnicalIssue:
            return L10n.tr(key: "TechnicalIssue")
        case .YesBtn:
            return L10n.tr(key: "yesBtn")
        case .PfRespPageGreat:
            return L10n.tr(key: "pf_resp_page_great")
        case .PfRespPageFailed:
            return L10n.tr(key: "pf_resp_page_failed")
        case .InvalidExp:
            return L10n.tr(key: "InvalidExp")
        case .InvalidCVV:
            return L10n.tr(key: "InvalidCVV")
        case .ExpectedDeliveryOn:
            return L10n.tr(key: "Expected Delivery On")
        case .BySigningUpYouAgreeToThe:
            return L10n.tr(key: "By signing up you agree to the ")
        case .PrivacyPolicy:
            return L10n.tr(key: "Privacy Policy")
        case .TermsAndConditionsSignUp:
            return L10n.tr(key: "Terms and conditionsSignUp")
        case .And:
            return L10n.tr(key: "and")
        case .IWouldLikeToRecommendUsing:
            return L10n.tr(key: "I would like to recommend using")
        case .ViaClikat:
            return L10n.tr(key: "via Clikat")
        case .Warning:
            return L10n.tr(key: "Warning")
        case .PleaseSelectDatesToSchedule:
            return L10n.tr(key: "Please select date to schedule.")
        case .Bronze:
            return L10n.tr(key: "Bronze")
        case .NotificationLanguageChangedSuccessfully:
            return L10n.tr(key: "Notification language changed successfully")
        case .OrderConfirmedSuccessfully:
            return "\(orderLocTerm) \(L10n.tr(key: "confirmed successfully"))"
            //return type == .home ? L10n.tr(key: "Booking confirmed successfully") : L10n.tr(key: "Order confirmed successfully")
        case .DeliveryOn:
            return L10n.tr(key: "Delivery on")
        case .NoProductFound:
            return L10n.tr(key: "No Product Found!")
        case .HaveYouForgotCompletingYourLastShoppingCart:
            return L10n.tr(key: "Have you forgot completing your last shopping cart?")
        case .SupplierRatedSuccessfully:
            return L10n.tr(key: "Supplier rated successfully")
        case .SearchForProduct:
            return L10n.tr(key: "Search for \(L11n.product.rawValue)")
        case .Send:
            return L10n.tr(key: "Send")
        case .SubTotal:
            return L10n.tr(key: "Sub Total")
        case .CameraUnavailable:
            return L10n.tr(key: "Camera Unavailable")
        case .ItLooksLikeYourPrivacySettingsArePreventingUsFromAccessingYourCamera:
            return L10n.tr(key: "It looks like your privacy settings are preventing us from accessing your camera.")
        case .LocationUnavailable:
            return L10n.tr(key: "Location Unavailable")
        case .PleaseCheckToSeeIfYouHaveEnabledLocationServices:
            return L10n.tr(key: "Please check if you have enabled location services.")
        case .Novarientfoundregardingthisporoduct:return L10n.tr(key: "No variant found regarding this \(L11n.product.rawValue).")
        case .by:return L10n.tr(key: "by")
        case .SpecialOffers: return L10n.tr(key: "Special Offers")
        case .selectCategory : return L10n.tr(key: "Select Category")
        case .selectCuisine : return L10n.tr(key: "Select Cuisine")
        case .please : return L10n.tr(key: "Please")
        case .Each: return L10n.tr(key: "") // /Each //Nitin
        case .EachOnly: return L10n.tr(key: "") // Each // Nitin
            
        case .AgentAvailable: return L10n.tr(key: "Agent Available")
        case .AgentNotAvailable: return L10n.tr(key:"Agent Not Available")
        case .TrackOrder: return type == .home ? L10n.tr(key: "Track Agent") : L10n.tr(key: "Track Order")
        case .ShopByType:
            return type == .home ? L10n.tr(key: "Services by Type") : L10n.tr(key: "Shop by Type")
            
        case .AddingProductsFromDiffrentCategoryWillClearYourCart:
            return L10n.tr(key: "Adding product from different category will clear your cart")
        }
    }
    
    var string: String {
        return stringFor(appType: SKAppType.type)
    }
    
    private static func tr(key: String, _ args: CVarArg...) -> String {
        //    let format = NSLocalizedString(key, comment: "")
        //     return String(format: format, locale: NSLocale.currentLocale(), arguments: args)
        var str = key
        if str.contains("Products") {
            str = str.replacingOccurrences(of: "Products", with: SKAppType.type.products)
        }
        else if str.contains("Product") {
            str = str.replacingOccurrences(of: "Product", with: SKAppType.type.product)
        }
        else if str.contains("Suppliers") {
            str = str.replacingOccurrences(of: "Suppliers", with: SKAppType.type.supplier)
        }
        else if str.contains("Supplier") {
            str = str.replacingOccurrences(of: "Supplier", with: SKAppType.type.suppliers)
        }
        else if str.contains("Agent") {
            str = str.replacingOccurrences(of: "Agent", with: SKAppType.type.agent)
        } else if str.contains("SHIPPED") {
            str = str.replacingOccurrences(of: "SHIPPED", with: SKAppType.type.shipped)
        }
        return str.localized()
    }
}

func tr(key: L10n) -> String {
    return key.string
}

