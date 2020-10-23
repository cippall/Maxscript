# Batch Camera Viewport Preview

## Description

Creates vieport preview as .jpg sequences for 3dsmax animated cameras.

## Compatibility

Tested with 3dsmax 2020.

Supported camera types:

- Physical
- Free
- CoronaCam
- VRayPhysicalCamera

## TO DO

- Better progress interruption. The current method may requiere pressing the ESC key multiple times before the script stops.

## Instalation

- Click on Scripting>Run Script in the top toolbar menu.
- Locate and select the script and press Open.
- Click on Cutomize>Customize User Interface in the top toolbar menu.
- Click on Toolbars tab.
- From the Categories dropdown menu select Ciprian's Scripts.
- Drag the Batch_Camera_Viewport_Preview to an existing toolbar or a newly created one.

## Usage

- Click on the script shortcut.
- A window popup will prmpt for selecting the output folder.
- The script will begin creating preview for all cameras in the scene or only for the selected ones.
- Press Escape key to intrerupt the script at any time. It may requiere pressing it multiple times.

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

## Credits

Based on code originally posted by:

    - Colin Serren (http://www.scriptspot.com/3ds-max/scripts/batch-camera-previews)
    - HalfVector (https://forums.cgsociety.org/t/remove-escape-sequence-from-file-path-string/973444)
    - Lone Robot (http://lonerobot.net/?p=959)

## Disclaimer

This script comes without warranty of any kind. Use it at your own risk.
