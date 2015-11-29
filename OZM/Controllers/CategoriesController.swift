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
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    private var selectedCat: Category?
    private var categories: [Category]?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    var imagesController: ImagesController!

    //MARK: - Initialization

    init() {
        super.init(nibName: "CategoriesController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            .then   { update($0) }
            .catch_ { _ in
                RegistrationResult.clean()
                let alert = UIAlertController(
                    title: "Что-то пошло не так",
                    message: "Стоит перезапустить приложение, скорее всего всё станет хорошо. Извините.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                navigation.presentViewController(alert, animated: true, completion: nil)
            }
    }

    //MARK: - View Struff

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerNib(
            UINib(nibName: "CategoryCell", bundle: nil),
            forCellWithReuseIdentifier: "category"
        )
        searchField.attributedPlaceholder = NSAttributedString(
            string: "UMAD",
            attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        )
        reloadData()
    }

    //MARK: - Collection view stuff

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let width = (UIScreen.mainScreen().bounds.width / 2.0) - 25
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(
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

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let category = categories?[indexPath.row] {
            imagesController = ImagesController()
            imagesController.category = category
            navigation.pushViewController(imagesController, animated: true)
        }
    }
}

