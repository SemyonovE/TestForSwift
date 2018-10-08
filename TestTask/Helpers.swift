//
//  Helpers.swift
//  TestTask
//
//  Created by Евгений Семёнов on 08/10/2018.
//  Copyright © 2018 Евгений Семёнов. All rights reserved.
//

import UIKit

/**
 - parameters from: String of the format
 - returns: DateFormatter with required format
 - author: Semyonov Eugene
 */
func createDateFormatter(from: String) -> DateFormatter {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = from
    return dateformatter
}

/**
 - parameters tv: tableView, rc: refreshController
 - author: Semyonov Eugene
 - bug: Nothing
 */
func settingTableView(_ tv: inout UITableView, _ rc: UIRefreshControl) {
    tv.delegate = nil
    tv.dataSource = nil
    tv.rowHeight = UITableView.automaticDimension
    tv.tableFooterView = UIView(frame: CGRect.zero)
    tv.refreshControl = rc
}
