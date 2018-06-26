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
    }
    
    private func addSubviews() {
        guard let contentPageViewController = contentPageViewController else { return }
        view.addSubview(collectionView)
        addChildViewController(contentPageViewController)
        view.addSubview(contentPageViewController.view)
        contentPageViewController.didMove(toParentViewController: self)
        
        setConstraints()
    }
    
    private func setConstraints() {
        guard let contentPageViewController = contentPageViewController else { return }
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(safeLeading)
            make.trailing.equalTo(safeTrailing)
            make.top.equalTo(safeTop).offset(1)
            make.height.equalTo(50)
        }
        
        contentPageViewController.view.snp.makeConstraints { make in
            make.leading.equalTo(collectionView)
            make.trailing.equalTo(collectionView)
            make.top.equalTo(collectionView.snp.bottom)
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
