//
//  ViewController.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/10.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //システムメンテナンスかどうか
        API.Location.isMeintenance().subscribe(onNext: { isMeintenance in
            print (isMeintenance)
        }, onError: nil)
        .addDisposableTo(disposeBag)

        
        var reqParam = Mapper<RouteSearchParameters>().map(JSONString: "{}")
        reqParam?.origin = 1 //函館バスセンター
        reqParam?.destination = 2 //松風町

        //直通路線があるかどうか
        API.Route.isExist(searchParams:reqParam!).subscribe(onNext: { isExistRoute in
            print (isExistRoute)
        }, onError: nil)
            .addDisposableTo(disposeBag)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

