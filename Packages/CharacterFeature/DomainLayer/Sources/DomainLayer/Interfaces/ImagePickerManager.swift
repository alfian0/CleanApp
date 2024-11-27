//
//  ImagePicker.swift
//  DomainLayer
//
//  Created by Alfian on 27/11/24.
//

import UIKit

public protocol ImagePickerManager {
    func pickImage(from sourceType: UIImagePickerController.SourceType) async throws -> UIImage
}
