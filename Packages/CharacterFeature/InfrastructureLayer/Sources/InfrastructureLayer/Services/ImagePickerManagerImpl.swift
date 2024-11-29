//
//  UIImagePickerManager.swift
//  DataLayer
//
//  Created by Alfian on 27/11/24.
//

import UIKit
import DomainLayer

final class ImagePickerManagerImpl: NSObject, ImagePickerManager {
    private let picker = UIImagePickerController()
    private var completion: ((Result<UIImage, Error>) -> Void)?
    
    override init() {
        super.init()
        picker.delegate = self
    }
    
    func pickImage(from sourceType: UIImagePickerController.SourceType, completion: @escaping (Result<UIImage, Error>) -> Void) {
        self.completion = completion
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            self.completion?(.failure(PickerError.sourceUnavailable))
            return
        }
        picker.sourceType = sourceType
    }
    
    func pickImage(from sourceType: UIImagePickerController.SourceType) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            pickImage(from: sourceType) { result in
                switch result {
                case .success(let image):
                    continuation.resume(returning: image)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func dismissPicker() {
        picker.presentingViewController?.dismiss(animated: true)
    }
}

extension ImagePickerManagerImpl: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            self.completion?(.failure(PickerError.invalidImage))
            dismissPicker()
            return
        }
        
        self.completion?(.success(image))
        dismissPicker()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion?(.failure(PickerError.cancelled))
        dismissPicker()
    }
}

extension ImagePickerManagerImpl {
    enum PickerError: Error {
        case sourceUnavailable
        case invalidImage
        case cancelled
    }
}
