//
//  UIImagePickerManager.swift
//  DataLayer
//
//  Created by Alfian on 27/11/24.
//

import UIKit
import DomainLayer

@MainActor
final class UIImagePickerManager: NSObject, ImagePickerManager {
    private let picker = UIImagePickerController()
    private var continuation: CheckedContinuation<UIImage, Error>?
    
    override init() {
        super.init()
        picker.delegate = self
    }
    
    func pickImage(from sourceType: UIImagePickerController.SourceType) async throws -> UIImage {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            throw PickerError.sourceUnavailable
        }
        picker.sourceType = sourceType
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
        }
    }
    
    private func dismissPicker() {
        picker.presentingViewController?.dismiss(animated: true)
    }
}

extension UIImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            continuation?.resume(throwing: PickerError.invalidImage)
            continuation = nil
            dismissPicker()
            return
        }
        
        continuation?.resume(returning: image)
        continuation = nil
        dismissPicker()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        continuation?.resume(throwing: PickerError.cancelled)
        continuation = nil
        dismissPicker()
    }
}

extension UIImagePickerManager {
    enum PickerError: Error {
        case sourceUnavailable
        case invalidImage
        case cancelled
    }
}
