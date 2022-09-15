This package adds new custom lints to your project. These lints are agreed upon by the appnormal team and used to enforce agreements made in internal architecture meetings.

## Available lints

 - `dont_import_ui_files_in_data` <span style="color:red">*error*</span>
 
  Used to indicate that the UI layer and DATA layer cannot interact with eachother. All logic needs to go through the domain layer.

 - `dont_import_data_files_in_ui` <span style="color:red">*error*</span>
 
  Used to indicate that the UI layer and DATA layer cannot interact with eachother. All logic needs to go through the domain layer.

 - `only_use_l10n_in_ui_lint` <span style="color:orange">*warning*</span>

  Indicates that L10n strings (translations) can only be used in the UI layer


## Getting started

Follow these instructions to add apn_lints to a new or existing project

1. Add these 2 dependencies to your pubspec.yaml
```
  custom_lint: ^0.0.9
  apn_lints: ^0.0.1
```

2. Add the `custom_lint` plugin to your `analysis_options.yaml` (just below the line that says  `analyzer:`)
```
analyzer:
  plugins:         <-- add
    - custom_lint  <-- add
```

3. Restart analyser (or restart IDE) for the plugin to be loaded correctly
