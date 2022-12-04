//
//  ViewController.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/16.
//

import UIKit

private enum Section {
    case main
}

final class MarketListViewController: UIViewController {
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, MarketItem>

    let networkManager = NetworkManager()
    private var dataSource: DiffableDataSource?
    private var gridDataSource: DiffableDataSource?
    private var snapShot = NSDiffableDataSourceSnapshot<Section, MarketItem>()
    private let viewModel = MarketItemListViewModel()

    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()

    private lazy var gridCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()

    private lazy var addedButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var gridButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(changeLayout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addedButton), UIBarButtonItem(customView: gridButton)]
        setUI()
        setCollectionViewConstraint()
        viewModel.delegate = self
        viewModel.action(.viewDidLoad)
        listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        gridCollectionView.register(GirdCollectionViewCell.self, forCellWithReuseIdentifier: GirdCollectionViewCell.reuseIdentifier)
        dataSource = configureDataSource()
    }

    private func setUI() {
        view.addSubview(listCollectionView)
    }

    private func setCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            listCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }

    private func setGridCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            self.gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            self.gridCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.gridCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

// MARK: CollectionViewLayout

extension MarketListViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1.35))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.42))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

//MARK: DiffableDataSource

extension MarketListViewController {
    private func configureDataSource() -> DiffableDataSource? {

        let dataSource = DiffableDataSource(collectionView: listCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, product: MarketItem ) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as? ListCollectionViewCell else { return ListCollectionViewCell() }
            cell.setupUI(product)
            return cell
        }
        return dataSource
    }

    private func configureGridDataSource() -> DiffableDataSource? {

        let dataSource = DiffableDataSource(collectionView: gridCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, product: MarketItem ) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GirdCollectionViewCell.reuseIdentifier, for: indexPath) as? GirdCollectionViewCell else { return GirdCollectionViewCell() }
            cell.setupUI(product)
            return cell
        }
        return dataSource
    }

    @objc func changeLayout() {

        viewModel.action(.gridButton)
        listCollectionView.isHidden = true
        view.addSubview(gridCollectionView)
        setGridCollectionViewConstraint()

        gridDataSource = configureGridDataSource()
    }
}

//MARK: Delegate
extension MarketListViewController: CustomDelegate {
    func applyGridSnapshot() {
        gridDataSource?.apply(snapShot, animatingDifferences: false)
    }

    func applySnapshot(input: [MarketItem]) {
        snapShot.appendSections([.main])
        snapShot.appendItems(input, toSection: .main)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}
