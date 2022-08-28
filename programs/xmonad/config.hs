-- Main import 
import XMonad

-- Config
import XMonad.Config.Desktop

-- Utilities
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys, removeKeys)

-- Layouts
import XMonad.Layout.Grid

import XMonad.Hooks.ManageDocks ( Direction2D(..)
                                , ToggleStruts(..)
                                , avoidStruts
                                , docks
                                )
import XMonad.Layout.NoBorders ( smartBorders )

import XMonad.Hooks.FadeInactive ( fadeInactiveLogHook )

-- For Polybar
import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D
import XMonad.Hooks.StatusBar.PP

import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhFullscreen )

-- System things
import System.IO
import System.Exit

-- Misc
import Control.Monad (join, when, void)
import Data.Maybe (maybeToList)

main :: IO ()
main = mkDBusClient >>= main'

main' :: D.Client -> IO ()
main' dbus = xmonad . docks . ewmh . ewmhFullscreen $ def
  { terminal = myTerminal
  , modMask = myModMask
  , borderWidth = 3
  , normalBorderColor = "#dddddd"
  , focusedBorderColor = "#1681f2"
  , logHook = myPolybarLogHook dbus
  , layoutHook = myLayout
  }
  `removeKeys`
  [ (myModMask, xK_q)
  , (myModMask, xK_p)
  , (myModMask, xK_w)
  , (myModMask .|. shiftMask, xK_Return)
  ]
  `additionalKeys`
  [ ((myModMask, xK_Return), spawn myTerminal)
  , ((myModMask, xK_d), spawn "rofi -show drun")
  , ((myModMask .|. shiftMask, xK_q), kill)
  ]
  where
    myModMask = mod4Mask


myTerminal = "kitty"


-- Fancy things to make polybar work
mkDBusClient :: IO D.Client
mkDBusClient = do
    dbus <- D.connectSession
    D.requestName dbus (D.busName_ "org.xmonad.Log") opts
    return dbus
  where
    opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = 
  let opath = D.objectPath_ "/org/xmonad/Log"
      iname = D.interfaceName_ "org.xmonad.Log"
      mname = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body = [D.toVariant $ UTF8.decodeString str]
  in D.emit dbus $ signal {D.signalBody = body}

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
          , ppHiddenNoWindows = wrapper red
          , ppTitle           = wrapper purple . shorten 90
          , ppOrder           = \x -> [head x]
          }

myLogHook = fadeInactiveLogHook 0.9
myPolybarLogHook dbus = myLogHook <+> dynamicLogWithPP (polybarHook dbus)

-- Layout
myLayout = avoidStruts
         . smartBorders
         $ (layoutHook def)
