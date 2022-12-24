//
//  detailViewController.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/16.
//

import UIKit

final class DetailViewController: UIViewController {

    private let imagePageScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let imageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stockPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let itemInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let imageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .top
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "chain"))
        image.contentMode = .scaleToFill
        return image
    }()

    private let descriptionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let product: MarketItem?

    init(product: MarketItem) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.product = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUI()
        setConstraints()
        testSet()
        tabBarController?.tabBar.isHidden = true
    }

    private func setUI() {
        view.addSubview(totalStackView)
        totalStackView.addArrangedSubview(imagePageScrollView)
        totalStackView.addArrangedSubview(itemInformationStackView)
        totalStackView.addArrangedSubview(descriptionScrollView)

        descriptionScrollView.addSubview(descriptionLabel)

        imagePageScrollView.addSubview(imageStackView)

        itemInformationStackView.addArrangedSubview(itemNameLabel)
        itemInformationStackView.addArrangedSubview(stockPriceStackView)

        stockPriceStackView.addArrangedSubview(itemStockLabel)
        stockPriceStackView.addArrangedSubview(bargainPriceLabel)
        stockPriceStackView.addArrangedSubview(itemPriceLabel)

        imageStackView.addArrangedSubview(imageView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            totalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            totalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

            imagePageScrollView.topAnchor.constraint(equalTo: totalStackView.topAnchor),
            imagePageScrollView.trailingAnchor.constraint(equalTo: imageStackView.trailingAnchor),
            imagePageScrollView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor),
            imagePageScrollView.heightAnchor.constraint(equalTo: totalStackView.heightAnchor, multiplier:0.4),

            imageStackView.topAnchor.constraint(equalTo: imagePageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imagePageScrollView.leadingAnchor),
            imageStackView.heightAnchor.constraint(equalTo: totalStackView.heightAnchor, multiplier: 0.2),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionScrollView.topAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor, constant: -5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
    }

    private func testSet() {
        itemPriceLabel.text = "price"
        itemNameLabel.text = "name"
        itemStockLabel.text = "stock"
        bargainPriceLabel.text = "bargainprice"
        descriptionLabel.text = "description"
    }
}
