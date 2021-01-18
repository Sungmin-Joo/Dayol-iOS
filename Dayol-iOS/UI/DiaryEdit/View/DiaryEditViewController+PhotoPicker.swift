//
//  DiaryEditViewController+PhotoPicker.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/17.
//

import UIKit
import Photos
import PhotosUI

extension DiaryEditViewController {

    func showPicker() {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images])

            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)

        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                present(picker, animated: true)
            }
        }
    }
}

extension DiaryEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: self.view.center.x - 50,
                                     y: self.view.center.y - 50,
                                     width: 100,
                                     height: 100)
            imageView.image = image
            view.addSubview(imageView)
        }
        dismiss(animated: true, completion: nil)
    }

}


extension DiaryEditViewController: PHPickerViewControllerDelegate {

    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self, let image = image as? UIImage else { return }

                DispatchQueue.main.async {
                    let imageView = UIImageView()
                    imageView.image = image
                    imageView.frame = CGRect(x: self.view.center.x - 50,
                                             y: self.view.center.y - 50,
                                             width: 100,
                                             height: 100)
                    self.view.addSubview(imageView)
                }
            }
        }
    }

}
