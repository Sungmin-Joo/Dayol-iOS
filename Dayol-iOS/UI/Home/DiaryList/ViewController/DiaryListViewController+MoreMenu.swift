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

    func showDiaryMoreMenu(diaryID: String) {
        // TODO: - 다이어리 잠금 설정에 따른 분기 추가
        //        let lockMenu: MoreMenu = diary.isLock ? .unlock : .lock
        let lockMenu: MoreMenu = .unlock
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = action(diaryID, menuType: .edit)
        let lock = action(diaryID, menuType: lockMenu)
        let delete = action(diaryID, menuType: .delete)
        let cancel = action(diaryID, menuType: .cancel)

        alert.addAction(edit)
        alert.addAction(lock)
        alert.addAction(delete)
        alert.addAction(cancel)

        if isPadDevice, let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alert, animated: true)

    }

    private func action(_ diaryID: String, menuType: MoreMenu) -> UIAlertAction {
        switch menuType {
        case .edit, .lock, .cancel:
            return actionWithoutAelrt(diaryID, menuType: menuType)
        case .unlock, .delete:
            return actionWithAlert(diaryID, menuType: menuType)
        }
    }

    private func actionWithoutAelrt(_ diaryID: String, menuType: MoreMenu) ->  UIAlertAction {
        if menuType == .cancel {
            return UIAlertAction(title: MoreMenu.cancel.actionTitle, style: .cancel)
        }

        let action = UIAlertAction(title: menuType.actionTitle,
                                   style: .default) { [weak self] _ in
            if menuType == .edit {
                self?.editDiary(diaryID)
                return
            }

            if menuType == .lock {
                self?.lockDiary(diaryID)
            }

        }
        return action
    }

    private func actionWithAlert(_ diaryID: String, menuType: MoreMenu) ->  UIAlertAction {
        let alertInfo = menuType.alertInfo
        let style: UIAlertAction.Style = menuType == .delete ? .destructive : .default
        let action = UIAlertAction(title: menuType.actionTitle,
                                   style: style) { [weak self] _ in
            let alert = DayolAlertController(title: alertInfo.title, message: alertInfo.message)
            let delete = DayolAlertAction(title: alertInfo.default, style: .default) {

                if menuType == .delete {
                    self?.deleteDiary(diaryID)
                    return
                }

                if menuType == .unlock {
                    self?.unlockDiary(diaryID)
                }

            }
            let cancel = DayolAlertAction(title: alertInfo.cancel, style: .cancel)
            alert.addAction(cancel)
            alert.addAction(delete)
            self?.present(alert, animated: true)
        }
        return action
    }

    private func deleteDiary(_ diaryID: String) {
        // TODO: - 다이어리 삭제 로직 연동
    }

    private func editDiary(_ diaryID: String) {
        guard let diary = DYTestData.shared.diaryList.first(where: { $0.id == diaryID }) else { return }
        let diaryEditViewController = DiaryEditViewController()
        debugPrint(diary)
        diaryEditViewController.viewModel.setDiaryInfo(model: diary)
        let nav = DYNavigationController(rootViewController: diaryEditViewController)
        nav.modalPresentationStyle = .fullScreen
        navigationController?.topViewController?.present(nav, animated: true, completion: nil)
    }

    private func lockDiary(_ diaryID: String) {
        // TODO: - 다이어리 락 로직 연동
    }

    private func unlockDiary(_ diaryID: String) {
        // TODO: - 다이어리 언락 로직 연동
    }

    private func lockSettingTitle(_ diaryID: String) -> String {
        // TODO: - 현재 다이어리의 잠금 설정 여부에 따라 다른 타이틀 부여
        //        let model = DB.shared.diary(diaryID)
        //        if model.isLock {
        //            return MoreMenu.unlock.localized
        //        } else {
        //            return MoreMenu.lock.localized
        //        }
        return MoreMenu.lock.actionTitle
    }

}
