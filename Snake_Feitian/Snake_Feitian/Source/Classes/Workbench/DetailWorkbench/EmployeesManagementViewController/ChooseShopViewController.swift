//
//  ChooseShopViewController.swift
//  Snake_Feitian
//
//  Created by Snake on 2018/1/13.
//  Copyright © 2018年 Snake. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChooseShopViewController: RefreshTableViewController {

    var chooseShopCallback = {(branchId: Int, branchName: String) -> () in}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择店铺"
        
        self.registerCellNib(nibName: "ShopManagementTableViewCell")
        self.tableView.rowHeight = 80
        self.tableView.tableFooterView = UIView()
        //
        self.loadDataFromServer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // =================================
    // MARK:
    // =================================
    
    override func loadDataFromServer() {
        
        let apiName: String = URLManager.Feitian_branch()
        let parameters: Parameters = ["userId": SessionManager.share.userModel.id]
        //
        HttpManager.shareManager.getRequest(apiName, parameters: parameters).responseJSON { (response) in
            if let result = HttpManager.parseDataResponse(response: response) {
                //
                self.dataArray = result.arrayValue
                //
                self.reloadTableViewData()
            }
        }
    }
    
    // =================================
    // MARK:
    // =================================
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShopManagementTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ShopManagementTableViewCell", for: indexPath) as! ShopManagementTableViewCell
        
        let result = self.dataArray[indexPath.row]
        cell.updateCellUI(result: result)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let branchId = self.dataArray[indexPath.row]["id"].intValue
        let branchName = self.dataArray[indexPath.row]["name"].stringValue
        self.chooseShopCallback(branchId, branchName)
        self.back()
    }

}
