//
//  DiscoverProgramsWebViewHelper.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 20/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class DiscoverProgramsWebViewHelper: DiscoverWebViewHelper {
    
    override init(config : OEXConfig?, delegate : DiscoverWebViewHelperDelegate?, dataSource: DiscoverWebViewHelperDataSource?, bottomBar: UIView?) {
        super.init(config: config, delegate: delegate, dataSource: dataSource, bottomBar: bottomBar)
        webView.accessibilityIdentifier = "find-programs-webview"
    }
    
}
