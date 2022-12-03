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
        self.accessories = [.disclosureIndicator()]
        self.contentView.layer.addBottomBorder()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Properties

    static let reuseIdentifier = "ListCollectionViewCell"

    private let itemThumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let itemStockLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let itemNameStockStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .bottom
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .top
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let totalStackView: UIStackView = {
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
        showSoldOut(product: product)
        showPrice(product: product)
        loadThumbnail(product) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let thumbnail):
                DispatchQueue.main.async {
                    self.itemThumbnailImageView.image = thumbnail
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func showPrice(product: MarketItem) {
        itemPriceLabel.text = "\(product.currency) \(product.price)"
        if product.discountedPrice == 0 {
            itemPriceLabel.textColor = .systemGray
            bargainPriceLabel.isHidden = true
        } else {
            bargainPriceLabel.isHidden = false
            itemPriceLabel.textColor = .systemRed
            bargainPriceLabel.text = "\(product.currency) \(product.bargainPrice)"
            itemPriceLabel.attributedText = itemPriceLabel.text?.strikeThrough()
            bargainPriceLabel.textColor = .systemGray
        }
    }

    private func showSoldOut(product: MarketItem) {
        if product.stock == 0 {
            itemStockLabel.text = "품절"
            itemStockLabel.textColor = .systemOrange
        } else {
            itemStockLabel.text = "잔여수량 : \(product.stock)"
            itemStockLabel.textColor = .systemGray
        }
    }

    private func loadThumbnail(_ path: MarketItem, completion: @escaping (Result<UIImage?, ImageCacheError>) -> Void) {
        guard let cacheKey = NSURL(string: path.thumbnail) else {
            completion(.failure(.emptyPath))
            return
        }

        if let cachedThumbnail = ImageCacheManager.shared.object(forKey: cacheKey) {
            completion(.success(cachedThumbnail))
            return
        }

        NetworkManager().fetchThumbnail(item: path.thumbnail) { result in
            switch result {
            case .success(let data):
                guard let thumbnail = UIImage(data: data) else {
                    completion(.failure(.emptyData))
                    return
                }
                completion(.success(thumbnail))
                ImageCacheManager.shared.setObject(thumbnail, forKey: cacheKey)
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }

    private func setListView() {
        totalStackView.addArrangedSubview(itemNameStockStackView)
        totalStackView.addArrangedSubview(priceStackView)

        itemNameStockStackView.addArrangedSubview(itemNameLabel)
        itemNameStockStackView.addArrangedSubview(itemStockLabel)

        priceStackView.addArrangedSubview(itemPriceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
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

    override func prepareForReuse() {
        itemThumbnailImageView.image = nil
        itemPriceLabel.attributedText = nil
    }
}

//MARK: Extension CALayer

extension CALayer {
    func addBottomBorder() {
        let border = CALayer()
        let borderFrameSize = CGRect(x: 8, y: frame.height - 5, width: frame.width - 8, height: 1)

        border.backgroundColor = UIColor.systemGray3.cgColor
        border.frame = borderFrameSize
        self.addSublayer(border)
    }
}
