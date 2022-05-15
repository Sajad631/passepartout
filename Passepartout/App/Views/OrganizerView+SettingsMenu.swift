//
//  OrganizerView+SettingsMenu.swift
//  Passepartout
//
//  Created by Davide De Rosa on 4/18/22.
//  Copyright (c) 2022 Davide De Rosa. All rights reserved.
//
//  https://github.com/passepartoutvpn
//
//  This file is part of Passepartout.
//
//  Passepartout is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Passepartout is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Passepartout.  If not, see <http://www.gnu.org/licenses/>.
//

import SwiftUI
import PassepartoutCore

extension OrganizerView {
    struct SettingsMenu: View {
        @ObservedObject private var productManager: ProductManager
        
        @Binding var modalType: ModalType?

        @Binding var alertType: AlertType?
        
        private var isTestBuild: Bool {
            Constants.App.isBeta || Constants.InApp.appType == .beta
        }
        
        private let redditURL = Constants.URLs.subreddit
        
        private let shareMessage = L10n.Global.Messages.share

        private let appName = Unlocalized.appName

        init(modalType: Binding<ModalType?>, alertType: Binding<AlertType?>) {
            productManager = .shared
            _modalType = modalType
            _alertType = alertType
        }
        
        var body: some View {
            Menu {
                Menu(L10n.Menu.All.Support.title) {
                    supportMenu
                }
                Menu(L10n.Menu.All.Share.title) {
                    shareMenu
                }
                if isTestBuild {
                    Divider()
                    testSection
                }
                Divider()
                aboutButton
            } label: {
                themeInfoMenuImage.asSystemImage
            }
        }

        private var supportMenu: some View {
            Group {
                Button {
                    modalType = .donate
                } label: {
                    Label(L10n.Donate.title, systemImage: themeDonateImage)
                }.disabled(!productManager.canMakePayments())

                Button {
                    URL.openURL(redditURL)
                } label: {
                    Label(L10n.Menu.Contextual.Support.joinCommunity, systemImage: themeRedditImage)
                }
                Button(action: submitReview) {
                    Label(L10n.Menu.Contextual.Support.writeReview, systemImage: themeWriteReviewImage)
                }
            }
        }

        private var shareMenu: some View {
            Group {
                Button(L10n.Menu.Contextual.shareTwitter, action: shareOnTwitter)
                Button(L10n.Menu.Contextual.shareGeneric, action: shareWithFriend)
            }
        }
        
        private var aboutButton: some View {
            Button(L10n.Menu.All.About.title("")) {
                presentAbout()
            }
        }

        private func shareOnTwitter() {
            let url = Unlocalized.Social.twitterIntent(withMessage: shareMessage)
            URL.openURL(url)
        }

        private func shareWithFriend() {
            let shareMessage = "\(shareMessage) \(Constants.URLs.website)"
            modalType = .share([shareMessage])
        }

        private func submitReview() {
            let reviewURL = Reviewer.urlForReview(withAppId: Constants.App.appStoreId)
            URL.openURL(reviewURL)
        }
        
        private func presentAbout() {
            modalType = .about
        }
    }
}

extension OrganizerView.SettingsMenu {
    private var testSection: some View {
        Button("Export providers") {
            guard let urls = AppContext.shared.urlsForProviders else {
                return
            }
            modalType = .exportProviders(urls)
        }
    }
}
