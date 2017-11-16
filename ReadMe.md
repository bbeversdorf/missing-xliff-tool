# Missing Xliff Tools
The purpose of this program is to visualize localizations. It takes Xliff files and CSV files and lists out translations.

## Features
* Handle multiple Xliff and CSV files at the same time
* Hide storyboard labels marked as prototype in the note field
* Hide accessibility labels
* Hide previously translated fields to see what needs to be translated
* Find potential inconsistencies between the Xliff and CSV files
* Populate target values that have the same ID or source
* Update strings files for a project
* Copy rows to transport to a spreadsheet
* Allows to fill in blank target values _useful when updating strings file_

## Coming Soon
* Allow any projects to be updated
* Export to CSV
* Export to Xliff
* Store local changes
* Update storyboard files with prototype
* Tool tips

## Known Issues
* Updating strings file is **Hard coded for Makani right now**
* Updates to targets will disappear when toggling filters
* Export to Xliff Does Nothing Important
* Update Strings can be clicked multiple times appending the same translation
* Xliff files are required
* CSV files must have the same name as the Xliff file to be compared

## How To Use
### File Import
* Select Xliff files (exported from Xcode project)
* Select CSV files _required only for comparison_
* Select the project's directory _required only to update strings files_
* Click Begin
