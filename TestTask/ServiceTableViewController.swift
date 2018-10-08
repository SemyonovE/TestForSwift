//
//  ServiceTableViewController.swift
//  TestTask
//
//  Created by Евгений Семёнов on 02/10/2018.
//  Copyright © 2018 Евгений Семёнов. All rights reserved.
//

import UIKit

import Moya
import RxSwift
import RxDataSources

class ServiceTableViewController: UITableViewController {
    
    var cellModels = BehaviorSubject<[Quote]>(value: [])
    
    let disposeBag = DisposeBag()
    
    let provider = MoyaProvider<MyService>()
    
    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Some setting for visualization tableView
        settingTableView(&tableView, refreshController)
        
        // Create dataSources for Table
        createDataSources()
        
        // Make trigger for load and update data of the tableView
        triggerForLoadAndUpdate()
    }
    
    func triggerForLoadAndUpdate() {
        var flag = true
        
        let didLoad = PublishSubject<()>()
        let refreshControlTriggered = refreshController.rx.controlEvent(.valueChanged)
        
        Observable.of(didLoad.asObservable(), refreshControlTriggered.asObservable()).merge()
            .flatMapLatest { [unowned self] _ in
                self.loadData()
                    .do(onError: { error in
                        print(error)
                    }, onSubscribe: {
                        if(flag) {
                            self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshController.frame.height), animated: true)
                            flag = false
                        }
                        self.refreshController.beginRefreshing()
                    }, onDispose: {
                        self.refreshController.endRefreshing()
                    })
            }.bind(to: cellModels)
            .disposed(by: disposeBag)
        
        didLoad.onNext(())
    }
    
    func createDataSources() {
        let dataSource = RxTableViewSectionedReloadDataSource<sectionModel>(configureCell: {
            let cell = $1.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
            
            cell.idLabel.text = "#\($3.id) (rating: \($3.rating))"
            cell.timeLabel.text = createDateFormatter(from: "MM/dd/yy HH:mm").string(from: $3.time)
            cell.mainLabel.text = $3.description
            
            return cell
        })
        
        cellModels
            .map{ [sectionModel(items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    /**
     - parameters Nothing: Absolutely nothing
     - returns: Observable data of Quotes
     - throws: Change format on the server | Not parsing to array of Quote
     - author: Semyonov Eugene
     */
    func loadData() -> Observable<[Quote]> {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(createDateFormatter(from: "yyyy-MM-dd HH:mm:ss"))
        
        return provider.rx.request(.quotes).asObservable().map([Quote].self, atKeyPath: "quotes", using: jsonDecoder)
    }
}
