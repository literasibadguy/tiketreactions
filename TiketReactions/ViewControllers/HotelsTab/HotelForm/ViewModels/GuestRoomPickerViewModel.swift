//
//  GuestRoomPickerViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 18/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public protocol GuestRoomPickerViewModelInputs {
    func configureWith(guest: Int, room: Int)
    func doneButtonTapped()
    func pickerView(didSelectRow row: Int, component: Int)
    func viewDidLoad()
    func viewWillAppear()
}

public protocol GuestRoomPickerViewModelOutputs {
    var dataSource: Signal<[[String]], NoError> { get }
    var notifyDelegateToChoseGuestRoom: Signal<(Int, Int), NoError> { get }
    var selectRow: Signal<(Int, Int), NoError> { get }
}

public protocol GuestRoomPickerViewModelType {
    var inputs: GuestRoomPickerViewModelInputs { get }
    var outputs: GuestRoomPickerViewModelOutputs { get }
}

public final class GuestRoomPickerViewModel: GuestRoomPickerViewModelType, GuestRoomPickerViewModelInputs, GuestRoomPickerViewModelOutputs {
    
    public init() {
        
        let currentGuestRooms = Signal.combineLatest(self.configGuestRoomProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let defaultGuest = self.viewDidLoadProperty.signal.mapConst(2)
        let defaultRoom = self.viewDidLoadProperty.signal.mapConst(1)
        let guests = self.viewDidLoadProperty.signal.mapConst(Array(1...16))
        let rooms = self.viewDidLoadProperty.signal.mapConst(Array(1...8))
        
        let guestSuggest = Signal.combineLatest(currentGuestRooms.signal.map(second), guests).map { current, guests in

            guests.index(of: current) ?? 2
        }
        let roomSuggest = Signal.combineLatest(currentGuestRooms.signal.map(first), rooms).map {
            current, rooms in
            rooms.index(of: current) ?? 1
        }
        
        
        let totalSuggest = Signal.combineLatest(guestSuggest, roomSuggest)
        let totals = Signal.combineLatest(guests, rooms, currentGuestRooms)
        
        self.selectRow = totalSuggest.takeWhen(self.viewWillAppearProperty.signal)
        
        let mixed = Signal.combineLatest(guests, rooms).map(guestRoomTitles(guest:room:))
        
        let selectedGuest = Signal.combineLatest(guests, self.pickerRowSelectedProperty.signal.filter { $0.1 == 0 }).map { return $0.0[$0.1.0] }
        
        selectedGuest.observe(on: UIScheduler()).observeValues { guest in
            print("SELECTED GUEST: \(guest)")
        }
        
        let selectedRoom = Signal.combineLatest(rooms, self.pickerRowSelectedProperty.signal.filter { $0.1 == 1 }).map { return $0.0[$0.1.0] }
        
        selectedRoom.observe(on: UIScheduler()).observeValues { room in
            print("SELECTED ROOM: \(room)")
        }
        
        let selectedRow = Signal.merge(Signal.combineLatest(selectedGuest, selectedRoom), self.selectRow)
        
        self.dataSource = mixed
        self.notifyDelegateToChoseGuestRoom =  selectedRow.takeWhen(self.doneButtonTappedProperty.signal)
    }
    
    fileprivate let configGuestRoomProperty = MutableProperty<(Int, Int)?>(nil)
    public func configureWith(guest: Int, room: Int) {
        self.configGuestRoomProperty.value = (guest, room)
    }
    
    fileprivate let doneButtonTappedProperty = MutableProperty(())
    public func doneButtonTapped() {
        self.doneButtonTappedProperty.value = ()
    }
    
    fileprivate let pickerRowSelectedProperty = MutableProperty<(Int, Int)>((-1, -1))
    public func pickerView(didSelectRow row: Int, component: Int) {
        self.pickerRowSelectedProperty.value = (row, component)
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    public let dataSource: Signal<[[String]], NoError>
    public let notifyDelegateToChoseGuestRoom: Signal<(Int, Int), NoError>
    public let selectRow: Signal<(Int, Int), NoError>
    
    public var inputs: GuestRoomPickerViewModelInputs { return self }
    public var outputs: GuestRoomPickerViewModelOutputs { return self }
}

private func guestRoomTitles(guest: [Int], room: [Int]) -> [[String]] {
    return [guest.map { Localizations.GuestTitle($0) }, room.map { Localizations.RoomTitle($0) }]
}

