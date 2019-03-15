//
//  AppDelegate+rx.swift
//  RxCocoa
//
//  Created by SIARHEI LUKYANAU on 15.03.2019.
//  Copyright © 2019 Krunoslav Zaher. All rights reserved.
//

#if os(iOS)

import UIKit
import RxSwift

    extension Reactive where Base: AppDelegate {
        internal var didRegister: ControlEvent<()> {
            let source = self.methodInvoked(#selector(UIApplicationDelegate.application(_:didRegister:))).map { _ in return () }
            return ControlEvent(events: source)
        }
    }

#endif
