//
//  DiaryListViewController+MoreMenu.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/13.
//

import UIKit

// MARK: - Diary Cover More Menu

extension DiaryListViewController {

    private enum Text {
        enum Action: String {
            case edit = "diary_more_edit"
            case lock = "diary_more_lock"
            case unlock = "diary_more_unlock"
            case delete = "diary_more_delete"
            case cancel = "diary_more_cancel"
        }

        enum Alert {
            enum Delete: String {
                case title = "home_dairy_delete_title"
                case message = "home_dairy_delete_text"
                case `default` = "home_dairy_delete_btn"
                case cancel = "home_dairy_delete_cancel"
            }
            enum UnLock: String {
                case title = "password_unlock_title"
                case message = "password_unlock_text"
                case `default` = "password_unlock_btn"
                case cancel = "password_unlock_cancel"
            }
        }
    }

    private enum MoreMenu {
        case edit
        case lock
        case unlock
        case delete
        case cancel

        var actionTitle: String {
            switch self {
            case .edit: return Text.Action.edit.rawValue.localized
            case .lock: return Text.Action.lock.rawValue.localized
            case .unlock: return Text.Action.unlock.rawValue.localized
            case .delete: return Text.Action.delete.rawValue.localized
            case .cancel: return Text.Action.cancel.rawValue.localized
            }
        }

        struct AlertInfo {
            let title: String
            let message: String
            let `default`: String
            let cancel: String

            init(title: String = "",
                 message: String = "",
                 default: String = "",
                 cancel: String = "") {
                self.title = title
                self.message = message
                self.default = `default`
                self.cancel = cancel
            }
        }

        var alertInfo: AlertInfo {
            switch self {
            case .delete:
                return AlertInfo(title: Text.Alert.Delete.title.rawValue.localized,
                                 message: Text.Alert.Delete.message.rawValue.localized,
                                 default: Text.Alert.Delete.default.rawValue.localized,
                                 cancel: Text.Alert.Delete.cancel.rawValue.localized)
            case .unlock:
                return AlertInfo(title: Text.Alert.UnLock.title.rawValue.localized,
                                 message: Text.Alert.UnLock.message.rawValue.localized,
                                 default: Text.Alert.UnLock.default.rawValue.localized,
                                 cancel: Text.Alert.UnLock.cancel.rawValue.localized)
            default:
                return AlertInfo()
            }
        }
    }

    func showDiaryMoreMenu(row index: Int) {
        // TODO: - 더보기 메뉴로 비밀번호 설정/해제 시 다이어리 스크린샷 업데이트 필요
        guard let diary = viewModel.diaryList[safe: index] else { return }
        let lockMenu: MoreMenu = diary.isLock ? .unlock : .lock
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = action(at: index, menuType: .edit)
        let lock = action(at: index, menuType: lockMenu)
        let delete = action(at: index, menuType: .delete)
        let cancel = action(at: index, menuType: .cancel)

        alert.addAction(edit)
        alert.addAction(lock)
        alert.addAction(delete)
        alert.addAction(cancel)

        if isIPad, let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alert, animated: true)

    }

    private func action(at index: Int, menuType: MoreMenu) -> UIAlertAction {
        switch menuType {
        case .edit, .lock, .unlock, .cancel:
            return actionWithoutAelrt(at: index, menuType: menuType)
        case .delete:
            return actionWithAlert(at: index, menuType: menuType)
        }
    }

    private func actionWithoutAelrt(at index: Int, menuType: MoreMenu) ->  UIAlertAction {
        if menuType == .cancel {
            return UIAlertAction(title: MoreMenu.cancel.actionTitle, style: .cancel)
        }

        let action = UIAlertAction(title: menuType.actionTitle, style: .default) { [weak self] _ in
            switch menuType{
            case .edit:
                self?.presentEditDiaryVC(at: index)
            case .lock:
                self?.presentUnlockPasswordVC(at: index)
            case .unlock:
                self?.presentLockPasswordVC(at: index)
            default:
                break
            }
        }
        return action
    }

    private func actionWithAlert(at index: Int, menuType: MoreMenu) ->  UIAlertAction {
        let style: UIAlertAction.Style = menuType == .delete ? .destructive : .default
        let action = UIAlertAction(title: menuType.actionTitle, style: style) { [weak self] _ in
            guard let self = self else { return }
            let alert = self.createAlert(menuType: menuType) {
                if menuType == .delete {
                    self.deleteDiary(at: index)
                }
            }
            self.present(alert, animated: true)
        }
        return action
    }

    private func deleteDiary(at index: Int) {
        // TODO: - 다이어리 삭제 로직 연동
        viewModel.deleteDiary(at: index)
    }

    private func presentEditDiaryVC(at index: Int) {
        guard let diary = viewModel.diaryList[safe: index] else { return }
        let diaryEditViewController = DiaryEditViewController()
        diaryEditViewController.viewModel.setDiaryInfo(model: diary)
        let nav = DYNavigationController(rootViewController: diaryEditViewController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    private func presentUnlockPasswordVC(at index: Int) {
        guard
            let diary = viewModel.diaryList[safe: index],
            let color = PaletteColor.find(hex: diary.colorHex)
        else { return }

        let passwordViewController = PasswordViewController(inputType: .new, diaryColor: color)
        passwordViewController.didCreatePassword
            .subscribe(onNext: { [weak self] password in
                self?.viewModel.updateDiaryLock(at: index, isLock: true)
                passwordViewController.dismiss(animated: true)
                // TODO: - new password 처리
            }).disposed(by: disposeBag)
        present(passwordViewController, animated: true, completion: nil)
    }

    private func presentLockPasswordVC(at index: Int) {
        guard
            let diary = viewModel.diaryList[safe: index],
            let color = PaletteColor.find(hex: diary.colorHex)
        else { return }
        let passwordViewController = PasswordViewController(inputType: .check, diaryColor: color)
        passwordViewController.didPassedPassword
            .subscribe { [weak self] _ in
                self?.showUnlockAlert(at: index)
            }
            .disposed(by: disposeBag)
        present(passwordViewController, animated: true, completion: nil)
    }

    private func showUnlockAlert(at index: Int) {
        let alert = createAlert(menuType: .delete) { [weak self] in
            self?.viewModel.updateDiaryLock(at: index, isLock: false)
            // TODO: - PasswordViewController 수정되면 다이어리 잠금해제로직 적용
        }
        present(alert, animated: true)
    }

    private func createAlert(menuType: MoreMenu, completion: (() -> Void)?) -> DayolAlertController {
        let alertInfo = menuType.alertInfo
        let alert = DayolAlertController(title: alertInfo.title, message: alertInfo.message)
        let confirm = DayolAlertAction(title: alertInfo.default, style: .default) {
            completion?()
        }
        let cancel = DayolAlertAction(title: alertInfo.cancel, style: .cancel)
        alert.addAction(cancel)
        alert.addAction(confirm)
        return alert
    }

}
