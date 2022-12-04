//
//  GridCollectionViewCell.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/04.
//

import UIKit

final class GirdCollectionViewCell: UICollectionViewCell {
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itemThumbnailImageView)
        contentView.addSubview(totalStackView)
        setGridView()
        setGridConstraints()

        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray3.cgColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Properties

    static let reuseIdentifier = "GridCollectionViewCell"

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
        label.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let itemStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
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

    private func setGridView() {
        priceStackView.addArrangedSubview(itemPriceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        
        totalStackView.addArrangedSubview(itemNameLabel)
        totalStackView.addArrangedSubview(priceStackView)
        totalStackView.addArrangedSubview(itemStockLabel)
    }

    private func setGridConstraints() {
        NSLayoutConstraint.activate([
            //MARK: itemThumbnailImageView
            itemThumbnailImageView.widthAnchor.constraint(equalTo: itemThumbnailImageView.heightAnchor),
            itemThumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            itemThumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -60),
            itemThumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            itemThumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            itemThumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            itemThumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            //MARK: totalStackView
            totalStackView.topAnchor.constraint(equalTo: itemThumbnailImageView.bottomAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: itemThumbnailImageView.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: itemThumbnailImageView.trailingAnchor)
        ])
    }

    override func prepareForReuse() {
        itemThumbnailImageView.image = nil
        itemPriceLabel.attributedText = nil
    }
}
