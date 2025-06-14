//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  PromotionalOfferViewModel.swift
//
//
//  Created by Cesar de la Vega on 17/6/24.
//

import Foundation
import SwiftUI

import RevenueCat

#if os(iOS)

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@MainActor
final class PromotionalOfferViewModel: ObservableObject {

    @Published
    private(set) var promotionalOfferData: PromotionalOfferData?

    @Published
    private(set) var error: Error?

    private var purchasesProvider: CustomerCenterPurchasesType
    private let loadPromotionalOfferUseCase: LoadPromotionalOfferUseCase
    private let actionWrapper: CustomerCenterActionWrapper

    /// Callback to be called when the promotional offer is  purchased
    internal var onPromotionalOfferPurchaseFlowComplete: ((PromotionalOfferViewAction) -> Void)?

    init(
        promotionalOfferData: PromotionalOfferData?,
        purchasesProvider: CustomerCenterPurchasesType,
        actionWrapper: CustomerCenterActionWrapper,
        onPromotionalOfferPurchaseFlowComplete: ((PromotionalOfferViewAction) -> Void)? = nil
    ) {
        self.promotionalOfferData = promotionalOfferData
        self.purchasesProvider = purchasesProvider
        self.actionWrapper = actionWrapper
        self.loadPromotionalOfferUseCase = LoadPromotionalOfferUseCase(purchasesProvider: purchasesProvider)
        self.onPromotionalOfferPurchaseFlowComplete = onPromotionalOfferPurchaseFlowComplete
    }

    func purchasePromo() async {
        guard let promotionalOffer = self.promotionalOfferData?.promotionalOffer,
              let product = self.promotionalOfferData?.product else {
            Logger.warning(Strings.promo_offer_not_loaded)
            return
        }

        do {
            let result = try await self.purchasesProvider.purchase(
                product: product,
                promotionalOffer: promotionalOffer
            )

            Logger.debug("Purchased promotional offer: \(result)")
            self.actionWrapper.handleAction(.promotionalOfferSuccess)
            self.onPromotionalOfferPurchaseFlowComplete?(.successfullyRedeemedPromotionalOffer(result))
        } catch {
            // swiftlint:disable:next todo
            // TODO: Log error message
            self.error = error
            self.onPromotionalOfferPurchaseFlowComplete?(.promotionalCodeRedemptionFailed(error))
        }
    }
}

#endif
