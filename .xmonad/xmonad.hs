{-# LANGUAGE NamedFieldPuns #-}

import qualified Data.Map as Map

import qualified XMonad.StackSet as StackSet

import qualified XMonad.Util.EZConfig as EZ
import qualified XMonad.Util.Run as Run
import qualified XMonad.Util.Cursor as Cursor

import qualified XMonad.Hooks.EwmhDesktops as Ewmh
import qualified XMonad.Hooks.ManageDocks as Docks
import qualified XMonad.Hooks.DynamicLog as DynamicLog

import qualified XMonad.Actions.ConstrainedResize as ConstrainedResize

import XMonad.Hooks.ManageHelpers (composeOne, doCenterFloat)

import XMonad
import Graphics.X11.Types
import Graphics.X11.ExtraTypes.XF86

myConfig config = config
  {
    terminal          = "konsole",
    modMask           = mod4Mask,
    borderWidth       = 2,
    focusFollowsMouse = True,
    startupHook       = myStartup <+> startupHook config,
    handleEventHook   = myEvents <+> handleEventHook config,
    layoutHook        = myLayouts $ layoutHook def,
    manageHook        = myHooks <+> manageHook config,
    mouseBindings     = myMouse <+> mouseBindings config,
    keys              = myKeys <+> (keys $ EZ.removeKeys config (removedKeys mod4Mask)),
    workspaces        = [ "1:main", "2:comms", "3:media", "4:logging" ]
  }

myEvents = Ewmh.ewmhDesktopsEventHook <+> Ewmh.fullscreenEventHook

myStartup = Cursor.setDefaultCursor Cursor.xC_left_ptr

myLayouts layouts = Docks.avoidStruts layouts

myHooks =
  composeAll [
    className =? "Xmessage" --> doCenterFloat,
    className =? "feh" --> doCenterFloat,
    className =? "skype" --> doShift "2:comms",
    stringProperty "WM_NAME" =? "Volume Control" --> doShift "3:media"
  ]

myMouse (XConfig { modMask }) =
  Map.fromList
    [
      ((modMask .|. shiftMask, button3),
        (\w -> focus w >> ConstrainedResize.mouseResizeWindow w True))
    ]

removedKeys modMask =
  [
    (modMask .|. keyMask, key)
    | key <- [xK_w, xK_e, xK_r]
    , keyMask <- [noModMask, shiftMask]
  ]

myKeys (XConfig { modMask }) =
  Map.fromList $
    [
      ((modMask, xK_b),
        sendMessage Docks.ToggleStruts),
      ((modMask .|. shiftMask, xK_l),
        Run.unsafeSpawn "i3lock && xset dpms force off"),
      ((noModMask, xK_Print),
        Run.unsafeSpawn "gm import -quality 100 -window $(xdotool getwindowfocus -f) ~/Pictures/window_$(date +%s).png"),
      ((modMask, xK_Print),
        Run.unsafeSpawn "gm import -quality 100 -window root ~/Pictures/screenshot_$(date +%s).png"),
      ((noModMask, xF86XK_AudioPlay),
        Run.safeSpawn "playerctl" ["play"]),
      ((noModMask, xF86XK_AudioPause),
        Run.safeSpawn "playerctl" ["pause"]),
      ((noModMask, xF86XK_AudioStop),
        Run.safeSpawn "playerctl" ["stop"]),
      ((noModMask, xF86XK_AudioPrev),
        Run.safeSpawn "playerctl" ["previous"]),
      ((noModMask, xF86XK_AudioNext),
        Run.safeSpawn "playerctl" ["next"]),
      ((noModMask, xF86XK_AudioMute),
        Run.safeSpawn "pactl" ["set-sink-mute", "@DEFAULT_SINK@", "toggle"]),
      ((noModMask, xF86XK_AudioLowerVolume),
        Run.safeSpawn "pactl" ["set-sink-volume", "@DEFAULT_SINK@", "-10%"]),
      ((noModMask, xF86XK_AudioRaiseVolume),
        Run.safeSpawn "pactl" ["set-sink-volume", "@DEFAULT_SINK@", "+10%"]),
      ((noModMask, xF86XK_MonBrightnessDown),
        Run.unsafeSpawn
          "read -r level </sys/class/backlight/acpi_video0/brightness\n\
          \read -r max </sys/class/backlight/acpi_video0/max_brightness\n\
          \factor=$((100/max))\n\
          \xbacklight -set \"$((level * factor))\""),
      ((noModMask, xF86XK_MonBrightnessUp),
        Run.unsafeSpawn
          "read -r level </sys/class/backlight/acpi_video0/brightness\n\
          \read -r max </sys/class/backlight/acpi_video0/max_brightness\n\
          \factor=$((100/max))\n\
          \xbacklight -set \"$((level * factor))\"")
    ]
    ++
    [
      ((modMask .|. keyMask, key), screenWorkspace screen >>= flip whenJust (windows . winAction))
      | (key, screen) <- zip [xK_1..xK_9] [0..]
      , (winAction, keyMask) <- [(StackSet.view, controlMask), (StackSet.shift, mod1Mask)]
    ]


main = do
    xmproc <- Run.spawnPipe "xmobar"
    xmonad $ Docks.docks $ Ewmh.ewmh $ myConfig $ def
      {
        logHook = DynamicLog.dynamicLogWithPP $ def
          {
            DynamicLog.ppOutput = Run.hPutStrLn xmproc,
            DynamicLog.ppTitle  = DynamicLog.xmobarColor "green" "" . DynamicLog.shorten 50
          }
      }

-- todo: http://thinkingeek.com/2011/11/21/simple-guide-configure-xmonad-dzen2-conky/
