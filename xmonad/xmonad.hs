--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
-- IMPORTS 
import XMonad
import Data.Monoid
import System.Exit
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Hooks.DynamicLog
import XMonad.Actions.Commands

import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import qualified XMonad.Layout.NoBorders as BO
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.StatusBar
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.FadeInactive

--import XMonad.Layout.Fullscreen
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Util.Hacks as Hacks
import XMonad.Actions.WorkspaceNames

import XMonad.ManageHook
import XMonad.Util.NamedScratchpad

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "st"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
-- Make xmobar clickable
xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x    = [x]
myWorkspaces            :: [String]
myWorkspaces    = clickable . (map xmobarEscape) $ [" 1 "," 2 "," 3 "," 4 "," 5 "," 6 "," 7 "," 8 "," 9 "]
 where                                                                       
         clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip [1..9] l,                                        
                            let n = i ]
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
--myFocusedBorderColor = "#9c4922"
myFocusedBorderColor = "#b54b09"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run -i -l 15 -sb '#C95A49'")
    , ((modm,               xK_d     ), spawn "rofi -show run 'System San Francisco Display 10'")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Toggle layout full screen
    --, ((modm,               xK_f), toggleFull)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask , xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart;")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    -- Volume control
    , ((modm, xK_Home),  spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
    , ((modm, xK_End),  spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
    , ((modm .|. shiftMask, xK_m),  spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    --, ((modm .|. shiftMask, xK_m),  spawn "pamixer --toggle-mute")

    -- Brightness control
    , ((modm, xK_Prior),  spawn "brightnessctl  set +50")
    , ((modm, xK_Next),  spawn "brightnessctl  set 50-")

    -- Suspend
    , ((modm .|. shiftMask, xK_s),  spawn "systemctl suspend && xsecurelock")

    -- Lock screen
    --, ((modm .|. shiftMask, xK_l),  spawn "xsecurelock")
    -- Capture screen 
    , ((modm, xK_Print),  spawn "gnome-screenshot -i")

    -- Change background asciitilde see xmodmap -pke
    , ((modm, xK_grave),  spawn "feh --bg-fill --randomize ~/Pictures/wallpapers/*")

    -- Toggle full screen
    , ((modm, xK_f), sendMessage $ Toggle FULL)
    -- scratchpad shortcuts
     , ((modm, xK_y), namedScratchpadAction scratchpads "term")
     , ((modm, xK_u), namedScratchpadAction scratchpads "ranger")
     , ((modm, xK_n), namedScratchpadAction scratchpads "monitor")
     -- Swap between workspaces by workspaceNamesEwmh
     , ((modm .|. shiftMask, xK_Right ), swapTo Next)
     , ((modm .|. shiftMask, xK_Left ), swapTo Prev)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
--myLayout = gaps [(U,24), (D,5), (R,5), (L,5)] $ Tall 1 (3/100) (1/2) ||| Full
-- We can add (BO.lessBorders BO.Never) to set full screen borderless 
-- Set mkToggle for full screen shortcut 
myLayout =  BO.smartBorders $ mkToggle (NOBORDERS ?? FULL ?? EOT) $ gaps [(U,30), (R,4), (L,4), (D,4)] $ spacing 3 $ (tiled ||| Mirror tiled |||  Full)
               where
                   -- default tiling algorithm partitions the screen into two panes
                   tiled   = Tall nmaster delta ratio

                   -- The default number of windows in the master pane
                   nmaster = 1

                   -- Default proportion of screen occupied by master pane
                   ratio   = 1/2

                   -- Percent of screen to increment by when resizing panes
                   delta   = 3/100

--myLayout = spacing 5 $ Tall (1 (3/100) (1/2)) ||| Full
--myLayout = spacingRaw True (Border 15 15 15 15) True (Border 15 15 15 15) True $ Tall (2 (3/100) (1/2)) ||| Full


------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook::ManageHook
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Qalculate-gtk"  --> doFloat
    , className =? "gnome-calculator"  --> doFloat
    , className =? "Gnome-system-monitor"  --> doFloat
    , className =? "mpv"              --> doFloat
    , isDialog                          --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]
        <+> manageDocks


------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
--myEventHook = mempty
myEventHook = ewmh

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()
--myLogHook = dynamicLog
-- myLogHook = dynamicLogWithPP $ def { ppOutput = hPutStrLn xmproc }
myLogHook xmproc = dynamicLogWithPP $ xmobarPP
    { ppOutput = hPutStrLn xmproc
    , ppTitle = xmobarColor "darkorange" "" . shorten 50
    --, ppTitle = const "" 
    , ppCurrent             = xmobarColor   "orange"       "black"
    , ppUrgent              = xmobarColor   "darkred"      "black"
    , ppVisible             = xmobarColor   "yellow"       "black" 
    , ppHidden              = xmobarColor   "Gray"      "black"
--    , ppHiddenNoWindows     = xmobarColor   "gray"       "Gray"
    }
dimLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
-- We have moved startup commands to bash profile to exceute regardless of the WM
myStartupHook = do 
        -- Nothing
        --spawnOnce "feh --bg-fill --randomize ~/Pictures/wallpapers/*"
        spawnOnce "picom -b -i 1.0"
        -- spawnOnce "xcompmgr -f -C -n -D 3"
        --spawnOnce "nm-applet &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
-- main = xmonad =<< xmobar defaults
main = do
    --xmonad =<< myBar myPP 
    --xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"    
    xmproc <- spawnPipe "xmobar"    
    xmonad $ workspaceNamesEwmh . ewmh $ docks defaults  { logHook = dimLogHook >> (myLogHook xmproc) }


-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
-- The main function.
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> namedScratchpadManageHook scratchpads,
        --handleEventHook    = myEventHook,
        --handleEventHook    = ewmhFullscreen,
        -- Solve fullscreen problem for chromium based browsers
        handleEventHook = handleEventHook def <+> Hacks.windowedFullscreenFixEventHook,

        -- fullscreenEventHook Deprecated
        --logHook            = dimLogHook >> (myLogHook xmproc),
        -- logHook            = myLogHook,
        startupHook        = myStartupHook
--                      -- XMOBAR SETTINGS
--              { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
--                -- Current workspace
--              , ppCurrent = xmobarColor color06 "" . wrap
--                            ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
--                -- Visible but not current workspace
--              , ppVisible = xmobarColor color06 "" . clickable
--                -- Hidden workspace
--              , ppHidden = xmobarColor color05 "" . wrap
--                           ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable
--                -- Hidden workspaces (no windows)
--              , ppHiddenNoWindows = xmobarColor color05 ""  . clickable
--                -- Title of active window
--              , ppTitle = xmobarColor color16 "" . shorten 60
--                -- Separator character
--              , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
--                -- Urgent workspace
--              , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
--                -- Adding # of windows on current workspace to the bar
--              , ppExtras  = [windowCount]
--                -- order of things in xmobar
--              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
--              }

    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]

-- Scratchpad
scratchpads = [
-- run htop in xterm, find it by title, use default floating window placement
    NS "term" "konsole" (className =? "konsole")
        (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) ,
-- run stardict, find it by class name, place it in the floating window
-- 1/6 of screen width from the left, 1/6 of screen height
-- from the top, 2/3 of screen width by 2/3 of screen height
    --NS "ranger" "st -r ranger" (className =? "ranger")
    NS "ranger" "st -e ranger" (title =? "ranger")
        (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) ,

-- run gvim, find by role, don't float
    --NS "notes" "gvim --role notes ~/notes.txt" (role =? "notes") nonFloating
    NS "monitor" "gnome-system-monitor" (className =? "Gnome-system-monitor")
        (customFloating $ W.RationalRect (1/6) (1/6) (6/2) (6/2))
    ] where role = stringProperty "WM_WINDOW_ROLE"
