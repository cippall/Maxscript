/*
*   Name                :   Batch Camera Viewport Preview
*   Author              :   Ciprian Pal
*   Date                :   22-10-2020
*   Version             :   1.0
*   Description         :   Create viewport preview for the selected camera or for all cameras in the scene. 
*                           Propmts for user input to select the output folder.
*                           For each camera in the scene the script will create a folder based on the camera name 
*                           and save the animation preview as a .jpg sequence.
*
*   Comments            :   Based on code originally posted by:
*                                   - Colin Serren  :   http://www.scriptspot.com/3ds-max/scripts/batch-camera-previews
*                                   - HalfVector    :   https://forums.cgsociety.org/t/remove-escape-sequence-from-file-path-string/973444
*                                   - Lone Robot    :   http://lonerobot.net/?p=959
*/

MacroScript Batch_Camera_Viewport_Preview
Category:"CiprianScripts"
Tooltip:"Batch Camera Viewport Preview"
ButtonText:"Camera Preview"
Icon:#("Cameras",2)
(

    local aHiddenCategories = #(hideByCategory.shapes, hideByCategory.lights, hideByCategory.cameras, hideByCategory.helpers, hideByCategory.spacewarps, hideByCategory.particles, hideByCategory.bones)
    local aHelper = #()
    local aAreaToRender = #(#view, #selected, #region, #crop, #blowUp)
    local aStoreAreaToRender = #()
    local aTimeRange = #()
    local sDefaultFolder = ""
    local iTotalFrames = 0


    if doesDirectoryExist "R:\\" then
    (
        sDefaultFolder = "R:\\"
    ) 


    fn isCameraSelected = 
    (
        local aCameras = for c in getcurrentSelection() where ((superClassOf c) == camera) collect c

        if aCameras.count == 0  then
        (
            return false
        )
        else
        (
            return true
        )
    )


    fn getAnimatedCameras = 
    (
        local aCameras = #()

        if (getcurrentSelection()).count == 0 then 
        (
            aCameras = for c in cameras where ((classOf c) != TargetObject) and ((classOf c) != Dummy) collect c
        )
        else if (getcurrentSelection()).count > 0 and isCameraSelected() then
        (
            aCameras = for c in getcurrentSelection() where ((superClassOf c) == camera) collect c
        )
        else
        (
            aCameras = for c in cameras where ((classOf c) != TargetObject) and ((classOf c) != Dummy) collect c
        )

        return aCameras
    )


    fn getKeyFrames obj = 
    (
        /*
        *    Source:        Batch Camera Preview
        *    Author:        Colin Serren
        *    Availability:  http://www.scriptspot.com/3ds-max/scripts/batch-camera-previews
        */

        local arrayOfKeys = #()
        local objs = #()
        local aAnimationRange = #()
        
        -- Add the obj to the objs array, and it's target if it has one
        append objs obj
        if obj.target != undefined then append objs obj.target
            
        -- Check all objs associated with the obj (targets, etc)
        for o in objs do (
            -- Position Controller Keys
            if isProperty o #position then (
                if o.position.controller.keys.count > 0 then (
                    append arrayOfKeys ((o.position.controller.keys[1].time as integer)/TicksPerFrame)
                    append arrayOfKeys ((o.position.controller.keys[o.position.controller.keys.count].time as integer)/TicksPerFrame)
                )
            )
            
            -- Rotation Controller Keys
            if isProperty o #rotation then (
                if o.rotation.controller.keys.count > 0 then (
                    append arrayOfKeys ((o.rotation.controller.keys[1].time as integer)/TicksPerFrame)
                    append arrayOfKeys ((o.rotation.controller.keys[o.rotation.controller.keys.count].time as integer)/TicksPerFrame)
                )
            )
            
            -- Scale Controller Keys
            if isProperty o #scale then (
                if o.scale.controller.keys.count > 0 then (
                    append arrayOfKeys ((o.scale.controller.keys[1].time as integer)/TicksPerFrame)
                    append arrayOfKeys ((o.scale.controller.keys[o.scale.controller.keys.count].time as integer)/TicksPerFrame)		
                )
            )
            
            if (classof o.position.controller) == Path_Constraint then (
                if o.position.controller.percent.controller.keys.count > 0 then (
                    append arrayOfKeys ((o.position.controller.percent.controller.keys[1].time as integer)/TicksPerFrame)
                    append arrayOfKeys ((o.position.controller.percent.controller.keys[o.position.controller.percent.controller.keys.count].time as integer)/TicksPerFrame)
                )
            )
        )	-- end for o in objs
        
        sort arrayOfKeys
        
        if arrayOfKeys.count >= 2 then (
            aAnimationRange = #(arrayOfKeys[1], arrayOfKeys[arrayOfKeys.count])
        ) else (
            aAnimationRange = #(0,1)
        )
        
        return aAnimationRange
    )


    fn getCameraAnimationRange oCamera = 
    (
        local aAnimationRange = getKeyFrames oCamera

        return aAnimationRange
    )


    fn getTotalFrames aCameras =
    (
        for oCamera in aCameras do 
        (
            aAnimationRange = getKeyFrames oCamera
            iTotal += aAnimationRange[2]
        )
    )

    fn setAnimationTimeline iStart iEnd = 
    (   
        local tStart = iStart as time
        local tEnd = iEnd as time
        
        animationRange = (interval tStart tEnd)
    )


    fn setViewportShadingType = 
    (
        viewport.SetRenderLevel #smoothhighlights
    )


    fn setViewportViewToCamera oCamera = 
    (
        viewport.setLayout #layout_1
        viewport.setCamera oCamera
    )


    fn setVieport oCamera = 
    (
        setViewportViewToCamera oCamera
        setViewportShadingType()
    )


    fn hideCategories = 
    (
        hideByCategory.shapes = true
        hideByCategory.lights = true
        hideByCategory.cameras = true
        hideByCategory.helpers = true
        hideByCategory.spacewarps = true
        hideByCategory.particles = true
        hideByCategory.bones = true
    )


    fn restoreHiddenCategories = 
    (
        hideByCategory.shapes = aHiddenCategories[1]
        hideByCategory.lights = aHiddenCategories[2]
        hideByCategory.cameras = aHiddenCategories[3]
        hideByCategory.helpers = aHiddenCategories[4]
        hideByCategory.spacewarps = aHiddenCategories[5]
        hideByCategory.particles = aHiddenCategories[6]
        hideByCategory.bones = aHiddenCategories[7]
    )


    fn getOutputDirectory =
    (
        local sFolder = getSavePath caption:"Select preview output folder:" initialDir: "R:\\"
        
        if sFolder == undefined then 
        (
            messageBox "Aborting script."
            return undefined
        )
        else
        (
            return sFolder
        )
    )


    fn filterStr str tokens replacement = 
    (
        /*
        *    Source:        Forum post <Remove escape sequence from file path string>
        *    Author:        HalfVector
        *    Availability:  https://forums.cgsociety.org/t/remove-escape-sequence-from-file-path-string/973444
        */

        local finalStr = ""
        local aSplits = filterString str tokens

        for i = 1 to aSplits.count - 1 do (
            finalStr += aSplits[i] + replacement
        )

        finalStr += aSplits[aSplits.count]

        return finalStr
    )


    function getValidString str = 
    (
        /*
        *    Source:        Batch Camera Preview Script
        *    Author:        Colin Serren
        *    Availability:  http://www.scriptspot.com/3ds-max/scripts/batch-camera-previews
        */

        local validChars = "abcdefghijklmnopqrstuvwxyz1234567890."
        local newString = ""
        
        newString = str
        
        for i = 1 to newString.count do (
            if not(matchPattern validChars pattern:("*"+newString[i]+"*") ignoreCase:true) or (newString[i] == "*") then (
                newString[i] = "_"
            )
        )

        return newString
    )


    fn createViewportPreview sPreviewFile = 
	(	
        /*
        *    Source:        Code adapted from blog post <Capturing the viewport according to render resolution>
        *    Author:        Lone Robot
        *    Availability:  http://lonerobot.net/?p=959
        */

        
		local ViewCapture = undefined			
		local CropView = getViewSize()
        local fRatio = undefined
        local progressStop = false

		case of 
		( 
			(CropView.x > CropView.y):	(fRatio = CropView.y/CropView.x)
			(CropView.x = CropView.y):	(fRatio = 1)			
			(CropView.x < CropView.y):	(fRatio = CropView.x/CropView.y)
	    )

        progressStart ((getFilenameFile sPreviewFile) as string + " Preview:")
        escapeEnable = true

        for t = animationrange.start to animationrange.end while not progressStop do
        (
            sliderTime = t
            progPerct = (100.0 * (t / ((animationrange.end as integer)/TicksPerFrame + 1))) as integer
            progressStop = keyboard.escPressed
            
            if not progressStop then
            (
                progressUpdate progPerctescapeEnable
            )
           
            windows.processPostedMessages()

			sPreviewName = "" as stringStream
			format "/%.%.jpg" (getFilenameFile sPreviewFile) (formattedPrint ((currentTime as integer)/TicksPerFrame) format:"04d") to: sPreviewName
            sPreviewFullPath = (getFilenamePath  sPreviewFile) + sPreviewName
            
            ViewportDib = gw.getViewportDib()
            ViewCapture = bitmap renderwidth renderheight color:white filename: sPreviewFullPath
            ViewportRatio = ViewportDib.width/ViewportDib.height as float
            RenderRatio = renderwidth/renderheight as float

            case of
            (
                (ViewportRatio <= RenderRatio):		    (
                                                            CapturetoRenderHeightfRatio = ViewportDib.width/RenderRatio as float
                                                            TopEdge = ((ViewportDib.Height-CapturetoRenderHeightfRatio)/ 2.0) as integer
                                                            FullViewCapture = bitmap ViewportDib.width CapturetoRenderHeightfRatio color:white
                                                            pasteBitmap ViewportDib FullViewCapture (box2 0 TopEdge ViewportDib.width ViewportDib.height) [0,0]
                                                            copy FullViewCapture ViewCapture
                                                            save ViewCapture)
                (ViewportRatio > RenderRatio):			(
                                                            CapturetoRenderHeightfRatio = ViewportDib.height*RenderRatio as float
                                                            LeftEdge = ((ViewportDib.width-CapturetoRenderHeightfRatio)/ 2.0) as integer
                                                            FullViewCapture = bitmap CapturetoRenderHeightfRatio ViewportDib.height color:white
                                                            pasteBitmap ViewportDib FullViewCapture (box2 LeftEdge 0 ViewportDib.width ViewportDib.height) [0,0]
                                                            copy FullViewCapture ViewCapture
                                                            save ViewCapture)
                default:()
            )

            close FullViewCapture
            close ViewCapture
            close ViewportDib
        )

        progressEnd()
		gc()

		if ViewCapture != undefined then 
		(
			return true
		)
		else
		(
			return false
		)
	)
    

    fn removeViewportHighliting = 
    (
        local oHelper = Point name:"vpg_helper"
        select oHelper
        clearSelection()
        append aHelper oHelper
    )


    fn removeViewportHighlitingHelper = 
    (
        for oHelper in aHelper where isvalidnode oHelper do 
        (
            delete oHelper
        )
    )


    fn setAreaTorenderToView = 
    (
        if EditRenderRegion.IsEditable == true then
		(
			EditRenderRegion.EditRegion()
        )
        
        if renderSceneDialog.isOpen() then
        (
            renderSceneDialog.close()
        )

        append aStoreAreaToRender (GetRenderType())
        SetRenderType aAreaToRender[1]
    )


    fn restoreAreaToRender =
    (
        if renderSceneDialog.isOpen() then
        (
            renderSceneDialog.close()
        )

        SetRenderType aStoreAreaToRender[1]
        aStoreAreaToRender = #()
    )


	fn getCurrentTimeRange = 
    (
        local tRange = animationRange
        append aTimeRange tRange
    )


    fn restoreTimeRange = 
    (
		if (aTimeRange.count == 1) and (classOf aTimeRange[1] == Interval) then 
		(
			animationRange = aTimeRange[1]
			aTimeRange = #()
        )
        else
        (
            print("No time range stored found.")
        )
    )


    fn createCamerasPreview oCamera sOuputFolder =
    (
        /* Collect cameras */
        local aAnimationRange = getCameraAnimationRange oCamera

        /* Set view to camera */
        setVieport oCamera

        /* Set timeline */
        setAnimationTimeline aAnimationRange[1] aAnimationRange[2]

        /* Get output folder and file paths*/
        local sCameraOutputFolderPath = (filterStr sOuputFolder "\\" "\\\\") + "\\\\" + (getValidString oCamera.name)
        local sCameraOutputFilePath = sCameraOutputFolderPath + "\\\\" + (getValidString oCamera.name)
        
        /* Create camera output folder*/
        makeDir sCameraOutputFolderPath

        /* Wait for viewport to update */
        sleep 5
        completeRedraw()
        
        /* Create preview*/
        createViewportPreview sCameraOutputFilePath
    )


    fn createSceneCamerasPreview = 
    (
        local aCameras = getAnimatedCameras()
 
        if aCameras.count == 0 then 
        (
            messageBox "Warning: No camera found in the scene. \n Aborting script."
        )
        else
        (
            if (renderWidth != 1920) then
            (
                if queryBox "Warning : The rendering resolution is not the standard HD. \n Do you want to switch to 1920x1080 ?" beep:false then
                (
                    if renderSceneDialog.isOpen() then
                    (
                        renderSceneDialog.close()
                    )

                    renderWidth = 1920
                    renderHeight = 1080
                )    
            )
            
            try
			(
				sOuputFolder = getOutputDirectory()

				if sOuputFolder != undefined then
				(
					getCurrentTimeRange()
					setViewportShadingType()
                    removeViewportHighliting()
                    hideCategories()
					setAreaTorenderToView()

					for x = 1 to aCameras.count do 
					(
						windows.processPostedMessages()   
						createCamerasPreview aCameras[x] sOuputFolder
					)

					restoreHiddenCategories()
					removeViewportHighlitingHelper()
					restoreAreaToRender()
					restoreTimeRange()
				) 
			)
			catch
			(
					restoreHiddenCategories()
					removeViewportHighlitingHelper()
					restoreAreaToRender()
					restoreTimeRange()
			)
        )
    )

	createSceneCamerasPreview()
)