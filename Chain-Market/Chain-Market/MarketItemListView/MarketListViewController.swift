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

class MarketListViewController: UIViewController {
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, MarketItem>

    let networkManager = NetworkManager()
    private var dataSource: DiffableDataSource?
    private var snapShot = NSDiffableDataSourceSnapshot<Section, MarketItem>()
    private let viewModel = MarketItemListViewModel()

    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addedButton)
        setUI()

        viewModel.delegate = self
        viewModel.action(.viewDidLoad)
        listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        dataSource = configureDataSource()
    }

    private func setUI() {
        view.addSubview(listCollectionView)
    }
}

// MARK: CollectionLayout

extension MarketListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.35))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: .zero)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension MarketListViewController {
    private func configureDataSource() -> DiffableDataSource? {

        let dataSource = DiffableDataSource(collectionView: listCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, product: MarketItem ) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as? ListCollectionViewCell else { return ListCollectionViewCell() }
            cell.setupUI(product)
            return cell
        }
        return dataSource
    }
}

extension MarketListViewController: CustomDelegate {
    func delegate(input: [MarketItem]) {
        snapShot.appendSections([.main])
        snapShot.appendItems(input, toSection: .main)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}
