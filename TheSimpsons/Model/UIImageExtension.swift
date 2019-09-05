//
//  UIImageExtension.swift
//  TheSimpsons
//
//  Created by Colin Smith on 9/5/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit


extension UIImage {
    /// Loads an image from the specified URL on a background thread
    static func load(from url: URL, completion: @escaping (UIImage?)-> Void) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                completion(nil)
            }
        }
    }
}
