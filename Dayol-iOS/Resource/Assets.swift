//
//  Assets.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/09.
//

import UIKit

// TODO: - 애셋 뎁스가 깊어져서, 한번 정리하는 것도 좋을 것 같습니다.
enum Assets {
    enum Image {
        enum Home {
            static let topIcon = UIImage(named: "home_top_icon")
            static let emptyDiaryIcon = UIImage(named: "home_empty_diary")
            static let emptyFavoriteIcon = UIImage(named: "home_empty_favorite")
            static let emptyArrow = UIImage(named: "home_empty_arrow")
            static let plusButton = UIImage(named: "home_tabbar_plusbutton")
            static let diaryListActionButton = UIImage(named: "home_diaryList_dropdown")

            enum TabBarDiary {
                static let normal = UIImage(named: "home_tabbar_diary_normal")
                static let selected = UIImage(named: "home_tabbar_diary_selected")
            }

            enum TabBarFavorite {
                static let normal = UIImage(named: "home_tabbar_favorite_normal")
                static let selected = UIImage(named: "home_tabbar_favorite_selected")
            }
        }

        enum Settings {
            static let chevron = UIImage(named: "settings_chevron")

            enum Backup {
                static let info = UIImage(named: "settings_backup_info")
                static let next = UIImage(named: "settings_backup_next")
            }
        }

        enum PaperAdd {
            enum Button {
                static let on = UIImage(named: "paper_add_btn_on")
                static let off = UIImage(named: "paper_add_btn_off")
            }
        }

        enum PaperList {
            static let chevronDown = UIImage(named: "paper_list_chevron_down")
            static let addCell = UIImage(named: "paper_list_cell_add_paper")
            static let starred = UIImage(named: "paper_list_cell_starred")
        }

        enum InfoView {
            static let info = UIImage(named: "InfoView_Icon_Info")
            static let close = UIImage(named: "InfoView_Icon_Close")
        }

        enum DiaryCover {
            static let lock = UIImage(named: "diaryCoverLock")
        }

        enum DYTextField {
            static let delete = UIImage(named: "textField_delete")

            enum CheckBox {
                static let on = UIImage(named: "textField_checkbox_on")
                static let off = UIImage(named: "textField_checkbox_off")
            }
        }

        enum ToolBar {
            static let info = UIImage(named: "toolBar_info")

            enum Lasso {
                static let info = UIImage(named: "toolBar_lasso_info")
            }

            enum Pencil {
                static let penOn = UIImage(named: "toolBar_pencil_pen_on")
                static let penOff = UIImage(named: "toolBar_pencil_pen_off")
                static let highlightOn = UIImage(named: "toolBar_pencil_highlight_on")
                static let highlightOff = UIImage(named: "toolBar_pencil_highlight_off")
                static let alphaInfoBackground = UIImage(named: "toolBar_pencil_alphaInfo_bg")
            }

            enum ColorPicker {
                static let plus = UIImage(named: "toolBar_color_plus")
            }

            enum TextStyle {
                static let plusButton = UIImage(named: "toolBar_textStyle_plus")
                static let minusButton = UIImage(named: "toolBar_textStyle_minus")
            }
        }

        enum Modal {
            static let down = UIImage(named: "btnModaldown")
        }
    }
}
