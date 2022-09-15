## 0.0.2

* Add 3  new lints: 
 - `dont_import_ui_files_in_data` and `dont_import_data_files_in_ui` to indicate that the UI layer and DATA layer cannot interact with eachother. All logic needs to go through the domain layer.
 - `only_use_l10n_in_ui_lint` to indicate that L10n strings (translations) can only be used in the UI layer

