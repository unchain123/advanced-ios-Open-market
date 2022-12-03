//
//  CacheManager.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/03.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSURL, UIImage>()

    private init() {}
}
