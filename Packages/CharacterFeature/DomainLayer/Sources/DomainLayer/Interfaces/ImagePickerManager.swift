//
//  ImagePicker.swift
//  DomainLayer
//
//  Created by Alfian on 27/11/24.
//

import UIKit

@MainActor
public protocol ImagePickerManager {
    func pickImage(from sourceType: UIImagePickerController.SourceType, completion: @escaping (Result<UIImage, Error>) -> Void)
}
