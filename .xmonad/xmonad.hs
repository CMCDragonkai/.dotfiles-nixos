{-# LANGUAGE NamedFieldPuns #-}

{-

    Furthermore, we have added `XMonad.Actions.ConstrainedReize` as `ConstrainedResize`, 
    which allows us to do fixed aspect ratio resizing with `Mod + Shift + Button 3 Drag`. 
    This module requires the `xmonad-contrib` package.

    The `XMonad` namespace also brings in some operators like `<+>` and `.|.`. 
    The `.|.` bitwise or operator will set the resultant bits to 1, if either of the 
    initial bits is set to 1. I'm not sure how that translates to having 2 keys/buttons 
    pressed at the same time. I do not know what the exact type of the `<+>` is, but 
    I believe it merges the left and right functions of the same type, and those functions
    return `Map` types, and it then merges the 2 `Map` types together. 
    I found it, it's `Control.Arrow.(<+>)`, the type is `a b c -> a b c -> a b c`. It 
    is a monoid append operation on arrows. The arrow `a b c` means `b -> c`. So it 
    takes 2 arrows with the same input and output types, and returns an arrow with the 
    same input and output. It's actually a generic function, so it's part of the `ArrowPlus` 
    typeclass. XMonad must have created an instance for `ArrowPlus`, that's how this works!

    The `NamedFieldPuns` extension allows us to pattern match on records using just 
    their field names.

    The `XMonad` namespace also brings in functions from a number of other modules too. 
    Such as including `XMonad.ManageHook.composeAll`. And `=?` and `-->` and `doFloat` and 
    `doShift`. However I'm actually using `Xmonad.Hooks.ManageHelpers.doCenterFloat`. Which 
    is also a `xmonad-contrib` module.

-}

import XMonad
import XMonad.Config.Desktop
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (docks)
import XMonad.Hooks.ManageHelpers (composeOne, doCenterFloat, (-?>))
import XMonad.Util.EZConfig (additionalKeys)
import qualified XMonad.Actions.ConstrainedResize as ConstrainedResize

import qualified Data.Map as Map

matrixConfig = desktopConfig
    {
        terminal = "konsole",
        modMask = mod4Mask,
        borderWidth = 2,
        focusFollowsMouse = True,
        manageHook = matrixHooks <+> manageHook desktopConfig,
        mouseBindings = matrixMouse <+> mouseBindings desktopConfig,
        workspaces = [ "1", "2", "3" ]
    }
    `additionalKeys`
    [
        ((mod4Mask .|. shiftMask, xK_z), spawn "i3lock && xset dpms force off")
    ]

-- actions to perform for specific window classes
matrixHooks =
    composeAll [
        -- make xmessage float in the center
        className =? "Xmessage" --> doCenterFloat,
        className =? "feh" --> doCenterFloat
    ]

-- mouse macros
matrixMouse (XConfig { modMask }) =
    Map.fromList [
        (
            -- allow fixed aspect ratio resize
            (modMask .|. shiftMask, button3),
            (\w -> focus w >> ConstrainedResize.mouseResizeWindow w True)
        )
    ]

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ docks $ matrixConfig {
        logHook = dynamicLogWithPP $ def { ppOutput = hPutStrLn xmproc, ppTitle = xmobarColor "green" "" . shorten 50 }
    }
