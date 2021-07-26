//
//  ProfileViewModel.swift
//  AppChat
//
//  Created by Vu Minh Tam on 7/26/21.
//

import Foundation

enum ProfileViewModelModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelModelType
    let title: String
    let handler: (() -> Void)?
}
