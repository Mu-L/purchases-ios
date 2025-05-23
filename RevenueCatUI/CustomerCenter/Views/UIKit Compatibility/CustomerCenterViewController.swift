//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  CustomerCenterViewController.swift
//
//  Created by Will Taylor on 12/6/24.

import Combine
import RevenueCat
import SwiftUI

#if canImport(UIKit) && os(iOS)

/// Use the Customer Center in your app to help your customers manage common support tasks.
///
/// Customer Center is a self-service UI that can be added to your app to help
/// your customers manage their subscriptions on their own. With it, you can prevent
/// churn with pre-emptive promotional offers, capture actionable customer data with
/// exit feedback prompts, and lower support volumes for common inquiries — all
/// without any help from your support team.
///
/// The `CustomerCenterViewController` can be used to integrate the Customer Center directly in your app with UIKit.
///
/// For more information, see the [Customer Center docs](https://www.revenuecat.com/docs/tools/customer-center).
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public class CustomerCenterViewController: UIHostingController<CustomerCenterView> {

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initialization

    /// Create a view controller to handle common customer support tasks
    /// - Parameters:
    ///   - customerCenterActionHandler: An optional `CustomerCenterActionHandler` to handle actions
    ///   from the Customer Center.
    @available(*, deprecated, message: "Use the initializer with individual action handlers instead")
    public init(
        customerCenterActionHandler: CustomerCenterActionHandler?
    ) {
        // Initialize with a basic view first
        let view = CustomerCenterView(customerCenterActionHandler: customerCenterActionHandler)
        super.init(rootView: view)
    }

    /// Create a view controller to handle common customer support tasks with individual action handlers
    /// - Parameters:
    ///   - restoreStarted: Handler called when a restore operation starts.
    ///   - restoreCompleted: Handler called when a restore operation completes successfully.
    ///   - restoreFailed: Handler called when a restore operation fails.
    ///   - showingManageSubscriptions: Handler called when the user navigates to manage subscriptions.
    ///   - refundRequestStarted: Handler called when a refund request starts.
    ///   - refundRequestCompleted: Handler called when a refund request completes.
    ///   - feedbackSurveyCompleted: Handler called when a feedback survey is completed.
    public init(
        restoreStarted: CustomerCenterView.RestoreStartedHandler? = nil,
        restoreCompleted: CustomerCenterView.RestoreCompletedHandler? = nil,
        restoreFailed: CustomerCenterView.RestoreFailedHandler? = nil,
        showingManageSubscriptions: CustomerCenterView.ShowingManageSubscriptionsHandler? = nil,
        refundRequestStarted: CustomerCenterView.RefundRequestStartedHandler? = nil,
        refundRequestCompleted: CustomerCenterView.RefundRequestCompletedHandler? = nil,
        feedbackSurveyCompleted: CustomerCenterView.FeedbackSurveyCompletedHandler? = nil
    ) {
        let actionWrapper = CustomerCenterActionWrapper()

        // Set up Combine subscriptions to emit handler calls
        if let restoreStarted {
            actionWrapper.restoreStarted
                .sink { _ in restoreStarted() }
                .store(in: &cancellables)
        }

        if let restoreCompleted {
            actionWrapper.restoreCompleted
                .sink { restoreCompleted($0) }
                .store(in: &cancellables)
        }

        if let restoreFailed {
            actionWrapper.restoreFailed
                .sink { restoreFailed($0) }
                .store(in: &cancellables)
        }

        if let showingManageSubscriptions {
            actionWrapper.showingManageSubscriptions
                .sink { _ in showingManageSubscriptions() }
                .store(in: &cancellables)
        }

        if let refundRequestStarted {
            actionWrapper.refundRequestStarted
                .sink { refundRequestStarted($0) }
                .store(in: &cancellables)
        }

        if let refundRequestCompleted {
            actionWrapper.refundRequestCompleted
                .sink { refundRequestCompleted($0.0, $0.1) }
                .store(in: &cancellables)
        }

        if let feedbackSurveyCompleted {
            actionWrapper.feedbackSurveyCompleted
                .sink { feedbackSurveyCompleted($0) }
                .store(in: &cancellables)
        }

        let view = CustomerCenterView(
            actionWrapper: actionWrapper,
            mode: .default,
            navigationOptions: .default
        )

        super.init(rootView: view)
    }

    @available(*, unavailable, message: "Use init with handlers instead.")
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

#endif
