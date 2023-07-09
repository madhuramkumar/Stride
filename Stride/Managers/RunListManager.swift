//  RunListManager.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/2/23.

import Foundation
import SwiftUI

struct Workout: Identifiable {
    let id: UUID = .init()
    let name: String
    let distance: String
    let date: Date
}
struct WorkoutState {
    var workouts: [Workout]
    var sortType: SortType?
}
enum SortType {
    case date
    case distance
}
enum Action {
    case addWorkout(_ workout: Workout) // adds a workout
    case removeWorkout(at: IndexSet) // removes item at the provided index
    case sort(by: SortType) // sorts list by specified sorting type
}
func reducer(state: WorkoutState, action: Action) -> WorkoutState {
    var state = state
    switch action {
        case .addWorkout(let workout):
            state.workouts.append(workout)
        case .removeWorkout(let indexSet):
            state.workouts.remove(atOffsets: indexSet)
        case .sort(let type):
            switch type {
                case .distance:
                    state.workouts.sort { $0.distance > $1.distance }
                    state.sortType = .distance
                case .date:
                    state.workouts.sort { $0.date > $1.date }
                    state.sortType = .date
            }
    }
    return state
}
// whenever state value is changed, swift UI wil recieve notifications.
final class Store: ObservableObject {
    static let shared = Store()
    @Published private(set) var state: WorkoutState
    init(state: WorkoutState = .init(workouts: [Workout]())) {
        self.state = state
    }
    
    public func dispatch(action: Action) {
        state = reducer(state: state, action: action)
    }
}

