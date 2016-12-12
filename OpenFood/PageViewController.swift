//
//  PageViewController.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 12/5/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // The UIPageViewController
    var pageContainer: UIPageViewController!
    
    // Track the current index
    private var currentIndex: Int?
    private var pendingIndex: Int?
    
    private(set) lazy var pages: [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scan"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "search")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the page container
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        pageContainer.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        
        // Add it to the view
        view.addSubview(pageContainer.view)
        
        // Configure our custom pageControl
        view.bringSubview(toFront: pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard pages.count != nextIndex else {
            return nil
        }
        
        guard pages.count > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
                
                if index == 0 {
                    pageControl.currentPageIndicatorTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    pageControl.pageIndicatorTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
                }
                
                if index == 1 {
                    pageControl.currentPageIndicatorTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
                    pageControl.pageIndicatorTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
                }
            }
        }
    }
    
    func disable () -> Void {
        pageContainer.dataSource = nil
        pageControl.isHidden = true
    }
    
    func enable () -> Void {
        pageContainer.dataSource = self
        pageControl.isHidden = false
    }
}
