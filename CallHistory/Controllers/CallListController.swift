//
//  CallListController.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 04.05.2022.
//

import UIKit
import RxSwift
import RxCocoa

class CallListController: UIViewController {
    
    let bag = DisposeBag()
    private var collectionView: UICollectionView?
    private var spinner = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()

    private var viewModel: CallListViewModelProtocol?
    private var dataSource: [Request]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Missed calls"
        view.backgroundColor = .white
        viewModel = CallListViewModel()
        bind()
        
        //setup Collection View
        let layout = UICollectionViewFlowLayout()
        layout.sectionInsetReference = .fromSafeArea
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView ?? UICollectionView())
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(InfoCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        //set up activity indicator
        spinner.hidesWhenStopped = true
        collectionView?.addSubview(spinner)
        
        //setup refresh control
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView?.alwaysBounceVertical = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinner.center = CGPoint(x: self.view.center.x, y: 16 + (self.navigationController?.navigationBar.frame.height ?? 0))
        
        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat
        let leftSafeArea: CGFloat
        let rightSafeArea: CGFloat

        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
            leftSafeArea = view.safeAreaInsets.left
            rightSafeArea = view.safeAreaInsets.right
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
            leftSafeArea = topLayoutGuide.length
            rightSafeArea = bottomLayoutGuide.length
        }
        collectionView?.frame = CGRect(x: leftSafeArea, y: topSafeArea , width: view.bounds.width - leftSafeArea - rightSafeArea, height: view.bounds.height - topSafeArea - bottomSafeArea)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    private func bind() {
        viewModel?.calls.asDriver().drive(onNext: { [weak self] _ in
            self?.collectionView?.refreshControl?.endRefreshing()
            self?.spinner.stopAnimating()
            self?.collectionView?.reloadData()
        }).disposed(by: bag)
    }
    
    @objc private func refreshData(_ sender: Any) {
        DispatchQueue.main.async {
            self.collectionView?.refreshControl?.beginRefreshing()
        }
        updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            if !(self.collectionView?.refreshControl?.isRefreshing ?? false) {
                self.spinner.startAnimating()
            } else {
                self.collectionView?.refreshControl?.beginRefreshing()
            }
        }
        guard let viewModel = viewModel else {
            return
        }
        viewModel.fetchData()
    }
}
 
//MARK: - Collection view data source & delegate
extension CallListController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.callsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InfoCell
        let cellViewModel = viewModel?.cellViewModel(for: indexPath.row)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bottomSheetController = BusinessInfoController()
        bottomSheetController.viewModel = viewModel?.businessInfoViewModel(for: indexPath.row)
        bottomSheetController.modalPresentationStyle = .overCurrentContext
        self.present(bottomSheetController, animated: false)
    }
    
}

//MARK: - Collection view layout
extension CallListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width - 32, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
}
