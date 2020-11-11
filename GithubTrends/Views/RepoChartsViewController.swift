//
//  RepoChartsViewController.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import UIKit
import SafariServices
import Kingfisher

class RepoChartsViewController: UIViewController {
    
    // MARK: - Instance properties -
    private var collectionView: UICollectionView!
    private var segmentedColtrol: UISegmentedControl!
    private var viewModel: RepositoryViewModelProtocol!
    private let spinner = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupViewModel()
        
        setupSegmentControl()
        setupCollectionView()
        setupIndicator()
        
        viewModel.newReposLoaded.bind { (success) in
            self.collectionView.reloadData()
            self.hideLoadingIndicator()
        }
        viewModel.loadRepos()
    }
    
    func setupViewModel() {
        let itemsRepo = GithubRepository()
        viewModel = RepositoryViewModel(itemsRepo: itemsRepo)
    }
    
    // MARK: - UI setup
    func setupCollectionView() {
        //Flow layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.anchor(top: segmentedColtrol.bottomAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UINib(nibName: RepositoryCell.nameOfClass, bundle: nil),
                                forCellWithReuseIdentifier: RepositoryCell.nameOfClass)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func setupSegmentControl() {
        segmentedColtrol = UISegmentedControl(items: viewModel.getTimePeriods())
        segmentedColtrol.selectedSegmentIndex = viewModel.getLastChosenTimePeriod()
        view.addSubview(segmentedColtrol)
        segmentedColtrol.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                bottom: nil,
                                trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 48))
        segmentedColtrol.addTarget(self,
                                   action: #selector(segmentControllChanged(segment:)),
                                   for: .valueChanged)
    }
    
    @objc func segmentControllChanged(segment: UISegmentedControl) {
        showLoadingIndicator()
        viewModel.timePeriodDidChange(to: segment.selectedSegmentIndex)
    }
    
    func setupIndicator() {
        view.addSubview(spinner)
        spinner.anchorCenter(to: collectionView)
        spinner.isHidden = true
    }
    
    func showLoadingIndicator() {
        collectionView.isUserInteractionEnabled = false
        spinner.startAnimating()
        UIView.animate(withDuration: 0.1) {
            self.spinner.isHidden = false
            self.collectionView.alpha = 0.5
        }
    }
    
    func hideLoadingIndicator() {
        collectionView.isUserInteractionEnabled = true
        spinner.startAnimating()
        UIView.animate(withDuration: 0.1) {
            self.spinner.isHidden = true
            self.collectionView.alpha = 1.0
        }
    }
}

// MARK: - UICollectionViewDelegate -
extension RepoChartsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 16 * 2, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel.getRepo(for: indexPath.row),
            let urlString = item.url,
            let url = URL(string: urlString) {
            let controller = SFSafariViewController(url: url)
            controller.dismissButtonStyle = .close
            controller.configuration.barCollapsingEnabled = true
            controller.modalTransitionStyle = .coverVertical
            self.present(controller, animated: true, completion: nil)
            controller.delegate = self
        }
    }
    
}

// MARK: - UICollectionViewDataSource -
extension RepoChartsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getRepoCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCell.nameOfClass,
                                                      for: indexPath) as! RepositoryCell
        if let model = viewModel.getRepo(for: indexPath.row) {
            cell.configure(with: model)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - SFSafariViewControllerDelegate -
extension RepoChartsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

