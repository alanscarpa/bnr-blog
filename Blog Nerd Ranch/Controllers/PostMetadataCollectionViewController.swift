//
//  PostMetadataCollectionViewController.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = String(describing: PostMetadataCollectionViewCell.self)
private let headerReuseIdentifier = String(describing: HeaderCollectionReusableView.self)

class PostMetadataCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var server = Servers.mock
    var downloadTask : URLSessionTask?
    var dataSource = PostMetadataDataSource(ordering: DisplayOrdering(grouping:.none, sorting: .byPublishDate(recentFirst: true)))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell nib and header nib
        
        self.collectionView.register(UINib(nibName: String(describing: PostMetadataCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView.register(UINib(nibName: String(describing: HeaderCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)


        // Do any additional setup after loading the view.
        title = "Blog Posts"
        fetchPostMetadata()
    }
    
    // MARK: Actions
    @IBAction func groupByTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "Group the posts by...", preferredStyle: .actionSheet)
        
        let groupByAuthorAction = UIAlertAction(title: "Author", style: .default) { [weak self] _ in
            self?.group(by: .author)
            self?.collectionView.reloadData()
        }
        let groupByMonthAction = UIAlertAction(title: "Month", style: .default) { [weak self] _ in
            self?.group(by: .month)
            self?.collectionView.reloadData()
        }
        let noGroupAction = UIAlertAction(title: "No Grouping", style: .default) { [weak self] _ in
            self?.group(by: .none)
            self?.collectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(groupByAuthorAction)
        alertController.addAction(groupByMonthAction)
        alertController.addAction(noGroupAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func sortTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "Sort the posts by...", preferredStyle: .actionSheet)
        
        let sortByAuthorAscendingAction = UIAlertAction(title: "Author from A to Z", style: .default) { [weak self] _ in
            self?.sort(.alphabeticalByAuthor(ascending: true))
        }
        let sortByAuthorDescendingAction = UIAlertAction(title: "Author from Z to A", style: .default) { [weak self] _ in
            self?.sort(.alphabeticalByAuthor(ascending: false))
        }
        let sortByTitleAscendingAction = UIAlertAction(title: "Title from A to Z", style: .default) { [weak self] _ in
            self?.sort(.alphabeticalByTitle(ascending: true))
        }
        let sortByTitleDescendingAction = UIAlertAction(title: "Title from Z to A", style: .default) { [weak self] _ in
            self?.sort(.alphabeticalByTitle(ascending: false))
        }
        let sortByDateAscendingAction = UIAlertAction(title: "Chronologically", style: .default) { [weak self] _ in
            self?.sort(.byPublishDate(recentFirst: false))
        }
        let sortByDateDescendingAction = UIAlertAction(title: "Recent Posts First", style: .default) { [weak self] _ in
            self?.sort(.byPublishDate(recentFirst: true))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(sortByAuthorAscendingAction)
        alertController.addAction(sortByAuthorDescendingAction)
        alertController.addAction(sortByTitleAscendingAction)
        alertController.addAction(sortByTitleDescendingAction)
        alertController.addAction(sortByDateAscendingAction)
        alertController.addAction(sortByDateDescendingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func group(by grouping: Grouping) {
        dataSource.ordering.grouping = grouping
    }
    
    func sort(_ sorting: Sorting) {
        dataSource.ordering.sorting = sorting
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: headerReuseIdentifier,
                                                                            for: indexPath) as! HeaderCollectionReusableView
            headerView.headerLabel.text = dataSource.titleForSection(indexPath.section)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfPostsInSection(section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PostMetadataCollectionViewCell
        
        let postMetadata = dataSource.postMetadata(at: indexPath)
        cell.configure(forPostMetaData: postMetadata)
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if downloadTask?.progress.isCancellable ?? false {
            downloadTask?.cancel()
        }
        let postMetadata = dataSource.postMetadata(at: indexPath)
        let url = server.postUrlFor(id: postMetadata.postId)
        // todo: show spinner
        downloadTask = BlogPostRequest().load(url) { [weak self] result in
            switch result {
            case .success(let post):
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let postController = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
                postController.post = post
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(postController, animated: true)
                }
            case .failure(let error):
                self?.displayError(error)
            }
        }
    }

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Mark: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 160)
    }
    
    
    // MARK: - Data methods
    func fetchPostMetadata() {
        if downloadTask?.progress.isCancellable ?? false {
            downloadTask?.cancel()
        }
        downloadTask = AllPostMetaDataRequest().load(server.allPostMetadataUrl) { [weak self] result in
            switch result {
            case .success(let metadataList):
                self?.dataSource.postMetadataList = metadataList
            case .failure(let error):
                self?.displayError(error)
            }
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
    
    func displayError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
