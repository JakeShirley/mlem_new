//
//  TabBarSettingsView.swift
//  Mlem
//
//  Created by Sam Marfleet on 19/07/2023.
//

import SwiftUI

struct TabBarSettingsView: View {
    @AppStorage("showUsernameInNavigationBar") var showUsernameInNavigationBar: Bool = true
    @AppStorage("showTabNames") var showTabNames: Bool = true
    @AppStorage("showInboxUnreadBadge") var showInboxUnreadBadge: Bool = true
        
    var body: some View {
        Form {
            SwitchableSettingsItem(settingPictureSystemName: "tag",
                                   settingName: "Show Tab Labels",
                                   isTicked: $showTabNames)
            
            Section {
                SwitchableSettingsItem(settingPictureSystemName: "person.text.rectangle",
                                       settingName: "Show Username",
                                       isTicked: $showUsernameInNavigationBar)
            } footer: {
                Text("Displays your username as the label for the \"Profile\" tab.")
            }
            
            SwitchableSettingsItem(settingPictureSystemName: "envelope.badge",
                                   settingName: "Show Unread Count",
                                   isTicked: $showInboxUnreadBadge)
        }
        .fancyTabScrollCompatible()
    }
}
