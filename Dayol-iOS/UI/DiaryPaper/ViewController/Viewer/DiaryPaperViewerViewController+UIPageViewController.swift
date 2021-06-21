//
//  DiaryPaperViewerViewController+UIPageViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/10.
//

import UIKit

extension DiaryPaperViewerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.panGestureRecognizer.state {
        case .possible:
            presentAddModalIfNeeded()
        case .changed:
            let distance = scrollView.contentOffset.x - scrollView.frame.size.width
            setProgressIfNeeded(distance: distance)
        default:
            return
        }
    }

    private func presentAddModalIfNeeded() {
        if currentViewController?.readyToAdd == true {
            let alert = DayolAlertController(title: Text.addPaperTitle, message: Text.addPaperDesc)
            alert.addAction(.init(title: Text.addPaperCancel, style: .cancel))
            alert.addAction(.init(title: Text.addPaperConfirm, style: .default, handler: { [weak self] in
                self?.presentPaperModal(toolType: .add)
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    private func setProgressIfNeeded(distance: CGFloat) {
        if isLastViewContrller {
            currentViewController?.setProgress(distance)
        }
    }
}

extension DiaryPaperViewerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? DiaryPaperViewController {
                currentIndex = currentViewController.index
                setupLastViewContoller()
                toolBar.setFavorite(currentViewController.viewModel.isFavorite)
            }
        }
    }
}

extension DiaryPaperViewerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let paperViewController = viewController as? DiaryPaperViewController, let paperViewControllers = self.paperViewControllers else {
            return nil
        }
        let prevIndex = paperViewController.index - 1

        return paperViewControllers[safe: prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let paperViewController = viewController as? DiaryPaperViewController, let paperViewControllers = self.paperViewControllers else {
            return nil
        }
        let nextIndex = paperViewController.index + 1

        return paperViewControllers[safe: nextIndex]
    }
}
