#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [string]$WallpaperPath,
    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Centre', 'Span', 'NoChange')]$Style = 'NoChange'
)

Add-Type @"

using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;

namespace Wallpaper {

    public class Setter {

        public const int SetDesktopWallpaper = 20;
        public const int UpdateIniFile = 0x01;
        public const int SendWinIniChange = 0x02;

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]

        private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);

        public static void SetWallpaper (string wallpaperPath, string wallpaperStyle) {

            SystemParametersInfo(SetDesktopWallpaper, 0, wallpaperPath, UpdateIniFile | SendWinIniChange);
            RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);

            switch (wallpaperStyle) {

                case "Fill":
                    key.SetValue(@"WallpaperStyle", "10");
                    key.SetValue(@"TileWallpaper", "0");
                break;

                case "Fit":
                    key.SetValue(@"WallpaperStyle", "6");
                    key.SetValue(@"TileWallpaper", "0");
                break;

                case "Stretch":
                    key.SetValue(@"WallpaperStyle", "2");
                    key.SetValue(@"TileWallpaper", "0");
                break;

                case "Tile":
                    key.SetValue(@"WallpaperStyle", "0");
                    key.SetValue(@"TileWallpaper", "1");
                break;

                case "Centre":
                    key.SetValue(@"WallpaperStyle", "0");
                    key.SetValue(@"TileWallpaper", "0");
                break;

                case "Span":
                    key.SetValue(@"WallpaperStyle", "22");
                    key.SetValue(@"TileWallpaper", "0");
                break;

                case "NoChange":
                break;

            }

            key.Close();

        }

    }

}

"@

[Wallpaper.Setter]::SetWallpaper("$WallpaperPath", "$Style")
