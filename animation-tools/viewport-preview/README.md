# Batch Camera Viewport Preview

## Description

Creates viewport preview as .jpg sequences for 3dsmax animated cameras.

## Compatibility

Tested with **3dsmax 2020**.

Supported camera types:

- Physical
- Free
- CoronaCam
- VRayPhysicalCamera

## Installation

- Click on **Scripting -> Run** Script in the top toolbar menu.
- Locate where the script was saved, select it and press Open.
- Go to **Customize -> Customize User Interface** in the top toolbar menu.
- Click on Toolbars tab.
- From the Categories dropdown menu select Ciprian's Scripts.
- Drag the Batch_Camera_Viewport_Preview to an existing toolbar or a newly created one.

## Usage

- Click on the script shortcut.
- A window popup will prompt for selecting the output folder.
- The script will begin creating previews for all cameras in the scene or only for the selected ones.
- Press Escape key to interrupt the script at any time. It may require pressing it multiple times.

## Notes

- Each preview sequence will be saved in individual folders named using the camera name.
- During the viewport grab some of the scene settings are changed to ensure the quality of the preview.
  - Object classes that get hidden:
    - shapes
    - lights
    - cameras
    - helpers
    - spacewarps
    - particles
    - bones
  - Viewport display is switched to Default Shading
  - Area to render is switched to View to avoid the region, cropt or blowup viewport rect obstructing the view.
- Please ensure the file is saved before running the script to avoid any data loss.

## To Do

- Better progress interruption. The current method may require pressing the ESC key multiple times before the script stops.

## Credits

Based on code originally posted by:

    - Colin Serren (http://www.scriptspot.com/3ds-max/scripts/batch-camera-previews)
    - HalfVector (https://forums.cgsociety.org/t/remove-escape-sequence-from-file-path-string/973444)
    - Lone Robot (http://lonerobot.net/?p=959)

## Disclaimer

This script comes without warranty of any kind. Use it at your own risk.
