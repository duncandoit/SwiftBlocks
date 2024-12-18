//
//  ContainerTable.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 2/28/22.
//  Copyright © 2022 Zachary Duncan. All rights reserved.
//

import UIKit

class ContainerTable: Container, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].blocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].blocks[indexPath.row].cell(in: tableView)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let block = sections[indexPath.section].blocks[indexPath.row]
        
        if let selectableBlock = block as? Selectable {
            selectableBlock.selectionAction?()
        }
        
        if let containerBlock = block as? ContainerBlock {
            if containerBlock.container == nil {
                print("ContainerBlock \"\(containerBlock.label ?? "Unlabeled")\" has no set Container")
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
        }
        
//        if let vc = block.viewController as? ContainerController {
//            if let containerBlock = block as? ContainerBlock, let container = containerBlock.container {
//                vc.modalPresentationStyle = container.modalPresentationStyle
//                vc.swipeToDismiss = container.swipeToDismiss
//            }
//            
//            if let nav = navigationController {
//                nav.pushViewController(vc, animated: true)
//            } else {
//                present(vc, animated: true, completion: nil)
//            }
//        } else {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

