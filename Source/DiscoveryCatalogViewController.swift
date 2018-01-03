//
//  DiscoveryCatalogViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 20/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class DiscoveryCatalogViewController: UIViewController {
    // Used to make Code more clear
    private enum segment: Int {
        case courses = 0
        case programs = 1
    }
    
    typealias Environment = NetworkManagerProvider & OEXRouterProvider & OEXSessionProvider & OEXConfigProvider & OEXAnalyticsProvider

    private var environment : Environment
    let bottomBarHeight: CGFloat = 50.0
    let segmentControlHeight: CGFloat = 40.0
    var bottomSpace: CGFloat{
        return bottomBar != nil ? bottomBarHeight + StandardVerticalMargin : StandardVerticalMargin
    }
    var segmentTitleTextStyle: OEXTextStyle {
        return OEXTextStyle(weight : .normal, size: .small, color: OEXStyles.shared().neutralDark())
    }
    var bottomBar: UIView?
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Strings.courses, Strings.programs])
        control.selectedSegmentIndex = segment.courses.rawValue
        control.tintColor = OEXStyles.shared().primaryBaseColor()
        control.setTitleTextAttributes([NSForegroundColorAttributeName: OEXStyles.shared().neutralWhite()], for: .selected)
        control.setTitleTextAttributes([NSForegroundColorAttributeName: OEXStyles.shared().neutralBlack()], for: .normal)
        return control
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var coursesController: UIViewController = {
        return self.environment.config.courseEnrollment.type == .webview ? CoursesWebViewController(with: self.bottomBar) : CourseCatalogViewController(environment: self.environment)
    }()
    
    lazy var programsController: UIViewController = {
       return ProgramsWebViewController(with: self.bottomBar)
    }()
    
    init(with environment: Environment, andBottomBar bottomBar: UIView?) {
        self.environment = environment
        self.bottomBar = bottomBar
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private func setupView() {
        addSubViews()
        setupConstraints()
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
        segmentedControl.oex_addAction({ [weak self]
            (control:AnyObject) -> Void in
            if let segmentedControl = control as? UISegmentedControl {
                switch segmentedControl.selectedSegmentIndex {
                case segment.courses.rawValue:
                    self?.coursesController.view.isHidden = false
                    self?.programsController.view.isHidden = true
                    break
                case segment.programs.rawValue:
                    self?.programsController.view.isHidden = false
                    self?.coursesController.view.isHidden = true
                    break
                default:
                    assert(true, "Invalid Segment ID, Remove this segment index OR handle it in the ThreadType enum")
                }
            }
            else {
                assert(true, "Invalid Segment ID, Remove this segment index OR handle it in the ThreadType enum")
            }
            }, for: UIControlEvents.valueChanged)
        
        navigationItem.title = Strings.discover
        
    }
    
    private func addSubViews() {
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        
        addChildViewController(coursesController)
        didMove(toParentViewController: self)
        coursesController.view.frame = containerView.frame
        containerView.addSubview(coursesController.view)
        
        addChildViewController(programsController)
        didMove(toParentViewController: self)
        programsController.view.frame = containerView.frame
        containerView.addSubview(programsController.view)
        programsController.view.isHidden = true
        if let bar = bottomBar {
            view.addSubview(bar)
        }
    }
    
    private func setupConstraints() {
        
        segmentedControl.snp_makeConstraints { (make) in
            make.height.equalTo(segmentControlHeight)
            make.leading.equalTo(view).offset(StandardHorizontalMargin)
            make.trailing.equalTo(view).inset(StandardHorizontalMargin)
            make.top.equalTo(view).offset(StandardVerticalMargin)
        }
        
        containerView.snp_makeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(segmentedControl.snp_bottom).offset(StandardVerticalMargin)
            make.bottom.equalTo(view).offset(bottomSpace)
        }
        
        if let bottomBar = bottomBar {
            bottomBar.snp_makeConstraints(closure: { (make) in
                make.height.equalTo(bottomBarHeight)
                make.leading.equalTo(view)
                make.trailing.equalTo(view)
                make.bottom.equalTo(view)
            })
        }
    }
}
