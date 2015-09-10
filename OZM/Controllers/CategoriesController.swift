//
//  CategoriesController.swift
//  OZM
//
//  Created by Semyon Novikov on 11/09/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class CategoriesController:
    UICollectionViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    private var categories: [Category]?

    //MARK: - Data

    /**
    Инициирует получение данных с сервера
    */
    private func reloadData() -> Void {
        let update: ([Category] -> Void) = { cs in
            self.categories = cs
            self.collectionView?.reloadData()
        }

        APIClient.getCategories()
            .then  { update($0) }
            .catch { println("I really should handle this: \($0.localizedDescription)") }
    }

    //MARK: - View Struff

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    //MARK: - Collection view stuff

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let width = (UIScreen.mainScreen().bounds.width / 2.0) - 25
        let height = width / 1.4
        return CGSize(width: width, height: height)
    }

    override func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView
            .dequeueReusableCellWithReuseIdentifier("category", forIndexPath: indexPath) as! CategoryCell

        if let category = categories?[indexPath.row] {
            cell.populateWith(category)
        }
        return cell
    }
}

