//
//  ViewController.swift
//  testapp3
//
//  Created by Sankalp Agarwal on 11/08/16.
//  Copyright © 2016 Sankalp Agarwal. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var taskListUrl = "https://frozen-plains-62045.herokuapp.com/api/tasks/+917259183906"
    var taskList:[AnyObject] = [["data": ["title": "Loading"]]]
    
    // This returns the model
    //    func taskList() ->[String]? {
    //        let defaults = NSUserDefaults.standardUserDefaults()
    //        let array = defaults.objectForKey("Key1") as? [String] ?? [String]()
    //        return array
    //    }
    
    override func viewWillAppear(animated: Bool) {
        HTTPGetJSONArray(taskListUrl) {
            (data: [AnyObject], error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                self.taskList = data
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.delegate = self
        
        // Navigation Bar
        navigationItem.title = "Tasks"
        tableView.registerClass(MyCell.self, forCellReuseIdentifier: "cellId")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: #selector(MyTableViewController.addTask))
    }
    
    // This reloads the data whenever a view is changed
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        tableView.reloadData()
    }
    
    
    func addTask(){
        let secondViewController:AddTaskViewController = AddTaskViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    // renders the tableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    
    // Fills data in the cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! MyCell
        let thisTask = taskList[indexPath.row]["data"]!!["title"] as! String
        myCell.nameLabel.text = thisTask
        myCell.myTableViewController = self
        return myCell
    }
    
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPathForCell(cell){
            let defaults = NSUserDefaults.standardUserDefaults()
            var array = defaults.objectForKey("Key1") as? [String] ?? [String]()
            array.removeAtIndex(deletionIndexPath.row)
            defaults.setObject(array, forKey: "Key1")
            tableView.deleteRowsAtIndexPaths([deletionIndexPath], withRowAnimation: .Automatic)
            self.tableView.reloadData()
        }
    }
    
}

class MyCell : UITableViewCell {
    
    var myTableViewController: MyTableViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample task"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Done", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews(){
        addSubview(nameLabel)
        
        addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(MyCell.handleAction), forControlEvents: .TouchUpInside)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": actionButton]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
    }
    
    func handleAction() {
        //        myTableViewController?.deleteCell(self)
    }
}