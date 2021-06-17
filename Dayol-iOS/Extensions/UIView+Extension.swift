//
//  UIView+Extension.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/28.
//

import UIKit

extension UIView {

    func showToast(
        text: String,
        bottomMargin: CGFloat,
        configure: DYToastConfigure = DYToastConfigure.deafault
    ) {
        let toast = DYToast(configure: configure,
                            text: text,
                            numberOfLines: 2)
        toast.alpha = 0

        addSubview(toast)

        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                          constant: -bottomMargin)
        ])

        // show toast animation
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                toast.alpha = 1.0
            }, completion: { _ in
                // hide toast animation
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: configure.toastDuration,
                    options: .curveEaseInOut,
                    animations: {
                        toast.alpha = 0
                    }, completion: { _ in
                        toast.removeFromSuperview()
                    }
                )
            }
        )
    }

    func addSubViewPinEdge(_ view: UIView) {
        if view.translatesAutoresizingMaskIntoConstraints == true {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func asImage() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        if let graphicsContext = UIGraphicsGetCurrentContext() {
            layer.render(in: graphicsContext)
            if let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
                UIGraphicsEndImageContext()
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage()
    }
}

// MARK: - addsubview, removeFromSuperview with undoManager

extension UIView {

    private enum UndoableViewTask {
        case add, remove
    }


    func addSubviewWithUndoManager(_ view: UIView) {
        registerAddsubViewTask(view, task: .add)
    }

    private func registerAddsubViewTask(_ view: UIView, task: UndoableViewTask) {
        let undoTask: UndoableViewTask = (task == .add) ? .remove : .add

        undoManager?.registerUndo(withTarget: self, handler: {
            $0.registerAddsubViewTask(view, task: undoTask)
        })

        if task == .add {
            addSubview(view)
        } else {
            view.removeFromSuperview()
        }
    }

    func removeFromSuperviewWithUndoManager() {
        guard
            let superview = superview,
            let undoManager = undoManager
        else { return }
        registerRemovFromSuperviewTask(superview: superview, task: .remove, undoManager: undoManager)
    }

    private func registerRemovFromSuperviewTask(superview: UIView, task: UndoableViewTask, undoManager: UndoManager) {
        let undoTask: UndoableViewTask = (task == .add) ? .remove : .add

        undoManager.registerUndo(withTarget: self, handler: {
            $0.registerRemovFromSuperviewTask(superview: superview, task: undoTask, undoManager: undoManager)
        })

        if task == .add {
            superview.addSubview(self)
        } else {
            removeFromSuperview()
        }
    }
}
