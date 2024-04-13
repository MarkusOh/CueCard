//
//  AppBoundary.swift
//  Card
//
//  Created by Seungsub Oh on 4/13/24.
//

import SwiftUI

private struct AppBoundaryKey: EnvironmentKey {
    static var defaultValue = UIScreen.main.bounds
}

extension EnvironmentValues {
    var appBoundary: CGRect {
        get { self[AppBoundaryKey.self] }
        set { self[AppBoundaryKey.self] = newValue }
    }
}

extension View {
    func app(boundary: CGRect) -> some View {
        environment(\.appBoundary, boundary)
    }
}
