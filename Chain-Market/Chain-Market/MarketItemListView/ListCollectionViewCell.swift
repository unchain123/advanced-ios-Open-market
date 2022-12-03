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
        contentView.addSubview(itemThumbnailImageView)
        contentView.addSubview(totalStackView)
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
        image.layer.cornerRadius = 10
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

    let itemNameStockStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .bottom
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .top
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let totalStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
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
        totalStackView.addArrangedSubview(itemNameStockStackView)
        totalStackView.addArrangedSubview(priceStackView)

        itemNameStockStackView.addArrangedSubview(itemNameLabel)
        itemNameStockStackView.addArrangedSubview(itemStockLabel)

        priceStackView.addArrangedSubview(bargainPriceLabel)
        priceStackView.addArrangedSubview(itemPriceLabel)
    }

    private func setListConstraints() {
        NSLayoutConstraint.activate([
            // MARK: itemThumbnailImageView
            itemThumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itemThumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            itemThumbnailImageView.widthAnchor.constraint(equalTo: itemThumbnailImageView.heightAnchor),
            itemThumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            // MARK: totalStackView
            totalStackView.leadingAnchor.constraint(equalTo: itemThumbnailImageView.trailingAnchor, constant: 20),
            totalStackView.topAnchor.constraint(equalTo: itemThumbnailImageView.topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: itemThumbnailImageView.bottomAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
}
