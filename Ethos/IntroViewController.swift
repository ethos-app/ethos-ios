//
//  IntroViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/4/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class IntroViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var currentIndex = 0;
    var myViews : NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        UIPageControl.appearance().backgroundColor = UIColor.white
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.darkGray
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.hexStringToUIColor("247BA0")

        let zero = self.storyboard?.instantiateViewController(withIdentifier: "zero")

        let one = self.storyboard?.instantiateViewController(withIdentifier: "one")
        
        let two = self.storyboard?.instantiateViewController(withIdentifier: "two")
    
        let three = self.storyboard?.instantiateViewController(withIdentifier: "three")
        
        self.myViews = [zero, one, two, three]
        self.setViewControllers([zero!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    // MARK: Page View Delegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("Here")
        if currentIndex <= myViews!.count {
        currentIndex += 1
        }
        if currentIndex == 3 {
        self.dataSource = nil
        }
        print(currentIndex)
        return myViews?[currentIndex] as? UIViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentIndex > 0 {
            currentIndex -= 1
        }
        return myViews?[0] as? UIViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        //
        let idnex = pendingViewControllers.first 
        let ind = myViews?.indexOfObjectIdentical(to: idnex)
        print(ind)
    }

       func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return myViews!.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
