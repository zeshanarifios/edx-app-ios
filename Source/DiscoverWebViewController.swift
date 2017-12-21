//
//  DiscoverWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 19/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class DiscoverWebViewController: UIViewController, DiscoverWebViewHelperDelegate {

    var bottomBar: UIView?
    var webViewHelper: DiscoverWebViewHelper?
    
    init(with bottomBar: UIView?) {
        self.bottomBar = bottomBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if OEXSession.shared()?.currentUser != nil {
            webViewHelper?.bottomBar?.removeFromSuperview()
        }
    }
    
    // MARK: - DiscoverWebViewHelperDelegate Implementation -
    var webViewNativeSearchEnabled: Bool {
        return false
    }
    var webViewParentController: UIViewController {
        return self
    }
    func webViewHelper(helper: DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool {
        return true
    }
    
    

}
