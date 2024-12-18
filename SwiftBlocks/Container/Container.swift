//
//  Container.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

enum State {
    case view
    case edit
    case locked
}

open class Container: NSObject, Observer, UITableViewDataSource {
    var sections: [ContainerSection] = []
    private var observers: [Observer?] = []
    private var currentState: State = .view
    var title: String?
    var primaryColor: UIColor = .white
    var secondaryColor: UIColor = .white
    var primaryTextColor: UIColor = .black
    var secondaryTextColor: UIColor = .gray
    
    /// When this Container is presented as a viewController, this
    /// will determine whether it can be dismissed with a swipe gesture
    var swipeToDismiss: Bool = false
    
    /// When this Container is presented as a viewController, this
    /// will determine its presentation style
    var modalPresentationStyle: UIModalPresentationStyle = .automatic

    init(in state: State = .view) {
        super.init()
        self.state = state
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].blocks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].blocks[indexPath.row].cell(in: tableView)
    }
    
    var state: State {
        get {
            return currentState
        }
        set(newState) {
            currentState = newState
            for s in 0 ..< sections.count {
                for b in 0 ..< sections[s].blocks.count {
                    sections[s].blocks[b].state = newState
                }
            }
        }
    }

    /// This will return the name of the first invalid Block in the Container.
    /// If there are no invalid Blocks it returns nil.
    var invalidBlock: String? {
        for section in sections {
            for block in section.blocks {
                if block.required && !block.isValid {
                    return block.label
                }
            }
        }

        return nil
    }
    
    /// This returns the name of the first Block in this Container that has been modified.
    /// If no Block has been modified it returns nil.
    var modifiedBlock: String? {
        for section in sections {
            for block in section.blocks {
                if block.modified {
                    return block.label
                }
            }
        }

        return nil
    }

    open func update() {
        for observer in observers where observer != nil {
            observer!.update()
        }
    }

    /// MARK: - Observers

    /// Adds observer to container
    /// - Parameter observer: Observer object to add
    open func addObserver(_ observer: Observer) {
        // Deliberately weakify reference to disable retain cycles
        weak var weakObserver = observer
        if !(observers.contains { $0 === observer }) {
            observers.append(weakObserver)
        }
    }

    /// Removes observer from Container
    /// - Parameter observer: Observer object to remove
    open func removeObserver(_ observer: Observer) {
        observers.removeAll { $0 === observer }
    }
}

struct ContainerSection {
    /// Displays the title of this group of Blocks
    ///
    /// If toolTip is nil the header should appear similar to a
    /// system standard table header, but with a > symbol. Otherwise it
    /// should have a ⓘ symbol that displays a modal popup with the toolTip
    var header: String?

    /// A helpful piece of text explaining the purpose of this section
    var toolTip: String?

    /// The number of indentations from the left margin at which this
    /// list of Blocks should appear
    var indentationLevel: Int = 0

    /// Some Containers will contain Blocks independent of a Category.
    var blocks: [Block]

    init(header: String? = nil, blocks: [Block]) {
        self.header = header
        self.blocks = blocks
    }
}

//TODO: Pass the object being observed as a param of update(...) to be inspected
@objc
public protocol Observer {
    /// This should be called whenever an object under observation is modified. The object
    /// observing should execute any actions needed to respond to the observed changes.
    func update()
    //func update(indexPath: IndexPath?)
    //func update(request: Int, info: Dictionary<String, Any>?)
}
