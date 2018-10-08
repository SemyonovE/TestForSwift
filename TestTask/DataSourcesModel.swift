//
//  DataSourcesModel.swift
//  TestTask
//
//  Created by Евгений Семёнов on 05/10/2018.
//  Copyright © 2018 Евгений Семёнов. All rights reserved.
//

import Foundation

import RxDataSources

struct sectionModel {
    var items: [Item]
}

extension sectionModel: SectionModelType {
    typealias Item = Quote
    
    init(original: sectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
