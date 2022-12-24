//
//  CreatePostBody.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/13.
//

import UIKit

struct BodyMaker {

    static func createPostBody(params: [String: Any], images: [UIImage]) -> Data? {
        var postData = Data()
        let boundary = Multipart.boundaryValue
        guard let jsonData = createJson(params: params) else { return nil }

        postData.append(form: "--\(boundary)\r\n")
        postData.append(form: "Content-Disposition: form-data; name=\"params\"\r\n\r\n")
//        postData.append(form: "Content-Type: application/json\r\n\r\n")

        postData.append(jsonData)
        postData.append(form: "\r\n")

        for image in images {
            postData.append(form: "--\(boundary)\r\n")
            postData.append(form: "Content-Disposition: form-data; name=\"images\"; filename=" + "\"\(images.description.hashValue).png\"" + "\r\n")
            postData.append(form: "Content-Type: multipart/form-data" + "\r\n\r\n")

            guard let imageData = createPostImage(image: image) else { return nil }
            postData.append(imageData)
            postData.append(form: "\r\n")
        }
        postData.append(form: "--\(boundary)--")
//        print(String(data: postData, encoding: .utf8)!)
        return postData
    }

    static func createJson(params: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    }

    static func createPostImage(image: UIImage) -> Data? {
        let image = image

        guard let imageData = image.compress() else { return nil }
        return imageData
    }
}

extension Data {
    mutating func append(form: String) {
        guard let data = form.data(using: .utf8) else { return }
        self.append(data)
    }
}

extension UIImage {

    func compress() -> Data? {
        let quality: CGFloat = 300 / self.sizeAsKilobyte()
        let compressedData: Data? = self.jpegData(compressionQuality: quality)
        return compressedData
    }

    private func sizeAsKilobyte() -> Double {
        guard let dataSize = self.pngData()?.count else { return 0 }

        return Double(dataSize / 1024)
    }
}
