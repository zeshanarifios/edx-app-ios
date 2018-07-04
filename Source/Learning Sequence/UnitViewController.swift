//
//  UnitViewController.swift
//  edX
//
//  Created by Zeeshan Arif on 7/3/18.
//  Copyright © 2018 edX. All rights reserved.
//

import UIKit

class UnitViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeEdges)
        }
        
    }
    
}
