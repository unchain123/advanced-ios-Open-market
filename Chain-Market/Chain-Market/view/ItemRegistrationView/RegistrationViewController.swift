//
//  RegistrationViewController.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/10.
//

import PhotosUI

final class RegistrationViewController: UIViewController {
    private var images: [UIImage] = []
    private let viewModel = RegistrationViewModel()

    private let imagePicker : PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }()

    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        button.backgroundColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let itemNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "상품명"
        field.layer.cornerRadius = 2
        field.layer.borderWidth = 1
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let itemPriceField: UITextField = {
        let field = UITextField()
        field.placeholder = "상품가격"
        field.layer.cornerRadius = 2
        field.layer.borderWidth = 1
        field.keyboardType = .decimalPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let itemBargainPriceField: UITextField = {
        let field = UITextField()
        field.placeholder = "할인금액"
        field.layer.cornerRadius = 2
        field.layer.borderWidth = 1
        field.keyboardType = .decimalPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let itemStockField: UITextField = {
        let field = UITextField()
        field.placeholder = "재고수량"
        field.layer.cornerRadius = 2
        field.layer.borderWidth = 1
        field.keyboardType = .decimalPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let currencyControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KRW", "USD"])
        control.selectedSegmentIndex = 0
        control.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 3
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let detailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let imageScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(postItem), for: .touchUpInside)
        return button
    }()

    private lazy var goBackButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(popButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: goBackButton)
        title = "상품등록"
        imagePicker.delegate = self
        viewModel.delegate = self

        setUI()
        setConstraints()
    }

    private func setUI() {
        view.addSubview(imageScrollView)
        view.addSubview(textStackView)

        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(addImageButton)

        priceStackView.addArrangedSubview(itemPriceField)
        priceStackView.addArrangedSubview(currencyControl)

        textStackView.addArrangedSubview(itemNameField)
        textStackView.addArrangedSubview(priceStackView)
        textStackView.addArrangedSubview(itemBargainPriceField)
        textStackView.addArrangedSubview(itemStockField)
        textStackView.addArrangedSubview(detailTextView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),

            textStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 10),
            textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            textStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5),

            addImageButton.widthAnchor.constraint(equalTo: textStackView.widthAnchor, multiplier: 0.3),
            addImageButton.heightAnchor.constraint(equalTo: addImageButton.widthAnchor)
        ])
    }

    @objc private func popButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func addImage() {
        present(imagePicker, animated: true)
    }

    @objc private func postItem() {
        viewModel.action(.didTapRegistrationButton)
        print("dd")
    }
}

extension RegistrationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for selectedImage in results {
            let imageView = UIImageView()
            let itemProvider = selectedImage.itemProvider
            itemProvider.canLoadObject(ofClass: UIImage.self)
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (picture, error) in
                guard let self = self,
                      let addedImage = picture as? UIImage else { return }
                self.images.append(addedImage)
                DispatchQueue.main.async {
                    imageView.image = picture as? UIImage
                    self.imageStackView.insertArrangedSubview(imageView, at: 0)
                }
            }
        }
    }
}

extension RegistrationViewController: RegistrationDelegate {
    func choiceCurrency() -> Currency? {
        return Currency.init(rawValue: currencyControl.selectedSegmentIndex)
    }

    func getParams() -> [String: Any] {
        let params = ["name" : itemNameField.text,
                      "description": detailTextView.text,
                      "currency": choiceCurrency()?.name,
                      "price": itemPriceField.text,
                      "discounted_price": itemBargainPriceField.text,
                      "stock": itemStockField.text
                    ]
        return params as [String: Any]
    }

    func getImages() -> [UIImage] {
        return images
    }
}
