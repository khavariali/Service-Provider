//
//  TutorialWelcomePVC.swift
//  Service Provider
//
//  Created by Allen on 17/01/2017.
//  Copyright © 2017 IT Emergency Malaysia. All rights reserved.
//

import UIKit

class TutorialWelcomePVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var arrayVC: [UIViewController] = {
       return [self.vcInstance(name: "TutVC1"), self.vcInstance(name: "TutVC2")]
    }()
    
    private func vcInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstVC = arrayVC.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if let tut = UserDefaults.standard.object(forKey: "tutorial") {
            print("Show welcome tutorial ? \(tut)")
            if String(describing: tut) == "false" {
                goToSignVC()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.lightGray
                view.frame = CGRect(x: 0, y: view.frame.minY - 50, width: view.frame.size.width, height: view.frame.size.height)
                
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = arrayVC.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return arrayVC.last
        }
        
        guard arrayVC.count > previousIndex else {
            return nil
        }
        return arrayVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = arrayVC.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < arrayVC.count else {
            return arrayVC.first
        }
        
        guard arrayVC.count > nextIndex else {
            return nil
        }
        return arrayVC[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrayVC.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = arrayVC.index(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }
    func goToSignVC() {
        self.navigationController?.pushViewController(signInVC, animated: false)
    }
}
