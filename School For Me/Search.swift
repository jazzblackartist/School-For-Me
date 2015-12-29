//
//  Search.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 12/13/15.
//  Copyright © 2015 Jamone Kelly. All rights reserved.
//

import UIKit
import FontAwesomeKit
import DZNEmptyDataSet
import RealmSwift

class Search: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var filteredResults = [School]()
    let realm = try! Realm()
    var searchString: String = String()
    var schoolData: Results<School>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        schoolData = realm.objects(School)
        // Icons from FAK
        let listIcon = FAKFontAwesome.listUlIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let listButton = UIBarButtonItem(image: listIcon, style: .Plain, target: self, action: nil)
        
        //let closeIcon = FAKFontAwesome.closeIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        //let closeIcon2 = FAKFontAwesome.angleLeftIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let closeIcon3 = FAKFontAwesome.chevronLeftIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let filterIcon = FAKFontAwesome.filterIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let filterButton = UIBarButtonItem(image: filterIcon, style: .Plain, target: self, action: "presentFilterOptions:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeIcon3, style: .Plain, target: self, action: "dismissView:")
        self.navigationItem.rightBarButtonItems = [listButton, filterButton]
        
        self.searchBar.delegate = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.searchBar.backgroundColor = UIColor.flatSkyBlueColor()
        //self.searchBar.barTintColor = UIColor.flatSkyBlueColor()
    }
    
    func dismissView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
        
        return NSAttributedString(string: "No search results", attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "When you search for a school, your results will appear here."
        
        let paragraph = NSMutableParagraphStyle()
        
        paragraph.lineBreakMode = .ByWordWrapping
        paragraph.alignment = .Center
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14.0),
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let gradIcon: UIImage = FAKFontAwesome.graduationCapIconWithSize(85).imageWithSize(CGSize(width: 90, height: 90))
        return gradIcon
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! SearchCells
        
        cell.schoolName.text = filteredResults[indexPath.row].school_name
        cell.schoolDistrict.text = filteredResults[indexPath.row].district
        
        cell.schoolDistrict.sizeToFit()
        cell.schoolName.sizeToFit()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Call our resultview vc
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredResults.removeAll()
            self.tableView.reloadData()
            self.searchString = ""
            if searchBar.isFirstResponder() {
                searchBar.resignFirstResponder()
            }
            return
        }
        filteredResults.removeAll()
        self.searchString = searchText
        let predicate = NSPredicate(format: "school_name CONTAINS[c] %@", searchText)
        let results = schoolData!.filter(predicate)
        for result in results {
            filteredResults.append(result)
        }
        self.tableView.reloadData()
    }
    
    func presentFilterOptions(sender: UIBarButtonItem) {
        let viewFrame = (width: view.frame.width, height: view.frame.height)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = storyboard.instantiateViewControllerWithIdentifier("filterVC")
        filterVC.modalPresentationStyle = .Popover
        filterVC.preferredContentSize = CGSizeMake(viewFrame.width*0.9, viewFrame.height*0.8)
        
        let senderView = sender.valueForKey("view") as? UIView
        
        
        let popover = filterVC.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = filterVC.view
        popover?.barButtonItem = sender
        popover?.sourceRect = (senderView?.bounds)!
        
        presentViewController(filterVC, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
