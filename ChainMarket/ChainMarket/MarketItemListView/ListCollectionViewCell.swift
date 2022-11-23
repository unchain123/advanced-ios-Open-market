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
        setListConstraints()
        setListView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Properties

    private var viewModel: MarketItemListViewModel?
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
        stack.alignment = .top
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: Method

    private func setListView() {
        contentView.addSubview(itemThumbnailImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemPriceLabel)
        contentView.addSubview(bargainPriceLabel)
        contentView.addSubview(itemStockLabel)

        stockStackView.addArrangedSubview(itemStockLabel)
    }

    private func setListConstraints() {
        NSLayoutConstraint.activate([
            // MARK: itemThumbnailImageView
            itemThumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemThumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            itemThumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            // MARK: itemNameLabel
            itemNameLabel.leadingAnchor.constraint(equalTo: itemThumbnailImageView.trailingAnchor),
            itemNameLabel.topAnchor.constraint(equalTo: itemThumbnailImageView.topAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: itemStockLabel.leadingAnchor),
            // MARK: itemPriceLabel
            itemPriceLabel.leadingAnchor.constraint(equalTo: bargainPriceLabel.trailingAnchor),
            itemPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor),
            itemPriceLabel.trailingAnchor.constraint(equalTo: itemStockLabel.leadingAnchor),
            itemPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // MARK: bargainPriceLabel
            bargainPriceLabel.leadingAnchor.constraint(equalTo: itemThumbnailImageView.trailingAnchor),
            bargainPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor),
            bargainPriceLabel.trailingAnchor.constraint(equalTo: itemStockLabel.leadingAnchor),
            bargainPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // MARK: itemStockLabel
            stockStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stockStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stockStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func bind(with viewModel: MarketItemListViewModel) {
        self.viewModel = viewModel

        viewModel.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .update(let metaData):
                self.itemThumbnailImageView.image = metaData.thumbnail
                self.itemNameLabel.text = metaData.title
                self.itemStockLabel.text = metaData.stock
                self.itemPriceLabel.text = metaData.price
                self.bargainPriceLabel.isHidden = !metaData.hasDiscountedPrice
                self.bargainPriceLabel.attributedText = metaData.discountedPrice
                self.itemStockLabel.textColor = metaData.isOutOfStock ? .systemOrange : .systemGray
            case .error(_):
                self.itemThumbnailImageView.image = nil
            default:
                break
            }
        }
    }

    func fire() {
        viewModel?.fire()
    }
}
