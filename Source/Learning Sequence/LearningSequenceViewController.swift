//
//  LearningSequenceViewController.swift
//  edX
//
//  Created by Zeeshan Arif on 6/21/18.
//  Copyright © 2018 edX. All rights reserved.
//

import UIKit

class LearningSequenceViewController: UIViewController {
    typealias Environment = OEXAnalyticsProvider & DataManagerProvider & OEXRouterProvider

    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 65, height: 50)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(LearningSequenceCollectionViewCell.self, forCellWithReuseIdentifier: LearningSequenceCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var contentPageViewController: CourseContentPageViewController?
    var list: [CourseOutlineQuerier.GroupItem] = [] {
        didSet {
            collectionView.reloadData()
            contentPageViewController?.view.isHidden = true
            contentPageViewController?.initialLoadController.state = .Loaded
            setupUnitViewController()
        }
    }
    
    var componentViews: [UIView] = []
    
    lazy var unitController = UnitViewController()
    func setupUnitViewController() {
        print("Test")
        guard let pager = contentPageViewController else { return }
        
        addChildViewController(unitController)
        unitController.didMove(toParentViewController: self)
        view.addSubview(unitController.view)
        unitController.view.snp.makeConstraints { make in
            make.edges.equalTo(contentPageViewController?.view ?? view)
        }
        
        var previousItem: ConstraintItem  = unitController.scrollView.snp.top
        for item in list {
            if let controller = pager.controllerForBlock(block: item.block) {
                unitController.addChildViewController(controller)
                controller.didMove(toParentViewController: unitController)
                let headerView = UIView()
                headerView.backgroundColor = OEXStyles.shared().navigationBarColor()
                let titleLabel = UILabel()
                titleLabel.textColor = OEXStyles.shared().primaryBaseColor()
                titleLabel.text = item.block.displayName
                headerView.addSubview(titleLabel)
                titleLabel.snp.makeConstraints { make in
                    make.leading.equalTo(headerView).offset(8)
                    make.top.equalTo(headerView).offset(8)
                    make.trailing.equalTo(headerView).inset(8)
                    make.bottom.equalTo(headerView).inset(8)
                }
                unitController.scrollView.addSubview(headerView)
                unitController.scrollView.addSubview(controller.view)

                componentViews.append(controller.view)
                
                headerView.snp.makeConstraints { make in
                    make.top.equalTo(previousItem).offset(0)
                    make.leading.equalTo(view)
                    make.trailing.equalTo(view)
                    make.height.equalTo(44)
                    previousItem = headerView.snp.bottom
                }
                
                controller.view.snp.makeConstraints { make in
                    make.top.equalTo(previousItem).offset(0)
                    make.leading.equalTo(view)
                    make.trailing.equalTo(view)
                    let height = UIScreen.main.bounds.size.height - 110
                    make.height.equalTo(height)
                    previousItem = controller.view.snp.bottom
                    if let last = list.last, last.block.blockID == item.block.blockID {
                        make.bottom.equalTo(unitController.scrollView).inset(8)
                    }
                }
                
                
            }
        }
        
        
        
    }
    
    public init(environment : Environment, courseID : CourseBlockID, rootID : CourseBlockID?, initialChildID: CourseBlockID? = nil, forMode mode: CourseOutlineMode) {
        contentPageViewController = CourseContentPageViewController(environment: environment, courseID: courseID, rootID: rootID, initialChildID: initialChildID, forMode: mode)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = OEXStyles.shared().neutralLight()
        addSubviews()
        NotificationCenter.default.oex_addObserver(observer: self, name: "WEBVIEW_HEIGHT_NOTIFICATION") { (notification, observer, removeable) in
            for controller in self.unitController.childViewControllers {
                if let htmlController = controller as? HTMLBlockViewController {
                    htmlController.view.snp.updateConstraints() { make in
                        print("BLOCK HEIGHT SET: \(htmlController.webController.height)")
                        make.height.equalTo(htmlController.webController.height)
                    }
                }
            }
            
            self.view.layoutIfNeeded()
            
        }
    }
    
    private func addSubviews() {
        guard let contentPageViewController = contentPageViewController else { return }
//        view.addSubview(collectionView)
        addChildViewController(contentPageViewController)
        view.addSubview(contentPageViewController.view)
        contentPageViewController.didMove(toParentViewController: self)
        
        setConstraints()
    }
    
    private func setConstraints() {
        guard let contentPageViewController = contentPageViewController else { return }
        
//        collectionView.snp.makeConstraints { make in
//            make.leading.equalTo(safeLeading)
//            make.trailing.equalTo(safeTrailing)
//            make.top.equalTo(safeTop).offset(1)
//            make.height.equalTo(50)
//        }
        
        contentPageViewController.view.snp.makeConstraints { make in
            make.leading.equalTo(safeLeading)
            make.trailing.equalTo(safeTrailing)
            make.top.equalTo(safeTop).offset(1)
            make.bottom.equalTo(safeBottom)
        }
    }
    
}

extension LearningSequenceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LearningSequenceCollectionViewCell.identifier, for: indexPath) as! LearningSequenceCollectionViewCell
        cell.item = list[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let block = list[indexPath.row]
        let controller = contentPageViewController?.controllerForBlock(block: block.block)
        contentPageViewController?.setPageControllers(with: [controller!], direction: .forward, animated: true)
        contentPageViewController?.setPageControllers(with: [controller!], direction: .forward, animated: true, competion: { [weak self] (finished) in
            self?.contentPageViewController?.view.isUserInteractionEnabled = true
        })
    }
}
