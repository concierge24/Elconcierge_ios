//
//  CategorySelectionController.swift
//  Clikat
//
//  Created by cblmacmini on 6/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class CategorySelectionController: CategoryFlowBaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewNavBar: UIView!{
        didSet{
            viewNavBar.alpha = 0.0
        }
    }
    
    //MARK:- Variables
    var headerHeight: CGFloat = 236
    var transitionDriver: TransitionDriver?
    var supplier : Supplier?
    var arrCategory : [Categorie]?
    var scrollOffsetY : CGFloat = 0.0
    var ISPushAnimation : Bool = false
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ISPushAnimation {
            view.backgroundColor = UIColor.white
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width : ScreenSize.SCREEN_WIDTH, height : 64.0))
        }
        
        lblTitle.text = AppSettings.shared.isFoodApp ? L10n.selectCuisine.string : L10n.selectCategory.string
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            weak var weakSelf = self
            weakSelf?.viewNavBar.alpha = 1.0
        }
    }
}

// MARK: Helpers

extension CategorySelectionController {
    
    private func getScreen() -> UIImage? {
        let height = (headerHeight - tableView.contentOffset.y) < 0 ? 0 : (headerHeight - tableView.contentOffset.y)
        let backImageSize = CGSize(width: view.bounds.width, height: view.bounds.height - height)
        let backImageOrigin = CGPoint(x: 0, y: height + tableView.contentOffset.y)
        return view.takeSnapshot(CGRect(origin: backImageOrigin, size: backImageSize))
    }
}
// MARK: Public

extension CategorySelectionController {
    
    func popTransitionAnimation() {
        guard let transitionDriver = self.transitionDriver else {
            return
        }
        
        let backImage = getScreen()
        let offset = tableView.contentOffset.y > headerHeight ? headerHeight : tableView.contentOffset.y
        transitionDriver.popTransitionAnimationContantOffset(offset, backImage: backImage)
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension CategorySelectionController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -40 {
            // buttonAnimation
            popTransitionAnimation()
        }
        scrollOffsetY = scrollView.contentOffset.y
    }
}

//MARK: - Button Actions

extension CategorySelectionController {
    
    @IBAction func actionBack(sender: UIButton) {
        
        if ISPushAnimation {
            popVC()
            return
        }
        popTransitionAnimation()
    }
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
}

//Category>SubCategory>Suppliers>SupplierInfo>Ds-Pl

//MARK: - TableView Delegate and datasource
extension CategorySelectionController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CategorySelectionCell)! as UITableViewCell
        (cell as? CategorySelectionCell)?.category = arrCategory?[indexPath.row]
        cell.backgroundColor = indexPath.row % 2 == 0 ? SKAppType.type.color.withAlphaComponent(0.5) : UIColor.white
        (cell as? CategorySelectionCell)?.labelCategoryTitle.textColor = indexPath.row % 2 == 0 ? UIColor.white : Colors.MainColor.color()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if SKAppType.type.isFood {
            let category = arrCategory?[indexPath.row]
//            let VC = StoryboardScene.Main.instantiateSupplierInfoViewController()
            if /AppSettings.shared.appThemeData?.app_selected_template == "1" {
                let VC = RestaurantMenuVC.getVC(.splash)
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier?.id ,subCategoryId: nil ,productId: nil,branchId: supplier?.supplierBranchId,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                pushVC(VC)
            }else {
                let VC = RestaurantDetailVC.getVC(.splash)
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier?.id ,subCategoryId: nil ,productId: nil,branchId: supplier?.supplierBranchId,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                pushVC(VC)
            }
            
            
        } else {
            
            let category = arrCategory?[indexPath.row]
            let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
            
            let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
            VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier?.id ,subCategoryId: nil ,productId: nil,branchId: supplier?.supplierBranchId,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
            pushVC(VC)
            
        }
    }
}
