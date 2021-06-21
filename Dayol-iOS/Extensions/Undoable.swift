//
//  Undoable.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/20.
//

import UIKit

private enum UndoableViewTask {
    case add, remove
}

protocol Undoable: UIView {}

// MARK: - addsubview, removeFromSuperview with undoManager

extension Undoable {

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
