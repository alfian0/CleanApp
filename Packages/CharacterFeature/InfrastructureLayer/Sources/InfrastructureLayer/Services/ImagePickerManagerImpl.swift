//
//  ImagePickerManagerImpl.swift
//  DataLayer
//
//  Created by Alfian on 27/11/24.
//

import DomainLayer
import UIKit

@MainActor
final class ImagePickerManagerImpl: NSObject {
  private let picker = UIImagePickerController()
  private var completion: ((Result<UIImage, Error>) -> Void)?

  override init() {
    super.init()
    picker.delegate = self
  }

  func pickImage(
    from sourceType: UIImagePickerController.SourceType,
    completion: @escaping (Result<UIImage, Error>) -> Void
  ) {
    self.completion = completion
    guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
      self.completion?(.failure(PickerError.sourceUnavailable))
      return
    }
    picker.sourceType = sourceType
  }

  private func dismissPicker() {
    picker.presentingViewController?.dismiss(animated: true)
  }
}

extension ImagePickerManagerImpl: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let image = info[.originalImage] as? UIImage else {
      completion?(.failure(PickerError.invalidImage))
      dismissPicker()
      return
    }

    completion?(.success(image))
    dismissPicker()
  }

  func imagePickerControllerDidCancel(_: UIImagePickerController) {
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
