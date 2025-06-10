//
//  TableViewIdentifiable.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 08.06.2025.
//

import UIKit

protocol TableViewIdentifiable {
    static var identifier: String { get }
}

extension TableViewIdentifiable {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: TableViewIdentifiable {}

extension UICollectionViewCell: TableViewIdentifiable {}

extension UICollectionView {
    func register<T: AnyObject & TableViewIdentifiable>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: TableViewIdentifiable>(for indexPath: IndexPath) -> T where T: AnyObject {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}

extension UITableView {
    func register<T: AnyObject & TableViewIdentifiable>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: TableViewIdentifiable>(for indexPath: IndexPath) -> T where T: AnyObject {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}
