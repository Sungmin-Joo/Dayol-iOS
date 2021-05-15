//
//  UIViewController+Extension.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/15.
//

import SwiftUI

// MARK: - Preview
extension UIViewController {
    private struct ViewControllerRepresentable: UIViewControllerRepresentable {
            private let viewController: UIViewController

            init(with viewController: UIViewController) {
                self.viewController = viewController
            }

            func makeUIViewController(context: Context) -> some UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
                // Not Use
            }
        }

        func toPreview() -> some View {
            ViewControllerRepresentable(with: self)
        }
}
