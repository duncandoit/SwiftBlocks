//
//  ContainerController.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

class ContainerController: UITableViewController, UIAdaptivePresentationControllerDelegate, Observer {
    // MARK: - Container Table Properties

    @objc var container: Container?
    var sections: [ContainerSection] { return container?.sections ?? [] }

    /// This will prevent modal windows from being dismissed with a swipe gesture.
    var swipeToDismiss: Bool = false

    /// Button appearing on the navigation bar to the left
    var leftBarButton: UIBarButtonItem?

    /// Button appearing on the navigation bar to the right
    var rightBarButton: UIBarButtonItem?
    
    /// This will be an option presented to the user for discarding modifications
    /// to the Blocks in the container
    var discardAction: UIAlertAction?

    // MARK: - INIT

    convenience init() {
        self.init(style: .grouped)
    }

    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) { isModalInPresentation = !swipeToDismiss }
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton

        // These are here to help dynamic resizing of cells for MessageBlocks
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600

        container?.addObserver(self)
        
        tableView.dataSource = container
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = container?.title
        tableView.backgroundColor = container?.primaryColor
        navigationController?.navigationBar.barTintColor = container?.secondaryColor
    }
    
    func dismissContainerTableController() {
        performIfUnmodified { [unowned self] in
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].blocks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].blocks[indexPath.row].cell(in: tableView)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let block = sections[indexPath.section].blocks[indexPath.row]
        
        if let selectableBlock = block as? Selectable {
            selectableBlock.selectionAction?()
        }
        
        if let containerBlock = block as? ContainerBlock {
            if containerBlock.container == nil {
                print("ContainerBlock \"\(containerBlock.label ?? "Unlabeled")\" has no Container")
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
        }
        
        if let vc = block.viewController as? ContainerController {
            if let containerBlock = block as? ContainerBlock, let container = containerBlock.container {
                vc.modalPresentationStyle = container.modalPresentationStyle
                vc.swipeToDismiss = container.swipeToDismiss
            }
            
            if let nav = navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                present(vc, animated: true, completion: nil)
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func update() {
        // These are here to help dynamic resizing of cells for MessageBlocks
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    // MARK: - Helper methods

    /// Checks whether all blocks have valid answers before executing the action
    /// - Parameter action: Callback if all blocks have valid answers
    ///
    /// - Example how to use the method:
    /// ```
    ///  @objc func save() {
    ///     performIfValid {
    ///         recordData()
    ///         playSuccessAnimation()
    ///     }
    ///  }
    /// ```
    func performIfValid(action: () -> Void) {
        if let invalidBlock = container?.invalidBlock {
            showAlert(message: invalidBlock + " is invalid")
            return
        }
        return action()
    }
    
    /// Checks whether any blocks have been modified before executing the action
    /// - Parameter action: Callback if all blocks are unmodified
    ///
    /// - Example how to use the method:
    /// ```
    ///  @objc func cancel() {
    ///     performIfUnmodified {
    ///         dismiss(animated:true, completion:nil)
    ///     }
    ///  }
    /// ```
    func performIfUnmodified(action: () -> Void) {
        if let modifiedBlock = container?.modifiedBlock {
            var actions: [UIAlertAction] = [UIAlertAction(title: "Return", style: .cancel, handler: nil)]
            if let action = discardAction { actions.append(action) }
            showAlert(title: "Warning", message: modifiedBlock + " has been modified", andActions: actions)
            return
        }
        return action()
    }
}
