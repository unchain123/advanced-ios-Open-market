//
//  RegistrationViewModel.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/13.
//

import Foundation
import UIKit.UIImage

final class RegistrationViewModel {

    weak var delegate: RegistrationDelegate?
    let networkManager: NetworkManager = NetworkManager()

    func action(_ action: Action) {
        guard let params = self.delegate?.getParams(),
              let images = self.delegate?.getImages() else { return }
        switch action {
        case .didTapRegistrationButton:
            postItem(params: params, images: images)
        default:
            return
        }
    }

    private func postItem(params: [String: Any], images: [UIImage]) {
        networkManager.itemPost(params: params, images: images) { result in
            switch result {
            case .success(_):
                print("상품등록이 정상적으로 완료되었습니다.")
            case .failure(let error):
                print("상품등록에 실패하였습니다." + "\(error.localizedDescription)")
            }
        }
    }
}

protocol RegistrationDelegate: AnyObject {
    func getParams() -> [String: Any]
    func getImages() -> [UIImage]
}
