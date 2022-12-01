//
//  ListCollectionViewCell.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/22.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewListCell {

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setListView()
        setListConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Properties

    static let reuseIdentifier = "ListCollectionViewCell"

    let itemThumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let itemStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stockStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .trailing
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: Method

    func setupUI(_ product: MarketItem) {
        itemNameLabel.text = product.name
        itemStockLabel.text = String(product.stock)
        itemPriceLabel.text = String(product.price)
        bargainPriceLabel.text = String(product.bargainPrice!)
        itemThumbnailImageView.image = UIImage(systemName: "plus")
    }

    private func setListView() {
        contentView.addSubview(itemThumbnailImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemPriceLabel)
        contentView.addSubview(bargainPriceLabel)
        contentView.addSubview(stockStackView)

        stockStackView.addArrangedSubview(itemStockLabel)
    }

    private func setListConstraints() {
        NSLayoutConstraint.activate([
            // MARK: itemThumbnailImageView
            itemThumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemThumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            itemThumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemThumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            itemThumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            // MARK: itemNameLabel
            itemNameLabel.leadingAnchor.constraint(equalTo: itemThumbnailImageView.trailingAnchor),
            itemNameLabel.topAnchor.constraint(equalTo: itemThumbnailImageView.topAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: stockStackView.leadingAnchor),
            // MARK: itemPriceLabel
            itemPriceLabel.leadingAnchor.constraint(equalTo: bargainPriceLabel.trailingAnchor),
            itemPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor),
            itemPriceLabel.trailingAnchor.constraint(equalTo: stockStackView.leadingAnchor),
            itemPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // MARK: bargainPriceLabel
            bargainPriceLabel.leadingAnchor.constraint(equalTo: itemThumbnailImageView.trailingAnchor),
            bargainPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor),
            bargainPriceLabel.trailingAnchor.constraint(equalTo: stockStackView.leadingAnchor),
            bargainPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // MARK: itemStockLabel
            stockStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stockStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stockStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
