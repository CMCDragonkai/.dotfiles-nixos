{-# LANGUAGE NamedFieldPuns #-}

import qualified Data.Map as Map
import qualified XMonad.Actions.ConstrainedResize as ConstrainedResize

import XMonad
import XMonad.Config.Desktop

import XMonad.Util.Run (safeSpawn, unsafeSpawn, spawnPipe, hPutStrLn)
import XMonad.Util.EZConfig (additionalKeys)

import XMonad.Hooks.ManageDocks (docks)
import XMonad.Hooks.ManageHelpers (composeOne, doCenterFloat, (-?>))

import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.DynamicLog

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
    `additionalKeys` matrixKeys

-- extra key actions
-- screen lock and turn off screen
-- screen shot active window
-- screen shot entire screen
-- music keys, volume down
-- music keys, volume up
matrixKeys =
  [
      (
        (mod4Mask .|. shiftMask, xK_z),
        unsafeSpawn "i3lock && xset dpms force off"
      ),
      (
        (noModMask, xK_Print),
        unsafeSpawn "gm import -quality 100 -window $(xdotool getwindowfocus -f) ~/Pictures/window_$(date +%s).png"
      ),
      (
        (mod4Mask, xK_Print),
        unsafeSpawn "gm import -quality 100 -window root ~/Pictures/screenshot_$(date +%s).png"
      ),
      (
        (noModMask, xF86XK_AudioPlay),
        unsafeSpawn "playerctl play"
      ),
      (
        (noModMask, xF86XK_AudioPause),
        unsafeSpawn "playerctl pause"
      ),
      (
        (noModMask, xF86XK_AudioStop),
        unsafeSpawn "playerctl stop"
      ),
      (
        (noModMask, xF86XK_AudioPrev),
        unsafeSpawn "playerctl previous"
      ),
      (
        (noModMask, xF86XK_AudioNext),
        unsafeSpawn "playerctl next"
      ),
      (
        (noModMask, xF86XK_AudioMute),
        unsafeSpawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ),
      (
        (noModMask, xF86XK_AudioLowerVolume),
        unsafeSpawn "pactl set-sink-volume @DEFAULT_SINK@ -10%"
      ),
      (

        (noModMask, xF86XK_AudioRaiseVolume),
        unsafeSpawn "pactl set-sink-volume @DEFAULT_SINK@ +10%"
      ),
      (
        (noModMask, xF86XK_MonBrightnessDown),
        unsafeSpawn
          "read -r level </sys/class/backlight/acpi_video0/brightness\n\
          \read -r max </sys/class/backlight/acpi_video0/max_brightness\n\
          \factor=$((100/max))\n\
          \xbacklight -set \"$((level * factor))\""
      ),
      (
        (noModMask, xF86XK_MonBrightnessUp),
        unsafeSpawn
          "read -r level </sys/class/backlight/acpi_video0/brightness\n\
          \read -r max </sys/class/backlight/acpi_video0/max_brightness\n\
          \factor=$((100/max))\n\
          \xbacklight -set \"$((level * factor))\""
      )
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
