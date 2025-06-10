//
//  Changeable.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 08.06.2025.
//

protocol Changeable {
    init(copy: ChangeableWrapper<Self>)

    func changing(_ change: (inout ChangeableWrapper<Self>) -> Void) -> Self
}

extension Changeable {
    func changing(_ change: (inout ChangeableWrapper<Self>) -> Void) -> Self {
        var copy = ChangeableWrapper<Self>(self)
        change(&copy)
        return Self(copy: copy)
    }
}
