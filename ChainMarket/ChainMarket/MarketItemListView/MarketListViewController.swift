//
//  ViewController.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/16.
//

import UIKit

private enum Section: Hashable {
    case main
}

class MarketListViewController: UIViewController {

    private var dataSource: UICollectionViewDiffableDataSource<Section, MarketItem>?

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
    }

    private func setUI() {
        view.addSubview(listCollectionView)
    }
}

// MARK: CollectionLayout

extension MarketListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension MarketListViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, MarketItem> { (cell, _, _) in
            cell.accessories = [.disclosureIndicator()]
        }

        dataSource = UICollectionViewDiffableDataSource<Section, MarketItem>(collectionView: listCollectionView) {(collectionView: UICollectionView, indexPath: IndexPath, item: MarketItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, MarketItem>()
        snapshot.appendSections([.main])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
