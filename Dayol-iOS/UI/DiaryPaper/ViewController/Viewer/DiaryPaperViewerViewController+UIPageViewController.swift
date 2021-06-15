//
//  DiaryPaperViewerViewController+UIPageViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/10.
//

import UIKit

extension DiaryPaperViewerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let draggingDistance = scrollView.contentOffset.x - scrollView.frame.size.width
        if isLastViewContrller {
            currentViewController?.setProgress(draggingDistance)
        }
    }
}

extension DiaryPaperViewerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? DiaryPaperViewController {
                currentIndex = currentViewController.index
                setupLastViewContoller()
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
