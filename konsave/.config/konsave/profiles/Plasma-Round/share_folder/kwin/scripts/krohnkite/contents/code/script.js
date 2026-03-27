"use strict";
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
var Shortcut;
(function (Shortcut) {
    Shortcut[Shortcut["FocusNext"] = 0] = "FocusNext";
    Shortcut[Shortcut["FocusPrev"] = 1] = "FocusPrev";
    Shortcut[Shortcut["DWMLeft"] = 2] = "DWMLeft";
    Shortcut[Shortcut["DWMRight"] = 3] = "DWMRight";
    Shortcut[Shortcut["FocusUp"] = 4] = "FocusUp";
    Shortcut[Shortcut["FocusDown"] = 5] = "FocusDown";
    Shortcut[Shortcut["FocusLeft"] = 6] = "FocusLeft";
    Shortcut[Shortcut["FocusRight"] = 7] = "FocusRight";
    Shortcut[Shortcut["ShiftLeft"] = 8] = "ShiftLeft";
    Shortcut[Shortcut["ShiftRight"] = 9] = "ShiftRight";
    Shortcut[Shortcut["ShiftUp"] = 10] = "ShiftUp";
    Shortcut[Shortcut["ShiftDown"] = 11] = "ShiftDown";
    Shortcut[Shortcut["SwapUp"] = 12] = "SwapUp";
    Shortcut[Shortcut["SwapDown"] = 13] = "SwapDown";
    Shortcut[Shortcut["SwapLeft"] = 14] = "SwapLeft";
    Shortcut[Shortcut["SwapRight"] = 15] = "SwapRight";
    Shortcut[Shortcut["GrowWidth"] = 16] = "GrowWidth";
    Shortcut[Shortcut["GrowHeight"] = 17] = "GrowHeight";
    Shortcut[Shortcut["ShrinkWidth"] = 18] = "ShrinkWidth";
    Shortcut[Shortcut["ShrinkHeight"] = 19] = "ShrinkHeight";
    Shortcut[Shortcut["Increase"] = 20] = "Increase";
    Shortcut[Shortcut["Decrease"] = 21] = "Decrease";
    Shortcut[Shortcut["ShiftIncrease"] = 22] = "ShiftIncrease";
    Shortcut[Shortcut["ShiftDecrease"] = 23] = "ShiftDecrease";
    Shortcut[Shortcut["ToggleFloat"] = 24] = "ToggleFloat";
    Shortcut[Shortcut["ToggleFloatAll"] = 25] = "ToggleFloatAll";
    Shortcut[Shortcut["SetMaster"] = 26] = "SetMaster";
    Shortcut[Shortcut["NextLayout"] = 27] = "NextLayout";
    Shortcut[Shortcut["PreviousLayout"] = 28] = "PreviousLayout";
    Shortcut[Shortcut["SetLayout"] = 29] = "SetLayout";
    Shortcut[Shortcut["Rotate"] = 30] = "Rotate";
    Shortcut[Shortcut["RotatePart"] = 31] = "RotatePart";
})(Shortcut || (Shortcut = {}));
var CONFIG;
var KWinConfig = (function () {
    function KWinConfig() {
        var _this = this;
        function commaSeparate(str) {
            if (!str || typeof str !== "string")
                return [];
            return str.split(",").map(function (part) { return part.trim(); });
        }
        DEBUG.enabled = DEBUG.enabled || KWIN.readConfig("debug", false);
        this.layoutOrder = [];
        this.layoutFactories = {};
        [
            ["enableTileLayout", true, TileLayout],
            ["enableMonocleLayout", true, MonocleLayout],
            ["enableThreeColumnLayout", true, ThreeColumnLayout],
            ["enableSpreadLayout", true, SpreadLayout],
            ["enableStairLayout", true, StairLayout],
            ["enableSpiralLayout", true, SpiralLayout],
            ["enableQuarterLayout", false, QuarterLayout],
            ["enableStackedLayout", false, StackedLayout],
            ["enableFloatingLayout", false, FloatingLayout],
            ["enableBTreeLayout", false, BTreeLayout],
            ["enableCascadeLayout", false, CascadeLayout],
        ].forEach(function (_a) {
            var configKey = _a[0], defaultValue = _a[1], layoutClass = _a[2];
            if (KWIN.readConfig(configKey, defaultValue))
                _this.layoutOrder.push(layoutClass.id);
            _this.layoutFactories[layoutClass.id] = function () { return new layoutClass(); };
        });
        this.maximizeSoleTile = KWIN.readConfig("maximizeSoleTile", false);
        this.monocleMaximize = KWIN.readConfig("monocleMaximize", true);
        this.monocleMinimizeRest = KWIN.readConfig("monocleMinimizeRest", false);
        this.stairReverse = KWIN.readConfig("stairReverse", false);
        this.adjustLayout = KWIN.readConfig("adjustLayout", true);
        this.adjustLayoutLive = KWIN.readConfig("adjustLayoutLive", true);
        this.keepFloatAbove = KWIN.readConfig("keepFloatAbove", true);
        this.keepTilingOnDrag = KWIN.readConfig("keepTilingOnDrag", false);
        this.noTileBorder = KWIN.readConfig("noTileBorder", false);
        this.limitTileWidthRatio = 0;
        if (KWIN.readConfig("limitTileWidth", false))
            this.limitTileWidthRatio = KWIN.readConfig("limitTileWidthRatio", 1.6);
        this.screenGapBottom = KWIN.readConfig("screenGapBottom", 0);
        this.screenGapLeft = KWIN.readConfig("screenGapLeft", 0);
        this.screenGapRight = KWIN.readConfig("screenGapRight", 0);
        this.screenGapTop = KWIN.readConfig("screenGapTop", 0);
        this.tileLayoutGap = KWIN.readConfig("tileLayoutGap", 0);
        var directionalKeyDwm = KWIN.readConfig("directionalKeyDwm", false);
        var directionalKeyFocus = KWIN.readConfig("directionalKeyFocus", true);
        this.directionalKeyMode = directionalKeyDwm ? "dwm" : "focus";
        this.newWindowPosition = KWIN.readConfig("newWindowPosition", 0);
        this.layoutPerActivity = KWIN.readConfig("layoutPerActivity", true);
        this.layoutPerDesktop = KWIN.readConfig("layoutPerDesktop", true);
        this.floatUtility = KWIN.readConfig("floatUtility", true);
        this.preventMinimize = KWIN.readConfig("preventMinimize", false);
        this.preventProtrusion = KWIN.readConfig("preventProtrusion", true);
        this.pollMouseXdotool = KWIN.readConfig("pollMouseXdotool", false);
        this.floatingClass = commaSeparate(KWIN.readConfig("floatingClass", ""));
        this.floatingTitle = commaSeparate(KWIN.readConfig("floatingTitle", ""));
        this.ignoreActivity = commaSeparate(KWIN.readConfig("ignoreActivity", ""));
        this.ignoreClass = commaSeparate(KWIN.readConfig("ignoreClass", "krunner,yakuake,spectacle,kded5,xwaylandvideobridge,plasmashell,ksplashqml"));
        this.ignoreRole = commaSeparate(KWIN.readConfig("ignoreRole", "quake"));
        this.ignoreScreen = commaSeparate(KWIN.readConfig("ignoreScreen", ""));
        this.ignoreTitle = commaSeparate(KWIN.readConfig("ignoreTitle", ""));
        this.screenDefaultLayout = commaSeparate(KWIN.readConfig("screenDefaultLayout", ""));
        if (this.preventMinimize && this.monocleMinimizeRest) {
            debug(function () { return "preventMinimize is disabled because of monocleMinimizeRest."; });
            this.preventMinimize = false;
        }
    }
    KWinConfig.prototype.toString = function () {
        return "Config(" + JSON.stringify(this, undefined, 2) + ")";
    };
    return KWinConfig;
}());
var KWINCONFIG;
var KWIN;
var KWinDriver = (function () {
    function KWinDriver(api) {
        var _this = this;
        KWIN = api.kwin;
        this.workspace = api.workspace;
        this.shortcuts = api.shortcuts;
        this.engine = new TilingEngine();
        this.control = new TilingController(this.engine);
        this.windowMap = new WrapperMap(function (client) { return KWinWindow.generateID(client); }, function (client) {
            return new WindowClass(new KWinWindow(client, _this.workspace));
        });
        this.entered = false;
        this.mousePoller = new KWinMousePoller();
    }
    Object.defineProperty(KWinDriver.prototype, "backend", {
        get: function () {
            return KWinDriver.backendName;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinDriver.prototype, "currentSurface", {
        get: function () {
            return new KWinSurface(this.workspace.activeWindow
                ? this.workspace.activeWindow.output
                : this.workspace.activeScreen, this.workspace.currentActivity, this.workspace.currentDesktop, this.workspace);
        },
        set: function (value) {
            var ksrf = value;
            if (this.workspace.currentDesktop.name !== ksrf.desktop.name)
                this.workspace.currentDesktop = ksrf.desktop;
            if (this.workspace.currentActivity !== ksrf.activity)
                this.workspace.currentActivity = ksrf.activity;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinDriver.prototype, "currentWindow", {
        get: function () {
            var client = this.workspace.activeWindow;
            return client ? this.windowMap.get(client) : null;
        },
        set: function (window) {
            if (window !== null)
                this.workspace.activeWindow = window.window.window;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinDriver.prototype, "screens", {
        get: function () {
            var _this = this;
            var screens = [];
            this.workspace.screens.forEach(function (screen) {
                screens.push(new KWinSurface(screen, _this.workspace.currentActivity, _this.workspace.currentDesktop, _this.workspace));
            });
            return screens;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinDriver.prototype, "cursorPosition", {
        get: function () {
            return this.mousePoller.mousePosition;
        },
        enumerable: false,
        configurable: true
    });
    KWinDriver.prototype.main = function () {
        CONFIG = KWINCONFIG = new KWinConfig();
        debug(function () { return "Config: " + KWINCONFIG; });
        this.bindEvents();
        this.bindShortcut();
        var clients = this.workspace.stackingOrder;
        for (var i = 0; i < clients.length; i++) {
            if (!clients[i].normalWindow) {
                continue;
            }
            var window = this.windowMap.add(clients[i]);
            this.engine.manage(window);
            if (window.state !== WindowState.Unmanaged)
                this.bindWindowEvents(window, clients[i]);
            else
                this.windowMap.remove(clients[i]);
        }
        this.engine.arrange(this);
    };
    KWinDriver.prototype.setTimeout = function (func, timeout) {
        var _this = this;
        KWinSetTimeout(function () { return _this.enter(func); }, timeout);
    };
    KWinDriver.prototype.showNotification = function (text) {
        popupDialog.show(text);
    };
    KWinDriver.prototype.bindShortcut = function () {
        var _this = this;
        var callbackShortcut = function (shortcut) {
            return function () {
                _this.enter(function () { return _this.control.onShortcut(_this, shortcut); });
            };
        };
        this.shortcuts
            .getFocusNext()
            .activated.connect(callbackShortcut(Shortcut.FocusNext));
        this.shortcuts
            .getFocusPrev()
            .activated.connect(callbackShortcut(Shortcut.FocusPrev));
        this.shortcuts
            .getFocusDown()
            .activated.connect(callbackShortcut(Shortcut.FocusDown));
        this.shortcuts
            .getFocusUp()
            .activated.connect(callbackShortcut(Shortcut.FocusUp));
        this.shortcuts
            .getFocusLeft()
            .activated.connect(callbackShortcut(Shortcut.FocusLeft));
        this.shortcuts
            .getFocusRight()
            .activated.connect(callbackShortcut(Shortcut.FocusRight));
        this.shortcuts
            .getShiftDown()
            .activated.connect(callbackShortcut(Shortcut.ShiftDown));
        this.shortcuts
            .getShiftUp()
            .activated.connect(callbackShortcut(Shortcut.ShiftUp));
        this.shortcuts
            .getShiftLeft()
            .activated.connect(callbackShortcut(Shortcut.ShiftLeft));
        this.shortcuts
            .getShiftRight()
            .activated.connect(callbackShortcut(Shortcut.ShiftRight));
        this.shortcuts
            .getGrowHeight()
            .activated.connect(callbackShortcut(Shortcut.GrowHeight));
        this.shortcuts
            .getShrinkHeight()
            .activated.connect(callbackShortcut(Shortcut.ShrinkHeight));
        this.shortcuts
            .getShrinkWidth()
            .activated.connect(callbackShortcut(Shortcut.ShrinkWidth));
        this.shortcuts
            .getGrowWidth()
            .activated.connect(callbackShortcut(Shortcut.GrowWidth));
        this.shortcuts
            .getIncrease()
            .activated.connect(callbackShortcut(Shortcut.Increase));
        this.shortcuts
            .getDecrease()
            .activated.connect(callbackShortcut(Shortcut.Decrease));
        this.shortcuts
            .getToggleFloat()
            .activated.connect(callbackShortcut(Shortcut.ToggleFloat));
        this.shortcuts
            .getFloatAll()
            .activated.connect(callbackShortcut(Shortcut.ToggleFloatAll));
        this.shortcuts
            .getNextLayout()
            .activated.connect(callbackShortcut(Shortcut.NextLayout));
        this.shortcuts
            .getPreviousLayout()
            .activated.connect(callbackShortcut(Shortcut.PreviousLayout));
        this.shortcuts
            .getRotate()
            .activated.connect(callbackShortcut(Shortcut.Rotate));
        this.shortcuts
            .getRotatePart()
            .activated.connect(callbackShortcut(Shortcut.RotatePart));
        this.shortcuts
            .getSetMaster()
            .activated.connect(callbackShortcut(Shortcut.SetMaster));
        var callbackShortcutLayout = function (layoutClass) {
            return function () {
                _this.enter(function () {
                    return _this.control.onShortcut(_this, Shortcut.SetLayout, layoutClass.id);
                });
            };
        };
        this.shortcuts
            .getTileLayout()
            .activated.connect(callbackShortcutLayout(TileLayout));
        this.shortcuts
            .getMonocleLayout()
            .activated.connect(callbackShortcutLayout(MonocleLayout));
        this.shortcuts
            .getThreeColumnLayout()
            .activated.connect(callbackShortcutLayout(ThreeColumnLayout));
        this.shortcuts
            .getSpreadLayout()
            .activated.connect(callbackShortcutLayout(SpreadLayout));
        this.shortcuts
            .getStairLayout()
            .activated.connect(callbackShortcutLayout(StairLayout));
        this.shortcuts
            .getFloatingLayout()
            .activated.connect(callbackShortcutLayout(FloatingLayout));
        this.shortcuts
            .getQuarterLayout()
            .activated.connect(callbackShortcutLayout(QuarterLayout));
        this.shortcuts
            .getStackedLayout()
            .activated.connect(callbackShortcutLayout(StackedLayout));
        this.shortcuts
            .getSpiralLayout()
            .activated.connect(callbackShortcutLayout(SpiralLayout));
        this.shortcuts
            .getBTreeLayout()
            .activated.connect(callbackShortcutLayout(BTreeLayout));
    };
    KWinDriver.prototype.connect = function (signal, handler) {
        var _this = this;
        var wrapper = function () {
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            if (typeof _this.workspace === "undefined")
                signal.disconnect(wrapper);
            else
                _this.enter(function () { return handler.apply(_this, args); });
        };
        signal.connect(wrapper);
        return wrapper;
    };
    KWinDriver.prototype.enter = function (callback) {
        if (this.entered)
            return;
        this.entered = true;
        try {
            callback();
        }
        catch (e) {
            debug(function () { return "Error raised from line " + e.lineNumber; });
            debug(function () { return e; });
        }
        finally {
            this.entered = false;
        }
    };
    KWinDriver.prototype.bindEvents = function () {
        var _this = this;
        this.connect(this.workspace.screensChanged, function () {
            return _this.control.onSurfaceUpdate(_this, "screens (Outputs) changed");
        });
        this.connect(this.workspace.virtualScreenGeometryChanged, function () {
            _this.control.onSurfaceUpdate(_this, "virtualScreenGeometryChanged");
        });
        this.connect(this.workspace.currentActivityChanged, function (activityId) {
            return _this.control.onCurrentActivityChanged(_this, activityId);
        });
        this.connect(this.workspace.currentDesktopChanged, function (virtualDesktop) {
            return _this.control.onSurfaceUpdate(_this, "currentDesktopChanged");
        });
        this.connect(this.workspace.windowAdded, function (client) {
            if (client.normalWindow && !client.hidden) {
                if (KWIN.readConfig("debugActiveWin", false))
                    print(debugWin(client));
                var window = _this.windowMap.add(client);
                _this.control.onWindowAdded(_this, window);
                if (window.state !== WindowState.Unmanaged) {
                    _this.bindWindowEvents(window, client);
                }
                else
                    _this.windowMap.remove(client);
            }
        });
        this.connect(this.workspace.windowRemoved, function (client) {
            var window = _this.windowMap.get(client);
            if (window) {
                _this.control.onWindowRemoved(_this, window);
                _this.windowMap.remove(client);
            }
        });
    };
    KWinDriver.prototype.bindWindowEvents = function (window, client) {
        var _this = this;
        var moving = false;
        var resizing = false;
        this.connect(client.maximizedAboutToChange, function (mode) {
            var maximized = mode === 3;
            window.window.maximized = maximized;
            _this.control.onWindowMaximizeChanged(_this, window, maximized);
        });
        this.connect(client.minimizedChanged, function () {
            if (KWINCONFIG.preventMinimize) {
                client.minimized = false;
                _this.workspace.activeWindow = client;
            }
            else {
                var comment = client.minimized ? "minimized" : "unminimized";
                _this.control.onWindowChanged(_this, window, comment);
            }
        });
        this.connect(client.fullScreenChanged, function () {
            return _this.control.onWindowChanged(_this, window, "fullscreen=" + client.fullScreen);
        });
        this.connect(client.moveResizedChanged, function () {
            debugObj(function () { return [
                "moveResizedChanged",
                { window: window, move: client.move, resize: client.resize },
            ]; });
            if (moving !== client.move) {
                moving = client.move;
                if (moving) {
                    _this.mousePoller.start();
                    _this.control.onWindowMoveStart(window);
                }
                else {
                    _this.control.onWindowMoveOver(_this, window);
                    _this.mousePoller.stop();
                }
            }
            if (resizing !== client.resize) {
                resizing = client.resize;
                if (resizing)
                    _this.control.onWindowResizeStart(window);
                else
                    _this.control.onWindowResizeOver(_this, window);
            }
        });
        this.connect(client.bufferGeometryChanged, function () {
            if (moving)
                _this.control.onWindowMove(window);
            else if (resizing)
                _this.control.onWindowResize(_this, window);
            else {
                if (!window.actualGeometry.equals(window.geometry))
                    _this.control.onWindowGeometryChanged(_this, window);
            }
        });
        this.connect(client.activeChanged, function () {
            if (client.active)
                _this.control.onWindowFocused(_this, window);
        });
        this.connect(client.outputChanged, function () {
            return _this.control.onWindowChanged(_this, window, "screen=" + client.output.name);
        });
        this.connect(client.activitiesChanged, function () {
            return _this.control.onWindowChanged(_this, window, "activity=" + client.activities.join(","));
        });
        this.connect(client.desktopsChanged, function () {
            return _this.control.onWindowChanged(_this, window, "Window's desktop changed.");
        });
    };
    KWinDriver.backendName = "kwin";
    return KWinDriver;
}());
var KWinMousePoller = (function () {
    function KWinMousePoller() {
        var _this = this;
        this.startCount = 0;
        this.cmdResult = null;
        mousePoller.interval = 0;
        mousePoller.onNewData.connect(function (sourceName, data) {
            _this.cmdResult = data["exit code"] === 0 ? data["stdout"] : null;
            mousePoller.disconnectSource(KWinMousePoller.COMMAND);
            KWinSetTimeout(function () {
                if (_this.started)
                    mousePoller.connectSource(KWinMousePoller.COMMAND);
            }, KWinMousePoller.INTERVAL);
        });
    }
    Object.defineProperty(KWinMousePoller.prototype, "started", {
        get: function () {
            return this.startCount > 0;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinMousePoller.prototype, "mousePosition", {
        get: function () {
            return this.parseResult();
        },
        enumerable: false,
        configurable: true
    });
    KWinMousePoller.prototype.start = function () {
        this.startCount += 1;
        if (KWINCONFIG.pollMouseXdotool)
            mousePoller.connectSource(KWinMousePoller.COMMAND);
    };
    KWinMousePoller.prototype.stop = function () {
        this.startCount = Math.max(this.startCount - 1, 0);
    };
    KWinMousePoller.prototype.parseResult = function () {
        if (!this.cmdResult)
            return null;
        var x = null;
        var y = null;
        this.cmdResult
            .split(" ")
            .slice(0, 2)
            .forEach(function (part) {
            var _a = part.split(":"), key = _a[0], value = _a[1], _ = _a[2];
            if (key === "x")
                x = parseInt(value, 10);
            if (key === "y")
                y = parseInt(value, 10);
        });
        if (x === null || y === null)
            return null;
        return [x, y];
    };
    KWinMousePoller.COMMAND = "xdotool getmouselocation";
    KWinMousePoller.INTERVAL = 50;
    return KWinMousePoller;
}());
var KWinTimerPool = (function () {
    function KWinTimerPool() {
        this.timers = [];
        this.numTimers = 0;
    }
    KWinTimerPool.prototype.setTimeout = function (func, timeout) {
        var _this = this;
        if (this.timers.length === 0) {
            this.numTimers++;
            debugObj(function () { return ["setTimeout/newTimer", { numTimers: _this.numTimers }]; });
        }
        var timer = this.timers.pop() ||
            Qt.createQmlObject("import QtQuick 2.0; Timer {}", scriptRoot);
        var callback = function () {
            try {
                timer.triggered.disconnect(callback);
            }
            catch (e) {
            }
            try {
                func();
            }
            catch (e) {
            }
            _this.timers.push(timer);
        };
        timer.interval = timeout;
        timer.repeat = false;
        timer.triggered.connect(callback);
        timer.start();
    };
    KWinTimerPool.instance = new KWinTimerPool();
    return KWinTimerPool;
}());
function KWinSetTimeout(func, timeout) {
    KWinTimerPool.instance.setTimeout(func, timeout);
}
var KWinSurface = (function () {
    function KWinSurface(output, activity, desktop, workspace) {
        this.id = KWinSurface.generateId(output.name, activity, desktop.name);
        this.ignore =
            KWINCONFIG.ignoreActivity.indexOf(activity) >= 0 ||
                KWINCONFIG.ignoreScreen.indexOf(output.name) >= 0;
        this.workingArea = toRect(workspace.clientArea(0, output, desktop));
        this.output = output;
        this.activity = activity;
        this.desktop = desktop;
    }
    KWinSurface.generateId = function (screenName, activity, desktopName) {
        var path = screenName;
        if (KWINCONFIG.layoutPerActivity)
            path += "@" + activity;
        if (KWINCONFIG.layoutPerDesktop)
            path += "#" + desktopName;
        return path;
    };
    KWinSurface.prototype.next = function () {
        return null;
    };
    KWinSurface.prototype.toString = function () {
        return ("KWinSurface(" +
            [this.output.name, this.activity, this.desktop.name].join(", ") +
            ")");
    };
    return KWinSurface;
}());
var KWinWindow = (function () {
    function KWinWindow(window, workspace) {
        this.workspace = workspace;
        this.window = window;
        this.id = KWinWindow.generateID(window);
        this.maximized = false;
        this.noBorderManaged = false;
        this.noBorderOriginal = window.noBorder;
    }
    KWinWindow.generateID = function (w) {
        return w.internalId.toString();
    };
    Object.defineProperty(KWinWindow.prototype, "fullScreen", {
        get: function () {
            return this.window.fullScreen;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinWindow.prototype, "geometry", {
        get: function () {
            return toRect(this.window.bufferGeometry);
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinWindow.prototype, "shouldIgnore", {
        get: function () {
            var resourceClass = String(this.window.resourceClass);
            var resourceName = String(this.window.resourceName);
            var windowRole = String(this.window.windowRole);
            return (this.window.specialWindow ||
                resourceClass === "plasmashell" ||
                KWINCONFIG.ignoreClass.indexOf(resourceClass) >= 0 ||
                KWINCONFIG.ignoreClass.indexOf(resourceName) >= 0 ||
                matchWords(this.window.caption, KWINCONFIG.ignoreTitle) >= 0 ||
                KWINCONFIG.ignoreRole.indexOf(windowRole) >= 0);
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinWindow.prototype, "shouldFloat", {
        get: function () {
            var resourceClass = String(this.window.resourceClass);
            var resourceName = String(this.window.resourceName);
            var moreOneDesktop = this.window.desktops.length !== 1;
            return (moreOneDesktop ||
                this.window.onAllDesktops ||
                this.window.modal ||
                this.window.transient ||
                !this.window.resizeable ||
                (KWINCONFIG.floatUtility &&
                    (this.window.dialog || this.window.splash || this.window.utility)) ||
                KWINCONFIG.floatingClass.indexOf(resourceClass) >= 0 ||
                KWINCONFIG.floatingClass.indexOf(resourceName) >= 0 ||
                matchWords(this.window.caption, KWINCONFIG.floatingTitle) >= 0);
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(KWinWindow.prototype, "surface", {
        get: function () {
            var activity;
            if (this.window.activities.length === 0)
                activity = this.workspace.currentActivity;
            else if (this.window.activities.indexOf(this.workspace.currentActivity) >= 0)
                activity = this.workspace.currentActivity;
            else
                activity = this.window.activities[0];
            var desktop = this.window.desktops[0];
            return new KWinSurface(this.window.output, activity, desktop, this.workspace);
        },
        set: function (srf) {
            var ksrf = srf;
            if (this.window.desktops[0] !== ksrf.desktop)
                this.window.desktops = [ksrf.desktop];
            if (this.window.activities[0] !== ksrf.activity)
                this.window.activities = [ksrf.activity];
        },
        enumerable: false,
        configurable: true
    });
    KWinWindow.prototype.commit = function (geometry, noBorder, keepAbove) {
        debugObj(function () { return ["KWinWindow#commit", { geometry: geometry, noBorder: noBorder, keepAbove: keepAbove }]; });
        if (this.window.move || this.window.resize)
            return;
        if (noBorder !== undefined) {
            if (!this.noBorderManaged && noBorder)
                this.noBorderOriginal = this.window.noBorder;
            else if (this.noBorderManaged && !this.window.noBorder)
                this.noBorderOriginal = false;
            if (noBorder)
                this.window.noBorder = true;
            else if (this.noBorderManaged)
                this.window.noBorder = this.noBorderOriginal;
            this.noBorderManaged = noBorder;
        }
        if (keepAbove !== undefined)
            this.window.keepAbove = keepAbove;
        if (geometry !== undefined) {
            geometry = this.adjustGeometry(geometry);
            if (KWINCONFIG.preventProtrusion) {
                var area = toRect(this.workspace.clientArea(0, this.window.output, this.workspace.currentDesktop));
                if (!area.includes(geometry)) {
                    var x = geometry.x + Math.min(area.maxX - geometry.maxX, 0);
                    var y = geometry.y + Math.min(area.maxY - geometry.maxY, 0);
                    geometry = new Rect(x, y, geometry.width, geometry.height);
                    geometry = this.adjustGeometry(geometry);
                }
            }
            this.window.frameGeometry = toQRect(geometry);
            this.window.rect;
        }
    };
    KWinWindow.prototype.toString = function () {
        return ("KWin(" +
            this.window.internalId.toString() +
            "." +
            this.window.resourceClass +
            ")");
    };
    KWinWindow.prototype.visible = function (srf) {
        var ksrf = srf;
        return (!this.window.minimized &&
            (this.window.onAllDesktops ||
                this.window.desktops.indexOf(ksrf.desktop) !== -1) &&
            (this.window.activities.length === 0 ||
                this.window.activities.indexOf(ksrf.activity) !== -1) &&
            this.window.output === ksrf.output);
    };
    KWinWindow.prototype.adjustGeometry = function (geometry) {
        var width = geometry.width;
        var height = geometry.height;
        if (!this.window.resizeable) {
            width = this.window.width;
            height = this.window.height;
        }
        else {
            width = clip(width, this.window.minSize.width, this.window.maxSize.width);
            height = clip(height, this.window.minSize.height, this.window.maxSize.height);
        }
        return new Rect(geometry.x, geometry.y, width, height);
    };
    return KWinWindow;
}());
function debugWin(win) {
    var w_props = [
        { name: "caption", opt: win.caption },
        { name: "output.name", opt: win.output.name },
        { name: "resourceName", opt: win.resourceName },
        { name: "resourceClass", opt: win.resourceClass },
        { name: "desktopWindow", opt: win.desktopWindow },
        { name: "windowRole", opt: win.windowRole },
        { name: "windowType", opt: win.windowType },
        { name: "pid", opt: win.pid },
        { name: "internalId", opt: win.internalId },
        { name: "stackingOrder", opt: win.stackingOrder },
        { name: "size", opt: win.size },
        { name: "width", opt: win.width },
        { name: "height", opt: win.height },
        { name: "dock", opt: win.dock },
        { name: "toolbar", opt: win.toolbar },
        { name: "menu", opt: win.menu },
        { name: "dialog", opt: win.dialog },
        { name: "splash", opt: win.splash },
        { name: "utility", opt: win.utility },
        { name: "dropdownMenu", opt: win.dropdownMenu },
        { name: "popupMenu", opt: win.popupMenu },
        { name: "tooltip", opt: win.tooltip },
        { name: "notification", opt: win.notification },
        { name: "criticalNotification", opt: win.criticalNotification },
        { name: "appletPopup", opt: win.appletPopup },
        { name: "onScreenDisplay", opt: win.onScreenDisplay },
        { name: "comboBox", opt: win.comboBox },
        { name: "managed", opt: win.managed },
        { name: "popupWindow", opt: win.popupWindow },
        { name: "outline", opt: win.outline },
        { name: "fullScreenable", opt: win.fullScreenable },
        { name: "closeable", opt: win.closeable },
        { name: "minimizable", opt: win.minimizable },
        { name: "specialWindow", opt: win.specialWindow },
        { name: "modal", opt: win.modal },
        { name: "resizeable", opt: win.resizeable },
        { name: "minimized", opt: win.minimized },
        { name: "tile", opt: win.tile },
        { name: "minSize", opt: win.minSize },
        { name: "maxSize", opt: win.maxSize },
        { name: "transient", opt: win.transient },
        { name: "transientFor", opt: win.transientFor },
        { name: "maximizable", opt: win.maximizable },
        { name: "moveable", opt: win.moveable },
        { name: "moveableAcrossScreens", opt: win.moveableAcrossScreens },
        { name: "hidden", opt: win.hidden },
        { name: "keepAbove", opt: win.keepAbove },
        { name: "keepBelow", opt: win.keepBelow },
    ];
    var s = "krohnkite:";
    w_props.forEach(function (el) {
        if (typeof el.opt !== "undefined" &&
            (el.opt || el.opt === 0 || el.opt === "0")) {
            s += "<";
            s += el.name;
            s += ": ";
            s += el.opt;
            s += "> ";
        }
    });
    return s;
}
var TestDriver = (function () {
    function TestDriver() {
        this.currentScreen = 0;
        this.currentWindow = 0;
        this.numScreen = 1;
        this.screenSize = new Rect(0, 0, 10000, 10000);
        this.windows = [];
    }
    TestDriver.prototype.forEachScreen = function (func) {
        for (var screen = 0; screen < this.numScreen; screen++)
            func(new TestSurface(this, screen));
    };
    TestDriver.prototype.getCurrentContext = function () {
        var window = this.getCurrentWindow();
        if (window)
            return window.surface;
        return new TestSurface(this, 0);
    };
    TestDriver.prototype.getCurrentWindow = function () {
        return this.windows.length !== 0 ? this.windows[this.currentWindow] : null;
    };
    TestDriver.prototype.getWorkingArea = function (srf) {
        return this.screenSize;
    };
    TestDriver.prototype.setCurrentWindow = function (window) {
        var idx = this.windows.indexOf(window);
        if (idx !== -1)
            this.currentWindow = idx;
    };
    TestDriver.prototype.setTimeout = function (func, timeout) {
        setTimeout(func, timeout);
    };
    return TestDriver;
}());
var TestSurface = (function () {
    function TestSurface(driver, screen) {
        this.driver = driver;
        this.screen = screen;
    }
    Object.defineProperty(TestSurface.prototype, "id", {
        get: function () {
            return String(this.screen);
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(TestSurface.prototype, "ignore", {
        get: function () {
            return false;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(TestSurface.prototype, "workingArea", {
        get: function () {
            return this.driver.screenSize;
        },
        enumerable: false,
        configurable: true
    });
    TestSurface.prototype.next = function () {
        return new TestSurface(this.driver, this.screen + 1);
    };
    return TestSurface;
}());
var TestWindow = (function () {
    function TestWindow(srf, geometry, ignore, float) {
        this.id = String(TestWindow.windowCount);
        TestWindow.windowCount += 1;
        this.shouldFloat = float !== undefined ? float : false;
        this.shouldIgnore = ignore !== undefined ? ignore : false;
        this.surface = srf;
        this.fullScreen = false;
        this.geometry = geometry || new Rect(0, 0, 100, 100);
        this.keepAbove = false;
        this.maximized = false;
        this.noBorder = false;
    }
    TestWindow.prototype.commit = function (geometry, noBorder, keepAbove) {
        if (geometry)
            this.geometry = geometry;
        if (noBorder !== undefined)
            this.noBorder = noBorder;
        if (keepAbove !== undefined)
            this.keepAbove = keepAbove;
    };
    TestWindow.prototype.focus = function () {
    };
    TestWindow.prototype.visible = function (srf) {
        var tctx = srf;
        return this.surface.screen === tctx.screen;
    };
    TestWindow.windowCount = 0;
    return TestWindow;
}());
function setTestConfig(name, value) {
    if (!CONFIG)
        CONFIG = {};
    CONFIG[name] = value;
}
var TilingController = (function () {
    function TilingController(engine) {
        this.engine = engine;
    }
    TilingController.prototype.onSurfaceUpdate = function (ctx, comment) {
        debugObj(function () { return ["onSurfaceUpdate", { comment: comment }]; });
        this.engine.arrange(ctx);
    };
    TilingController.prototype.onCurrentActivityChanged = function (ctx, activityId) {
        debugObj(function () { return ["onCurrentActivityChanged", { activityId: activityId }]; });
        this.engine.arrange(ctx);
    };
    TilingController.prototype.onCurrentSurfaceChanged = function (ctx) {
        debugObj(function () { return ["onCurrentSurfaceChanged", { srf: ctx.currentSurface }]; });
        this.engine.arrange(ctx);
    };
    TilingController.prototype.onWindowAdded = function (ctx, window) {
        debugObj(function () { return ["onWindowAdded", { window: window }]; });
        this.engine.manage(window);
        if (window.tileable) {
            var srf = ctx.currentSurface;
            var tiles = this.engine.windows.getVisibleTiles(srf);
            var layoutCapcity = this.engine.layouts.getCurrentLayout(srf).capacity;
            if (layoutCapcity !== undefined && tiles.length > layoutCapcity) {
                var nsrf = ctx.currentSurface.next();
                if (nsrf) {
                    window.surface = nsrf;
                    ctx.currentSurface = nsrf;
                }
            }
        }
        this.engine.arrange(ctx);
    };
    TilingController.prototype.onWindowRemoved = function (ctx, window) {
        debugObj(function () { return ["onWindowRemoved", { window: window }]; });
        this.engine.unmanage(window);
        this.engine.arrange(ctx);
    };
    TilingController.prototype.onWindowMoveStart = function (window) {
    };
    TilingController.prototype.onWindowMove = function (window) {
    };
    TilingController.prototype.onWindowMoveOver = function (ctx, window) {
        debugObj(function () { return ["onWindowMoveOver", { window: window }]; });
        if (window.state === WindowState.Tiled) {
            var tiles = this.engine.windows.getVisibleTiles(ctx.currentSurface);
            var cursorPos_1 = ctx.cursorPosition || window.actualGeometry.center;
            var targets = tiles.filter(function (tile) {
                return tile !== window && tile.actualGeometry.includesPoint(cursorPos_1);
            });
            if (targets.length === 1) {
                this.engine.windows.swap(window, targets[0]);
                this.engine.arrange(ctx);
                return;
            }
        }
        if (!CONFIG.keepTilingOnDrag && window.state === WindowState.Tiled) {
            var diff = window.actualGeometry.subtract(window.geometry);
            var distance = Math.sqrt(Math.pow(diff.x, 2) + Math.pow(diff.y, 2));
            if (distance > 30) {
                window.floatGeometry = window.actualGeometry;
                window.state = WindowState.Floating;
                this.engine.arrange(ctx);
                return;
            }
        }
        window.commit();
    };
    TilingController.prototype.onWindowResizeStart = function (window) {
    };
    TilingController.prototype.onWindowResize = function (ctx, window) {
        debugObj(function () { return ["onWindowResize", { window: window }]; });
        if (CONFIG.adjustLayout && CONFIG.adjustLayoutLive) {
            if (window.state === WindowState.Tiled) {
                this.engine.adjustLayout(window);
                this.engine.arrange(ctx);
            }
        }
    };
    TilingController.prototype.onWindowResizeOver = function (ctx, window) {
        debugObj(function () { return ["onWindowResizeOver", { window: window }]; });
        if (CONFIG.adjustLayout && window.tiled) {
            this.engine.adjustLayout(window);
            this.engine.arrange(ctx);
        }
        else if (!CONFIG.adjustLayout)
            this.engine.enforceSize(ctx, window);
    };
    TilingController.prototype.onWindowMaximizeChanged = function (ctx, window, maximized) {
        this.engine.arrange(ctx);
    };
    TilingController.prototype.onWindowGeometryChanged = function (ctx, window) {
        debugObj(function () { return ["onWindowGeometryChanged", { window: window }]; });
        this.engine.enforceSize(ctx, window);
    };
    TilingController.prototype.onWindowChanged = function (ctx, window, comment) {
        if (window) {
            debugObj(function () { return ["onWindowChanged", { window: window, comment: comment }]; });
            if (comment === "unminimized")
                ctx.currentWindow = window;
            this.engine.arrange(ctx);
        }
    };
    TilingController.prototype.onWindowFocused = function (ctx, window) {
        window.timestamp = new Date().getTime();
    };
    TilingController.prototype.onShortcut = function (ctx, input, data) {
        if (CONFIG.directionalKeyMode === "dwm") {
            switch (input) {
                case Shortcut.FocusUp:
                    input = Shortcut.FocusNext;
                    break;
                case Shortcut.FocusDown:
                    input = Shortcut.FocusPrev;
                    break;
                case Shortcut.FocusLeft:
                    input = Shortcut.DWMLeft;
                    break;
                case Shortcut.FocusRight:
                    input = Shortcut.DWMRight;
                    break;
            }
        }
        else if (CONFIG.directionalKeyMode === "focus") {
            switch (input) {
                case Shortcut.ShiftUp:
                    input = Shortcut.SwapUp;
                    break;
                case Shortcut.ShiftDown:
                    input = Shortcut.SwapDown;
                    break;
                case Shortcut.ShiftLeft:
                    input = Shortcut.SwapLeft;
                    break;
                case Shortcut.ShiftRight:
                    input = Shortcut.SwapRight;
                    break;
            }
        }
        if (this.engine.handleLayoutShortcut(ctx, input, data)) {
            this.engine.arrange(ctx);
            return;
        }
        var window = ctx.currentWindow;
        switch (input) {
            case Shortcut.FocusNext:
                this.engine.focusOrder(ctx, -1);
                break;
            case Shortcut.FocusPrev:
                this.engine.focusOrder(ctx, +1);
                break;
            case Shortcut.FocusUp:
                this.engine.focusDir(ctx, "up");
                break;
            case Shortcut.FocusDown:
                this.engine.focusDir(ctx, "down");
                break;
            case Shortcut.DWMLeft:
            case Shortcut.FocusLeft:
                this.engine.focusDir(ctx, "left");
                break;
            case Shortcut.DWMRight:
            case Shortcut.FocusRight:
                this.engine.focusDir(ctx, "right");
                break;
            case Shortcut.GrowWidth:
                if (window)
                    this.engine.resizeWindow(window, "east", 1);
                break;
            case Shortcut.ShrinkWidth:
                if (window)
                    this.engine.resizeWindow(window, "east", -1);
                break;
            case Shortcut.GrowHeight:
                if (window)
                    this.engine.resizeWindow(window, "south", 1);
                break;
            case Shortcut.ShrinkHeight:
                if (window)
                    this.engine.resizeWindow(window, "south", -1);
                break;
            case Shortcut.ShiftUp:
                if (window)
                    this.engine.swapOrder(window, -1);
                break;
            case Shortcut.ShiftDown:
                if (window)
                    this.engine.swapOrder(window, +1);
                break;
            case Shortcut.SwapUp:
                this.engine.swapDirOrMoveFloat(ctx, "up");
                break;
            case Shortcut.SwapDown:
                this.engine.swapDirOrMoveFloat(ctx, "down");
                break;
            case Shortcut.SwapLeft:
                this.engine.swapDirOrMoveFloat(ctx, "left");
                break;
            case Shortcut.SwapRight:
                this.engine.swapDirOrMoveFloat(ctx, "right");
                break;
            case Shortcut.SetMaster:
                if (window)
                    this.engine.setMaster(window);
                break;
            case Shortcut.ToggleFloat:
                if (window)
                    this.engine.toggleFloat(window);
                break;
            case Shortcut.ToggleFloatAll:
                this.engine.floatAll(ctx, ctx.currentSurface);
                break;
            case Shortcut.NextLayout:
                this.engine.cycleLayout(ctx, 1);
                break;
            case Shortcut.PreviousLayout:
                this.engine.cycleLayout(ctx, -1);
                break;
            case Shortcut.SetLayout:
                if (typeof data === "string")
                    this.engine.setLayout(ctx, data);
                break;
        }
        this.engine.arrange(ctx);
    };
    return TilingController;
}());
var TilingEngine = (function () {
    function TilingEngine() {
        this.layouts = new LayoutStore();
        this.windows = new WindowStore();
    }
    TilingEngine.prototype.adjustLayout = function (basis) {
        var srf = basis.surface;
        var layout = this.layouts.getCurrentLayout(srf);
        if (layout.adjust) {
            var area = srf.workingArea.gap(CONFIG.screenGapLeft, CONFIG.screenGapRight, CONFIG.screenGapTop, CONFIG.screenGapBottom);
            var tiles = this.windows.getVisibleTiles(srf);
            layout.adjust(area, tiles, basis, basis.geometryDelta);
        }
    };
    TilingEngine.prototype.resizeFloat = function (window, dir, step) {
        var srf = window.surface;
        var hStepSize = srf.workingArea.width * 0.05;
        var vStepSize = srf.workingArea.height * 0.05;
        var hStep, vStep;
        switch (dir) {
            case "east":
                (hStep = step), (vStep = 0);
                break;
            case "west":
                (hStep = -step), (vStep = 0);
                break;
            case "south":
                (hStep = 0), (vStep = step);
                break;
            case "north":
                (hStep = 0), (vStep = -step);
                break;
        }
        var geometry = window.actualGeometry;
        var width = geometry.width + hStepSize * hStep;
        var height = geometry.height + vStepSize * vStep;
        window.forceSetGeometry(new Rect(geometry.x, geometry.y, width, height));
    };
    TilingEngine.prototype.resizeTile = function (basis, dir, step) {
        var srf = basis.surface;
        if (dir === "east") {
            var maxX_1 = basis.geometry.maxX;
            var easternNeighbor = this.windows
                .getVisibleTiles(srf)
                .filter(function (tile) { return tile.geometry.x >= maxX_1; });
            if (easternNeighbor.length === 0) {
                dir = "west";
                step *= -1;
            }
        }
        else if (dir === "south") {
            var maxY_1 = basis.geometry.maxY;
            var southernNeighbor = this.windows
                .getVisibleTiles(srf)
                .filter(function (tile) { return tile.geometry.y >= maxY_1; });
            if (southernNeighbor.length === 0) {
                dir = "north";
                step *= -1;
            }
        }
        var hStepSize = srf.workingArea.width * 0.03;
        var vStepSize = srf.workingArea.height * 0.03;
        var delta;
        switch (dir) {
            case "east":
                delta = new RectDelta(hStepSize * step, 0, 0, 0);
                break;
            case "west":
                delta = new RectDelta(0, hStepSize * step, 0, 0);
                break;
            case "south":
                delta = new RectDelta(0, 0, vStepSize * step, 0);
                break;
            case "north":
            default:
                delta = new RectDelta(0, 0, 0, vStepSize * step);
                break;
        }
        var layout = this.layouts.getCurrentLayout(srf);
        if (layout.adjust) {
            var area = srf.workingArea.gap(CONFIG.screenGapLeft, CONFIG.screenGapRight, CONFIG.screenGapTop, CONFIG.screenGapBottom);
            layout.adjust(area, this.windows.getVisibleTileables(srf), basis, delta);
        }
    };
    TilingEngine.prototype.resizeWindow = function (window, dir, step) {
        var state = window.state;
        if (WindowClass.isFloatingState(state))
            this.resizeFloat(window, dir, step);
        else if (WindowClass.isTiledState(state))
            this.resizeTile(window, dir, step);
    };
    TilingEngine.prototype.arrange = function (ctx) {
        var _this = this;
        debug(function () { return "arrange"; });
        ctx.screens.forEach(function (srf) {
            _this.arrangeScreen(ctx, srf);
        });
    };
    TilingEngine.prototype.arrangeScreen = function (ctx, srf) {
        var layout = this.layouts.getCurrentLayout(srf);
        var workingArea = srf.workingArea;
        var tilingArea;
        if (CONFIG.monocleMaximize && layout instanceof MonocleLayout)
            tilingArea = workingArea;
        else
            tilingArea = workingArea.gap(CONFIG.screenGapLeft, CONFIG.screenGapRight, CONFIG.screenGapTop, CONFIG.screenGapBottom);
        var visibles = this.windows.getVisibleWindows(srf);
        debugObj(function () { return [
            "arrangeScreen",
            {
                layout: layout,
                srf: srf,
                visibles: visibles.length,
            },
        ]; });
        visibles.forEach(function (window) {
            if (window.state === WindowState.Undecided)
                window.state = window.shouldFloat
                    ? WindowState.Floating
                    : WindowState.Tiled;
        });
        var tileables = this.windows.getVisibleTileables(srf);
        if (CONFIG.maximizeSoleTile && tileables.length === 1) {
            tileables[0].state = WindowState.Maximized;
            tileables[0].geometry = workingArea;
        }
        else if (tileables.length > 0)
            layout.apply(new EngineContext(ctx, this), tileables, tilingArea);
        if (CONFIG.limitTileWidthRatio > 0 && !(layout instanceof MonocleLayout)) {
            var maxWidth_1 = Math.floor(workingArea.height * CONFIG.limitTileWidthRatio);
            tileables
                .filter(function (tile) { return tile.tiled && tile.geometry.width > maxWidth_1; })
                .forEach(function (tile) {
                var g = tile.geometry;
                tile.geometry = new Rect(g.x + Math.floor((g.width - maxWidth_1) / 2), g.y, maxWidth_1, g.height);
            });
        }
        visibles.forEach(function (window) { return window.commit(); });
        debugObj(function () { return ["arrangeScreen/finished", { srf: srf }]; });
    };
    TilingEngine.prototype.enforceSize = function (ctx, window) {
        if (window.tiled && !window.actualGeometry.equals(window.geometry))
            ctx.setTimeout(function () {
                if (window.tiled)
                    window.commit();
            }, 10);
    };
    TilingEngine.prototype.manage = function (window) {
        if (!window.shouldIgnore) {
            window.state = WindowState.Undecided;
            if (CONFIG.newWindowPosition === 1)
                this.windows.unshift(window);
            else if (CONFIG.newWindowPosition === 2) {
                this.windows.beside_first(window);
            }
            else
                this.windows.push(window);
        }
    };
    TilingEngine.prototype.unmanage = function (window) {
        this.windows.remove(window);
    };
    TilingEngine.prototype.focusOrder = function (ctx, step) {
        var window = ctx.currentWindow;
        if (window === null) {
            var tiles = this.windows.getVisibleTiles(ctx.currentSurface);
            if (tiles.length > 1)
                ctx.currentWindow = tiles[0];
            return;
        }
        var visibles = this.windows.getVisibleWindows(ctx.currentSurface);
        if (visibles.length === 0)
            return;
        var idx = visibles.indexOf(window);
        if (!window || idx < 0) {
            ctx.currentWindow = visibles[0];
            return;
        }
        var num = visibles.length;
        var newIndex = (idx + (step % num) + num) % num;
        ctx.currentWindow = visibles[newIndex];
    };
    TilingEngine.prototype.focusDir = function (ctx, dir) {
        var window = ctx.currentWindow;
        if (window === null) {
            var tiles = this.windows.getVisibleTiles(ctx.currentSurface);
            if (tiles.length > 1)
                ctx.currentWindow = tiles[0];
            return;
        }
        var neighbor = this.getNeighborByDirection(ctx, window, dir);
        if (neighbor)
            ctx.currentWindow = neighbor;
    };
    TilingEngine.prototype.swapOrder = function (window, step) {
        var srf = window.surface;
        var visibles = this.windows.getVisibleWindows(srf);
        if (visibles.length < 2)
            return;
        var vsrc = visibles.indexOf(window);
        var vdst = wrapIndex(vsrc + step, visibles.length);
        var dstWin = visibles[vdst];
        this.windows.move(window, dstWin);
    };
    TilingEngine.prototype.swapDirection = function (ctx, dir) {
        var window = ctx.currentWindow;
        if (window === null) {
            var tiles = this.windows.getVisibleTiles(ctx.currentSurface);
            if (tiles.length > 1)
                ctx.currentWindow = tiles[0];
            return;
        }
        var neighbor = this.getNeighborByDirection(ctx, window, dir);
        if (neighbor)
            this.windows.swap(window, neighbor);
    };
    TilingEngine.prototype.moveFloat = function (window, dir) {
        var srf = window.surface;
        var hStepSize = srf.workingArea.width * 0.05;
        var vStepSize = srf.workingArea.height * 0.05;
        var hStep, vStep;
        switch (dir) {
            case "up":
                (hStep = 0), (vStep = -1);
                break;
            case "down":
                (hStep = 0), (vStep = 1);
                break;
            case "left":
                (hStep = -1), (vStep = 0);
                break;
            case "right":
                (hStep = 1), (vStep = 0);
                break;
        }
        var geometry = window.actualGeometry;
        var x = geometry.x + hStepSize * hStep;
        var y = geometry.y + vStepSize * vStep;
        window.forceSetGeometry(new Rect(x, y, geometry.width, geometry.height));
    };
    TilingEngine.prototype.swapDirOrMoveFloat = function (ctx, dir) {
        var window = ctx.currentWindow;
        if (!window)
            return;
        var state = window.state;
        if (WindowClass.isFloatingState(state))
            this.moveFloat(window, dir);
        else if (WindowClass.isTiledState(state))
            this.swapDirection(ctx, dir);
    };
    TilingEngine.prototype.toggleFloat = function (window) {
        window.state = !window.tileable ? WindowState.Tiled : WindowState.Floating;
    };
    TilingEngine.prototype.floatAll = function (ctx, srf) {
        var windows = this.windows.getVisibleWindows(srf);
        var numFloats = windows.reduce(function (count, window) {
            return window.state === WindowState.Floating ? count + 1 : count;
        }, 0);
        if (numFloats < windows.length / 2) {
            windows.forEach(function (window) {
                window.floatGeometry = window.actualGeometry.gap(4, 4, 4, 4);
                window.state = WindowState.Floating;
            });
            ctx.showNotification("Float All");
        }
        else {
            windows.forEach(function (window) {
                window.state = WindowState.Tiled;
            });
            ctx.showNotification("Tile All");
        }
    };
    TilingEngine.prototype.setMaster = function (window) {
        this.windows.setMaster(window);
    };
    TilingEngine.prototype.cycleLayout = function (ctx, step) {
        var layout = this.layouts.cycleLayout(ctx.currentSurface, step);
        if (layout)
            ctx.showNotification(layout.description);
    };
    TilingEngine.prototype.setLayout = function (ctx, layoutClassID) {
        var layout = this.layouts.setLayout(ctx.currentSurface, layoutClassID);
        if (layout)
            ctx.showNotification(layout.description);
    };
    TilingEngine.prototype.handleLayoutShortcut = function (ctx, input, data) {
        var layout = this.layouts.getCurrentLayout(ctx.currentSurface);
        if (layout.handleShortcut)
            return layout.handleShortcut(new EngineContext(ctx, this), input, data);
        return false;
    };
    TilingEngine.prototype.getNeighborByDirection = function (ctx, basis, dir) {
        var vertical;
        var sign;
        switch (dir) {
            case "up":
                vertical = true;
                sign = -1;
                break;
            case "down":
                vertical = true;
                sign = 1;
                break;
            case "left":
                vertical = false;
                sign = -1;
                break;
            case "right":
                vertical = false;
                sign = 1;
                break;
            default:
                return null;
        }
        var candidates = this.windows
            .getVisibleTiles(ctx.currentSurface)
            .filter(vertical
            ? function (tile) { return tile.geometry.y * sign > basis.geometry.y * sign; }
            : function (tile) { return tile.geometry.x * sign > basis.geometry.x * sign; })
            .filter(vertical
            ? function (tile) {
                return overlap(basis.geometry.x, basis.geometry.maxX, tile.geometry.x, tile.geometry.maxX);
            }
            : function (tile) {
                return overlap(basis.geometry.y, basis.geometry.maxY, tile.geometry.y, tile.geometry.maxY);
            });
        if (candidates.length === 0)
            return null;
        var min = sign *
            candidates.reduce(vertical
                ? function (prevMin, tile) { return Math.min(tile.geometry.y * sign, prevMin); }
                : function (prevMin, tile) {
                    return Math.min(tile.geometry.x * sign, prevMin);
                }, Infinity);
        var closest = candidates.filter(vertical
            ? function (tile) { return tile.geometry.y === min; }
            : function (tile) { return tile.geometry.x === min; });
        return closest.sort(function (a, b) { return b.timestamp - a.timestamp; })[0];
    };
    return TilingEngine;
}());
var EngineContext = (function () {
    function EngineContext(drvctx, engine) {
        this.drvctx = drvctx;
        this.engine = engine;
    }
    Object.defineProperty(EngineContext.prototype, "backend", {
        get: function () {
            return this.drvctx.backend;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(EngineContext.prototype, "currentWindow", {
        get: function () {
            return this.drvctx.currentWindow;
        },
        set: function (window) {
            this.drvctx.currentWindow = window;
        },
        enumerable: false,
        configurable: true
    });
    EngineContext.prototype.setTimeout = function (func, timeout) {
        this.drvctx.setTimeout(func, timeout);
    };
    EngineContext.prototype.cycleFocus = function (step) {
        this.engine.focusOrder(this.drvctx, step);
    };
    EngineContext.prototype.moveWindow = function (window, target, after) {
        this.engine.windows.move(window, target, after);
    };
    EngineContext.prototype.showNotification = function (text) {
        this.drvctx.showNotification(text);
    };
    return EngineContext;
}());
var LayoutStoreEntry = (function () {
    function LayoutStoreEntry(output_name, desktop_name) {
        var _this = this;
        var layouts_str = CONFIG.layoutOrder.map(function (layout, i) { return i + "." + layout + ", "; });
        print("Krohnkite: Screen(output):".concat(output_name, ", Desktop(name):").concat(desktop_name, ", layouts: ").concat(layouts_str));
        this.currentIndex = 0;
        this.currentID = CONFIG.layoutOrder[0];
        CONFIG.screenDefaultLayout.some(function (entry) {
            var cfg = entry.split(":");
            var cfg_output = cfg[0];
            var cfg_desktop = cfg.length == 2 ? undefined : cfg[1];
            var cfg_screen_id_str = cfg.length == 2 ? cfg[1] : cfg[2];
            var cfg_screen_id = parseInt(cfg_screen_id_str);
            if ((output_name === cfg_output || cfg_output === '') &&
                (desktop_name === cfg_desktop || cfg_desktop === undefined) &&
                cfg_screen_id >= 0 &&
                cfg_screen_id < CONFIG.layoutOrder.length) {
                _this.currentIndex = cfg_screen_id;
                _this.currentID = CONFIG.layoutOrder[_this.currentIndex];
                return true;
            }
        });
        this.layouts = {};
        this.previousID = this.currentID;
        this.loadLayout(this.currentID);
    }
    Object.defineProperty(LayoutStoreEntry.prototype, "currentLayout", {
        get: function () {
            return this.loadLayout(this.currentID);
        },
        enumerable: false,
        configurable: true
    });
    LayoutStoreEntry.prototype.cycleLayout = function (step) {
        this.previousID = this.currentID;
        this.currentIndex =
            this.currentIndex !== null
                ? wrapIndex(this.currentIndex + step, CONFIG.layoutOrder.length)
                : 0;
        this.currentID = CONFIG.layoutOrder[this.currentIndex];
        return this.loadLayout(this.currentID);
    };
    LayoutStoreEntry.prototype.setLayout = function (targetID) {
        var targetLayout = this.loadLayout(targetID);
        if (targetLayout instanceof MonocleLayout &&
            this.currentLayout instanceof MonocleLayout) {
            this.currentID = this.previousID;
            this.previousID = targetID;
        }
        else if (this.currentID !== targetID) {
            this.previousID = this.currentID;
            this.currentID = targetID;
        }
        this.updateCurrentIndex();
        return targetLayout;
    };
    LayoutStoreEntry.prototype.updateCurrentIndex = function () {
        var idx = CONFIG.layoutOrder.indexOf(this.currentID);
        this.currentIndex = idx === -1 ? null : idx;
    };
    LayoutStoreEntry.prototype.loadLayout = function (ID) {
        var layout = this.layouts[ID];
        if (!layout)
            layout = this.layouts[ID] = CONFIG.layoutFactories[ID]();
        return layout;
    };
    return LayoutStoreEntry;
}());
var LayoutStore = (function () {
    function LayoutStore() {
        this.store = {};
    }
    LayoutStore.prototype.getCurrentLayout = function (srf) {
        return srf.ignore
            ? FloatingLayout.instance
            : this.getEntry(srf.id).currentLayout;
    };
    LayoutStore.prototype.cycleLayout = function (srf, step) {
        if (srf.ignore)
            return null;
        return this.getEntry(srf.id).cycleLayout(step);
    };
    LayoutStore.prototype.setLayout = function (srf, layoutClassID) {
        if (srf.ignore)
            return null;
        return this.getEntry(srf.id).setLayout(layoutClassID);
    };
    LayoutStore.prototype.getEntry = function (key) {
        if (!this.store[key]) {
            var i1 = key.indexOf("@");
            var i2 = key.indexOf("#");
            var key_without_activity = key.slice(0, i1 + 1) + key.slice(i2);
            if (i1 > 0 && i2 > 0 && i2 - i1 > 1 && this.store[key_without_activity]) {
                this.store[key] = this.store[key_without_activity];
                delete this.store[key_without_activity];
            }
            else {
                var output_name = key.slice(0, key.indexOf("@"));
                var desktop_name = i2 !== -1 ? key.slice(i2 + 1) : undefined;
                this.store[key] = new LayoutStoreEntry(output_name, desktop_name);
            }
        }
        return this.store[key];
    };
    return LayoutStore;
}());
var WindowState;
(function (WindowState) {
    WindowState[WindowState["Unmanaged"] = 0] = "Unmanaged";
    WindowState[WindowState["NativeFullscreen"] = 1] = "NativeFullscreen";
    WindowState[WindowState["NativeMaximized"] = 2] = "NativeMaximized";
    WindowState[WindowState["Floating"] = 3] = "Floating";
    WindowState[WindowState["Maximized"] = 4] = "Maximized";
    WindowState[WindowState["Tiled"] = 5] = "Tiled";
    WindowState[WindowState["TiledAfloat"] = 6] = "TiledAfloat";
    WindowState[WindowState["Undecided"] = 7] = "Undecided";
})(WindowState || (WindowState = {}));
var WindowClass = (function () {
    function WindowClass(window) {
        this.id = window.id;
        this.window = window;
        this.floatGeometry = window.geometry;
        this.geometry = window.geometry;
        this.timestamp = 0;
        this.internalState = WindowState.Unmanaged;
        this.shouldCommitFloat = this.shouldFloat;
        this.weightMap = {};
    }
    WindowClass.isTileableState = function (state) {
        return (state === WindowState.Tiled ||
            state === WindowState.Maximized ||
            state === WindowState.TiledAfloat);
    };
    WindowClass.isTiledState = function (state) {
        return state === WindowState.Tiled || state === WindowState.Maximized;
    };
    WindowClass.isFloatingState = function (state) {
        return state === WindowState.Floating || state === WindowState.TiledAfloat;
    };
    Object.defineProperty(WindowClass.prototype, "actualGeometry", {
        get: function () {
            return this.window.geometry;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "shouldFloat", {
        get: function () {
            return this.window.shouldFloat;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "shouldIgnore", {
        get: function () {
            return this.window.shouldIgnore;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "tileable", {
        get: function () {
            return WindowClass.isTileableState(this.state);
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "tiled", {
        get: function () {
            return WindowClass.isTiledState(this.state);
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "floating", {
        get: function () {
            return WindowClass.isFloatingState(this.state);
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "geometryDelta", {
        get: function () {
            return RectDelta.fromRects(this.geometry, this.actualGeometry);
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "state", {
        get: function () {
            if (this.window.fullScreen)
                return WindowState.NativeFullscreen;
            if (this.window.maximized)
                return WindowState.NativeMaximized;
            return this.internalState;
        },
        set: function (value) {
            var state = this.state;
            if (state === value)
                return;
            if ((state === WindowState.Unmanaged || WindowClass.isTileableState(state)) &&
                WindowClass.isFloatingState(value))
                this.shouldCommitFloat = true;
            else if (WindowClass.isFloatingState(state) &&
                WindowClass.isTileableState(value))
                this.floatGeometry = this.actualGeometry;
            this.internalState = value;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "surface", {
        get: function () {
            return this.window.surface;
        },
        set: function (srf) {
            this.window.surface = srf;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(WindowClass.prototype, "weight", {
        get: function () {
            var srfID = this.window.surface.id;
            var weight = this.weightMap[srfID];
            if (weight === undefined) {
                this.weightMap[srfID] = 1.0;
                return 1.0;
            }
            return weight;
        },
        set: function (value) {
            var srfID = this.window.surface.id;
            this.weightMap[srfID] = value;
        },
        enumerable: false,
        configurable: true
    });
    WindowClass.prototype.commit = function () {
        var state = this.state;
        debugObj(function () { return ["Window#commit", { state: WindowState[state] }]; });
        switch (state) {
            case WindowState.NativeMaximized:
                this.window.commit(undefined, undefined, false);
                break;
            case WindowState.NativeFullscreen:
                this.window.commit(undefined, undefined, undefined);
                break;
            case WindowState.Floating:
                if (!this.shouldCommitFloat)
                    break;
                this.window.commit(this.floatGeometry, false, CONFIG.keepFloatAbove);
                this.shouldCommitFloat = false;
                break;
            case WindowState.Maximized:
                this.window.commit(this.geometry, true, false);
                break;
            case WindowState.Tiled:
                this.window.commit(this.geometry, CONFIG.noTileBorder, false);
                break;
            case WindowState.TiledAfloat:
                if (!this.shouldCommitFloat)
                    break;
                this.window.commit(this.floatGeometry, false, CONFIG.keepFloatAbove);
                this.shouldCommitFloat = false;
                break;
        }
    };
    WindowClass.prototype.forceSetGeometry = function (geometry) {
        this.window.commit(geometry);
    };
    WindowClass.prototype.visible = function (srf) {
        return this.window.visible(srf);
    };
    WindowClass.prototype.toString = function () {
        return "Window(" + String(this.window) + ")";
    };
    return WindowClass;
}());
var WindowStore = (function () {
    function WindowStore(windows) {
        this.list = windows || [];
    }
    WindowStore.prototype.move = function (srcWin, destWin, after) {
        var srcIdx = this.list.indexOf(srcWin);
        var destIdx = this.list.indexOf(destWin);
        if (srcIdx === -1 || destIdx === -1)
            return;
        this.list.splice(srcIdx, 1);
        this.list.splice(after ? destIdx + 1 : destIdx, 0, srcWin);
    };
    WindowStore.prototype.setMaster = function (window) {
        var idx = this.list.indexOf(window);
        if (idx === -1)
            return;
        this.list.splice(idx, 1);
        this.list.splice(0, 0, window);
    };
    WindowStore.prototype.swap = function (alpha, beta) {
        var alphaIndex = this.list.indexOf(alpha);
        var betaIndex = this.list.indexOf(beta);
        if (alphaIndex < 0 || betaIndex < 0)
            return;
        this.list[alphaIndex] = beta;
        this.list[betaIndex] = alpha;
    };
    Object.defineProperty(WindowStore.prototype, "length", {
        get: function () {
            return this.list.length;
        },
        enumerable: false,
        configurable: true
    });
    WindowStore.prototype.at = function (idx) {
        return this.list[idx];
    };
    WindowStore.prototype.indexOf = function (window) {
        return this.list.indexOf(window);
    };
    WindowStore.prototype.push = function (window) {
        this.list.push(window);
    };
    WindowStore.prototype.beside_first = function (window) {
        this.list.splice(1, 0, window);
    };
    WindowStore.prototype.remove = function (window) {
        var idx = this.list.indexOf(window);
        if (idx >= 0)
            this.list.splice(idx, 1);
    };
    WindowStore.prototype.unshift = function (window) {
        this.list.unshift(window);
    };
    WindowStore.prototype.getVisibleWindows = function (srf) {
        return this.list.filter(function (win) { return win.visible(srf); });
    };
    WindowStore.prototype.getVisibleTiles = function (srf) {
        return this.list.filter(function (win) { return win.tiled && win.visible(srf); });
    };
    WindowStore.prototype.getVisibleTileables = function (srf) {
        return this.list.filter(function (win) { return win.tileable && win.visible(srf); });
    };
    return WindowStore;
}());
var BTreeLayout = (function () {
    function BTreeLayout() {
        this.classID = BTreeLayout.id;
        this.parts = new HalfSplitLayoutPart(new FillLayoutPart(), new FillLayoutPart());
        this.parts.angle = 0;
        this.parts.gap = CONFIG.tileLayoutGap;
    }
    Object.defineProperty(BTreeLayout.prototype, "description", {
        get: function () {
            return "BTree";
        },
        enumerable: false,
        configurable: true
    });
    BTreeLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tileable) { return (tileable.state = WindowState.Tiled); });
        this.create_parts(tileables.length);
        var rectangles = this.parts.apply(area, tileables);
        rectangles.forEach(function (geometry, i) {
            tileables[i].geometry = geometry;
        });
    };
    BTreeLayout.prototype.create_parts = function (tiles_len) {
        var head = this.get_head();
        head.angle = 0;
        head.gap = CONFIG.tileLayoutGap;
        if (tiles_len > 2) {
            var level = Math.ceil(Math.log(tiles_len) * 1.442695);
            var level_capacity = Math.pow(2, (level - 1));
            var half_level_capacity = Math.pow(2, (level - 2));
            if (tiles_len > level_capacity + half_level_capacity) {
                head.primarySize = tiles_len - level_capacity;
            }
            else {
                head.primarySize = half_level_capacity;
            }
            this.build_binary_tree(head, level, 2, tiles_len);
        }
        this.parts = head;
    };
    BTreeLayout.prototype.build_binary_tree = function (head, max_level, current_level, tiles_len) {
        if (current_level <= max_level) {
            if (head.primarySize > 1) {
                var primary = this.get_head();
                primary.primarySize = Math.floor(head.primarySize / 2);
                primary.gap = CONFIG.tileLayoutGap;
                primary.angle = current_level % 2 ? 0 : 90;
                head.primary = primary;
                this.build_binary_tree(primary, max_level, current_level + 1, head.primarySize);
            }
            if (tiles_len - head.primarySize > 1) {
                var secondary = this.get_head();
                secondary.primarySize = Math.floor((tiles_len - head.primarySize) / 2);
                secondary.gap = CONFIG.tileLayoutGap;
                secondary.angle = current_level % 2 ? 0 : 90;
                head.secondary = secondary;
                this.build_binary_tree(secondary, max_level, current_level + 1, tiles_len - head.primarySize);
            }
        }
    };
    BTreeLayout.prototype.get_head = function () {
        return new HalfSplitLayoutPart(new FillLayoutPart(), new FillLayoutPart());
    };
    BTreeLayout.prototype.clone = function () {
        var other = new StackedLayout();
        return other;
    };
    BTreeLayout.prototype.toString = function () {
        return "BTreeLayout()";
    };
    BTreeLayout.id = "BTreeLayout";
    return BTreeLayout;
}());
var CascadeDirection;
(function (CascadeDirection) {
    CascadeDirection[CascadeDirection["NorthWest"] = 0] = "NorthWest";
    CascadeDirection[CascadeDirection["North"] = 1] = "North";
    CascadeDirection[CascadeDirection["NorthEast"] = 2] = "NorthEast";
    CascadeDirection[CascadeDirection["East"] = 3] = "East";
    CascadeDirection[CascadeDirection["SouthEast"] = 4] = "SouthEast";
    CascadeDirection[CascadeDirection["South"] = 5] = "South";
    CascadeDirection[CascadeDirection["SouthWest"] = 6] = "SouthWest";
    CascadeDirection[CascadeDirection["West"] = 7] = "West";
})(CascadeDirection || (CascadeDirection = {}));
var CascadeLayout = (function () {
    function CascadeLayout(dir) {
        if (dir === void 0) { dir = CascadeDirection.SouthEast; }
        this.dir = dir;
        this.classID = CascadeLayout.id;
    }
    CascadeLayout.decomposeDirection = function (dir) {
        switch (dir) {
            case CascadeDirection.NorthWest:
                return [-1, -1];
            case CascadeDirection.North:
                return [-1, 0];
            case CascadeDirection.NorthEast:
                return [-1, 1];
            case CascadeDirection.East:
                return [0, 1];
            case CascadeDirection.SouthEast:
                return [1, 1];
            case CascadeDirection.South:
                return [1, 0];
            case CascadeDirection.SouthWest:
                return [1, -1];
            case CascadeDirection.West:
                return [0, -1];
        }
    };
    Object.defineProperty(CascadeLayout.prototype, "description", {
        get: function () {
            return "Cascade [" + CascadeDirection[this.dir] + "]";
        },
        enumerable: false,
        configurable: true
    });
    CascadeLayout.prototype.apply = function (ctx, tileables, area) {
        var _a = CascadeLayout.decomposeDirection(this.dir), vertStep = _a[0], horzStep = _a[1];
        var stepSize = 25;
        var windowWidth = horzStep !== 0
            ? area.width - stepSize * (tileables.length - 1)
            : area.width;
        var windowHeight = vertStep !== 0
            ? area.height - stepSize * (tileables.length - 1)
            : area.height;
        var baseX = horzStep >= 0 ? area.x : area.maxX - windowWidth;
        var baseY = vertStep >= 0 ? area.y : area.maxY - windowHeight;
        var x = baseX, y = baseY;
        tileables.forEach(function (tile) {
            tile.state = WindowState.Tiled;
            tile.geometry = new Rect(x, y, windowWidth, windowHeight);
            x += horzStep * stepSize;
            y += vertStep * stepSize;
        });
    };
    CascadeLayout.prototype.clone = function () {
        return new CascadeLayout(this.dir);
    };
    CascadeLayout.prototype.handleShortcut = function (ctx, input, data) {
        switch (input) {
            case Shortcut.Increase:
                this.dir = (this.dir + 1 + 8) % 8;
                ctx.showNotification(this.description);
                break;
            case Shortcut.Decrease:
                this.dir = (this.dir - 1 + 8) % 8;
                ctx.showNotification(this.description);
                break;
            default:
                return false;
        }
        return true;
    };
    CascadeLayout.id = "CascadeLayout";
    return CascadeLayout;
}());
var FloatingLayout = (function () {
    function FloatingLayout() {
        this.classID = FloatingLayout.id;
        this.description = "Floating";
    }
    FloatingLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tileable) { return (tileable.state = WindowState.TiledAfloat); });
    };
    FloatingLayout.prototype.clone = function () {
        return this;
    };
    FloatingLayout.prototype.toString = function () {
        return "FloatingLayout()";
    };
    FloatingLayout.id = "FloatingLayout ";
    FloatingLayout.instance = new FloatingLayout();
    return FloatingLayout;
}());
var FillLayoutPart = (function () {
    function FillLayoutPart() {
    }
    FillLayoutPart.prototype.adjust = function (area, tiles, basis, delta) {
        return delta;
    };
    FillLayoutPart.prototype.apply = function (area, tiles) {
        return tiles.map(function (tile) {
            return area;
        });
    };
    FillLayoutPart.prototype.toString = function () {
        return "FillLayoutPart";
    };
    return FillLayoutPart;
}());
var HalfSplitLayoutPart = (function () {
    function HalfSplitLayoutPart(primary, secondary) {
        this.primary = primary;
        this.secondary = secondary;
        this.angle = 0;
        this.gap = 0;
        this.primarySize = 1;
        this.ratio = 0.5;
    }
    Object.defineProperty(HalfSplitLayoutPart.prototype, "horizontal", {
        get: function () {
            return this.angle === 0 || this.angle === 180;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(HalfSplitLayoutPart.prototype, "reversed", {
        get: function () {
            return this.angle === 180 || this.angle === 270;
        },
        enumerable: false,
        configurable: true
    });
    HalfSplitLayoutPart.prototype.adjust = function (area, tiles, basis, delta) {
        var basisIndex = tiles.indexOf(basis);
        if (basisIndex < 0)
            return delta;
        if (tiles.length <= this.primarySize) {
            return this.primary.adjust(area, tiles, basis, delta);
        }
        else if (this.primarySize === 0) {
            return this.secondary.adjust(area, tiles, basis, delta);
        }
        else {
            var targetIndex = basisIndex < this.primarySize ? 0 : 1;
            if (targetIndex === 0) {
                delta = this.primary.adjust(area, tiles.slice(0, this.primarySize), basis, delta);
            }
            else {
                delta = this.secondary.adjust(area, tiles.slice(this.primarySize), basis, delta);
            }
            this.ratio = LayoutUtils.adjustAreaHalfWeights(area, this.reversed ? 1 - this.ratio : this.ratio, this.gap, this.reversed ? 1 - targetIndex : targetIndex, delta, this.horizontal);
            if (this.reversed)
                this.ratio = 1 - this.ratio;
            switch (this.angle * 10 + targetIndex + 1) {
                case 1:
                case 1802:
                    return new RectDelta(0, delta.west, delta.south, delta.north);
                case 2:
                case 1801:
                    return new RectDelta(delta.east, 0, delta.south, delta.north);
                case 901:
                case 2702:
                    return new RectDelta(delta.east, delta.west, 0, delta.north);
                case 902:
                case 2701:
                    return new RectDelta(delta.east, delta.west, delta.south, 0);
            }
            return delta;
        }
    };
    HalfSplitLayoutPart.prototype.toString = function () {
        return "<HalfSplitLayout: angle:".concat(this.angle, ",ratio:").concat(this.ratio, ",pr_size:").concat(this.primarySize, ".<<<Primary:").concat(this.primary, "---Secondary:").concat(this.secondary, ">>>");
    };
    HalfSplitLayoutPart.prototype.apply = function (area, tiles) {
        if (tiles.length <= this.primarySize) {
            return this.primary.apply(area, tiles);
        }
        else if (this.primarySize === 0) {
            return this.secondary.apply(area, tiles);
        }
        else {
            var reversed = this.reversed;
            var ratio = reversed ? 1 - this.ratio : this.ratio;
            var _a = LayoutUtils.splitAreaHalfWeighted(area, ratio, this.gap, this.horizontal), area1 = _a[0], area2 = _a[1];
            var result1 = this.primary.apply(reversed ? area2 : area1, tiles.slice(0, this.primarySize));
            var result2 = this.secondary.apply(reversed ? area1 : area2, tiles.slice(this.primarySize));
            return result1.concat(result2);
        }
    };
    return HalfSplitLayoutPart;
}());
var StackLayoutPart = (function () {
    function StackLayoutPart() {
        this.gap = 0;
    }
    StackLayoutPart.prototype.adjust = function (area, tiles, basis, delta) {
        var weights = LayoutUtils.adjustAreaWeights(area, tiles.map(function (tile) { return tile.weight; }), CONFIG.tileLayoutGap, tiles.indexOf(basis), delta, false);
        weights.forEach(function (weight, i) {
            tiles[i].weight = weight * tiles.length;
        });
        var idx = tiles.indexOf(basis);
        return new RectDelta(delta.east, delta.west, idx === tiles.length - 1 ? delta.south : 0, idx === 0 ? delta.north : 0);
    };
    StackLayoutPart.prototype.apply = function (area, tiles) {
        var weights = tiles.map(function (tile) { return tile.weight; });
        return LayoutUtils.splitAreaWeighted(area, weights, this.gap);
    };
    return StackLayoutPart;
}());
var RotateLayoutPart = (function () {
    function RotateLayoutPart(inner, angle) {
        if (angle === void 0) { angle = 0; }
        this.inner = inner;
        this.angle = angle;
    }
    RotateLayoutPart.prototype.adjust = function (area, tiles, basis, delta) {
        switch (this.angle) {
            case 0:
                break;
            case 90:
                area = new Rect(area.y, area.x, area.height, area.width);
                delta = new RectDelta(delta.south, delta.north, delta.east, delta.west);
                break;
            case 180:
                delta = new RectDelta(delta.west, delta.east, delta.south, delta.north);
                break;
            case 270:
                area = new Rect(area.y, area.x, area.height, area.width);
                delta = new RectDelta(delta.north, delta.south, delta.east, delta.west);
                break;
        }
        delta = this.inner.adjust(area, tiles, basis, delta);
        switch (this.angle) {
            case 0:
                delta = delta;
                break;
            case 90:
                delta = new RectDelta(delta.south, delta.north, delta.east, delta.west);
                break;
            case 180:
                delta = new RectDelta(delta.west, delta.east, delta.south, delta.north);
                break;
            case 270:
                delta = new RectDelta(delta.north, delta.south, delta.east, delta.west);
                break;
        }
        return delta;
    };
    RotateLayoutPart.prototype.apply = function (area, tiles) {
        switch (this.angle) {
            case 0:
                break;
            case 90:
                area = new Rect(area.y, area.x, area.height, area.width);
                break;
            case 180:
                break;
            case 270:
                area = new Rect(area.y, area.x, area.height, area.width);
                break;
        }
        var innerResult = this.inner.apply(area, tiles);
        switch (this.angle) {
            case 0:
                return innerResult;
            case 90:
                return innerResult.map(function (g) { return new Rect(g.y, g.x, g.height, g.width); });
            case 180:
                return innerResult.map(function (g) {
                    var rx = g.x - area.x;
                    var newX = area.x + area.width - (rx + g.width);
                    return new Rect(newX, g.y, g.width, g.height);
                });
            case 270:
                return innerResult.map(function (g) {
                    var rx = g.x - area.x;
                    var newY = area.x + area.width - (rx + g.width);
                    return new Rect(g.y, newY, g.height, g.width);
                });
        }
    };
    RotateLayoutPart.prototype.rotate = function (amount) {
        var angle = this.angle + amount;
        if (angle < 0)
            angle = 270;
        else if (angle >= 360)
            angle = 0;
        this.angle = angle;
    };
    return RotateLayoutPart;
}());
var LayoutUtils = (function () {
    function LayoutUtils() {
    }
    LayoutUtils.splitWeighted = function (_a, weights, gap) {
        var begin = _a[0], length = _a[1];
        gap = gap !== undefined ? gap : 0;
        var n = weights.length;
        var actualLength = length - (n - 1) * gap;
        var weightSum = weights.reduce(function (sum, weight) { return sum + weight; }, 0);
        var weightAcc = 0;
        return weights.map(function (weight, i) {
            var partBegin = (actualLength * weightAcc) / weightSum + i * gap;
            var partLength = (actualLength * weight) / weightSum;
            weightAcc += weight;
            return [begin + Math.floor(partBegin), Math.floor(partLength)];
        });
    };
    LayoutUtils.splitAreaWeighted = function (area, weights, gap, horizontal) {
        gap = gap !== undefined ? gap : 0;
        horizontal = horizontal !== undefined ? horizontal : false;
        var line = horizontal
            ? [area.x, area.width]
            : [area.y, area.height];
        var parts = LayoutUtils.splitWeighted(line, weights, gap);
        return parts.map(function (_a) {
            var begin = _a[0], length = _a[1];
            return horizontal
                ? new Rect(begin, area.y, length, area.height)
                : new Rect(area.x, begin, area.width, length);
        });
    };
    LayoutUtils.splitAreaHalfWeighted = function (area, weight, gap, horizontal) {
        return LayoutUtils.splitAreaWeighted(area, [weight, 1 - weight], gap, horizontal);
    };
    LayoutUtils.adjustWeights = function (_a, weights, gap, target, deltaFw, deltaBw) {
        var begin = _a[0], length = _a[1];
        var minLength = 1;
        var parts = this.splitWeighted([begin, length], weights, gap);
        var _b = parts[target], targetBase = _b[0], targetLength = _b[1];
        if (target > 0 && deltaBw !== 0) {
            var neighbor = target - 1;
            var _c = parts[neighbor], neighborBase = _c[0], neighborLength = _c[1];
            var delta = clip(deltaBw, minLength - targetLength, neighborLength - minLength);
            parts[target] = [targetBase - delta, targetLength + delta];
            parts[neighbor] = [neighborBase, neighborLength - delta];
        }
        if (target < parts.length - 1 && deltaFw !== 0) {
            var neighbor = target + 1;
            var _d = parts[neighbor], neighborBase = _d[0], neighborLength = _d[1];
            var delta = clip(deltaFw, minLength - targetLength, neighborLength - minLength);
            parts[target] = [targetBase, targetLength + delta];
            parts[neighbor] = [neighborBase + delta, neighborLength - delta];
        }
        return LayoutUtils.calculateWeights(parts);
    };
    LayoutUtils.adjustAreaWeights = function (area, weights, gap, target, delta, horizontal) {
        var line = horizontal
            ? [area.x, area.width]
            : [area.y, area.height];
        var _a = horizontal
            ? [delta.east, delta.west]
            : [delta.south, delta.north], deltaFw = _a[0], deltaBw = _a[1];
        return LayoutUtils.adjustWeights(line, weights, gap, target, deltaFw, deltaBw);
    };
    LayoutUtils.adjustAreaHalfWeights = function (area, weight, gap, target, delta, horizontal) {
        var weights = [weight, 1 - weight];
        var newWeights = LayoutUtils.adjustAreaWeights(area, weights, gap, target, delta, horizontal);
        return newWeights[0];
    };
    LayoutUtils.calculateWeights = function (parts) {
        var totalLength = parts.reduce(function (acc, _a) {
            var base = _a[0], length = _a[1];
            return acc + length;
        }, 0);
        return parts.map(function (_a) {
            var base = _a[0], length = _a[1];
            return length / totalLength;
        });
    };
    LayoutUtils.calculateAreaWeights = function (area, geometries, gap, horizontal) {
        gap = gap !== undefined ? gap : 0;
        horizontal = horizontal !== undefined ? horizontal : false;
        var line = horizontal ? area.width : area.height;
        var parts = horizontal
            ? geometries.map(function (geometry) { return [geometry.x, geometry.width]; })
            : geometries.map(function (geometry) { return [geometry.y, geometry.height]; });
        return LayoutUtils.calculateWeights(parts);
    };
    return LayoutUtils;
}());
var MonocleLayout = (function () {
    function MonocleLayout() {
        this.description = "Monocle";
        this.classID = MonocleLayout.id;
    }
    MonocleLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tile) {
            tile.state = CONFIG.monocleMaximize
                ? WindowState.Maximized
                : WindowState.Tiled;
            tile.geometry = area;
        });
        if (ctx.backend === KWinDriver.backendName &&
            KWINCONFIG.monocleMinimizeRest) {
            var tiles_1 = __spreadArray([], tileables, true);
            ctx.setTimeout(function () {
                var current = ctx.currentWindow;
                if (current && current.tiled) {
                    tiles_1.forEach(function (window) {
                        if (window !== current)
                            window.window.window.minimized = true;
                    });
                }
            }, 50);
        }
    };
    MonocleLayout.prototype.clone = function () {
        return this;
    };
    MonocleLayout.prototype.handleShortcut = function (ctx, input, data) {
        switch (input) {
            case Shortcut.DWMLeft:
            case Shortcut.FocusNext:
            case Shortcut.FocusUp:
            case Shortcut.FocusLeft:
                ctx.cycleFocus(-1);
                return true;
            case Shortcut.DWMRight:
            case Shortcut.FocusPrev:
            case Shortcut.FocusDown:
            case Shortcut.FocusRight:
                ctx.cycleFocus(1);
                return true;
            default:
                return false;
        }
    };
    MonocleLayout.prototype.toString = function () {
        return "MonocleLayout()";
    };
    MonocleLayout.id = "MonocleLayout";
    return MonocleLayout;
}());
var QuarterLayout = (function () {
    function QuarterLayout() {
        this.classID = QuarterLayout.id;
        this.description = "Quarter";
        this.lhsplit = 0.5;
        this.rhsplit = 0.5;
        this.vsplit = 0.5;
    }
    Object.defineProperty(QuarterLayout.prototype, "capacity", {
        get: function () {
            return 4;
        },
        enumerable: false,
        configurable: true
    });
    QuarterLayout.prototype.adjust = function (area, tiles, basis, delta) {
        if (tiles.length <= 1 || tiles.length > 4)
            return;
        var idx = tiles.indexOf(basis);
        if (idx < 0)
            return;
        if ((idx === 0 || idx === 3) && delta.east !== 0)
            this.vsplit =
                (Math.floor(area.width * this.vsplit) + delta.east) / area.width;
        else if ((idx === 1 || idx === 2) && delta.west !== 0)
            this.vsplit =
                (Math.floor(area.width * this.vsplit) - delta.west) / area.width;
        if (tiles.length === 4) {
            if (idx === 0 && delta.south !== 0)
                this.lhsplit =
                    (Math.floor(area.height * this.lhsplit) + delta.south) / area.height;
            if (idx === 3 && delta.north !== 0)
                this.lhsplit =
                    (Math.floor(area.height * this.lhsplit) - delta.north) / area.height;
        }
        if (tiles.length >= 3) {
            if (idx === 1 && delta.south !== 0)
                this.rhsplit =
                    (Math.floor(area.height * this.rhsplit) + delta.south) / area.height;
            if (idx === 2 && delta.north !== 0)
                this.rhsplit =
                    (Math.floor(area.height * this.rhsplit) - delta.north) / area.height;
        }
        this.vsplit = clip(this.vsplit, 1 - QuarterLayout.MAX_PROPORTION, QuarterLayout.MAX_PROPORTION);
        this.lhsplit = clip(this.lhsplit, 1 - QuarterLayout.MAX_PROPORTION, QuarterLayout.MAX_PROPORTION);
        this.rhsplit = clip(this.rhsplit, 1 - QuarterLayout.MAX_PROPORTION, QuarterLayout.MAX_PROPORTION);
    };
    QuarterLayout.prototype.clone = function () {
        var other = new QuarterLayout();
        other.lhsplit = this.lhsplit;
        other.rhsplit = this.rhsplit;
        other.vsplit = this.vsplit;
        return other;
    };
    QuarterLayout.prototype.apply = function (ctx, tileables, area) {
        for (var i = 0; i < 4 && i < tileables.length; i++)
            tileables[i].state = WindowState.Tiled;
        if (tileables.length > 4)
            tileables
                .slice(4)
                .forEach(function (tile) { return (tile.state = WindowState.TiledAfloat); });
        if (tileables.length === 1) {
            tileables[0].geometry = area;
            return;
        }
        var gap1 = Math.floor(CONFIG.tileLayoutGap / 2);
        var gap2 = CONFIG.tileLayoutGap - gap1;
        var leftWidth = Math.floor(area.width * this.vsplit);
        var rightWidth = area.width - leftWidth;
        var rightX = area.x + leftWidth;
        if (tileables.length === 2) {
            tileables[0].geometry = new Rect(area.x, area.y, leftWidth, area.height).gap(0, gap1, 0, 0);
            tileables[1].geometry = new Rect(rightX, area.y, rightWidth, area.height).gap(gap2, 0, 0, 0);
            return;
        }
        var rightTopHeight = Math.floor(area.height * this.rhsplit);
        var rightBottomHeight = area.height - rightTopHeight;
        var rightBottomY = area.y + rightTopHeight;
        if (tileables.length === 3) {
            tileables[0].geometry = new Rect(area.x, area.y, leftWidth, area.height).gap(0, gap1, 0, 0);
            tileables[1].geometry = new Rect(rightX, area.y, rightWidth, rightTopHeight).gap(gap2, 0, 0, gap1);
            tileables[2].geometry = new Rect(rightX, rightBottomY, rightWidth, rightBottomHeight).gap(gap2, 0, gap2, 0);
            return;
        }
        var leftTopHeight = Math.floor(area.height * this.lhsplit);
        var leftBottomHeight = area.height - leftTopHeight;
        var leftBottomY = area.y + leftTopHeight;
        if (tileables.length >= 4) {
            tileables[0].geometry = new Rect(area.x, area.y, leftWidth, leftTopHeight).gap(0, gap1, 0, gap1);
            tileables[1].geometry = new Rect(rightX, area.y, rightWidth, rightTopHeight).gap(gap2, 0, 0, gap1);
            tileables[2].geometry = new Rect(rightX, rightBottomY, rightWidth, rightBottomHeight).gap(gap2, 0, gap2, 0);
            tileables[3].geometry = new Rect(area.x, leftBottomY, leftWidth, leftBottomHeight).gap(0, gap2, gap2, 0);
        }
    };
    QuarterLayout.prototype.toString = function () {
        return "QuarterLayout()";
    };
    QuarterLayout.MAX_PROPORTION = 0.8;
    QuarterLayout.id = "QuarterLayout";
    return QuarterLayout;
}());
var SpiralLayout = (function () {
    function SpiralLayout() {
        this.description = "Spiral";
        this.classID = SpiralLayout.id;
        this.depth = 1;
        this.parts = new HalfSplitLayoutPart(new FillLayoutPart(), new FillLayoutPart());
        this.parts.angle = 0;
        this.parts.gap = CONFIG.tileLayoutGap;
    }
    SpiralLayout.prototype.adjust = function (area, tiles, basis, delta) {
        this.parts.adjust(area, tiles, basis, delta);
    };
    SpiralLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tileable) { return (tileable.state = WindowState.Tiled); });
        this.bore(tileables.length);
        this.parts.apply(area, tileables).forEach(function (geometry, i) {
            tileables[i].geometry = geometry;
        });
    };
    SpiralLayout.prototype.toString = function () {
        return "Spiral()";
    };
    SpiralLayout.prototype.bore = function (depth) {
        if (this.depth >= depth)
            return;
        var hpart = this.parts;
        var i;
        for (i = 0; i < this.depth - 1; i++) {
            hpart = hpart.secondary;
        }
        var lastFillPart = hpart.secondary;
        var npart;
        while (i < depth - 1) {
            npart = new HalfSplitLayoutPart(new FillLayoutPart(), lastFillPart);
            npart.gap = CONFIG.tileLayoutGap;
            switch ((i + 1) % 4) {
                case 0:
                    npart.angle = 0;
                    break;
                case 1:
                    npart.angle = 90;
                    break;
                case 2:
                    npart.angle = 180;
                    break;
                case 3:
                    npart.angle = 270;
                    break;
            }
            hpart.secondary = npart;
            hpart = npart;
            i++;
        }
        this.depth = depth;
    };
    SpiralLayout.id = "SpiralLayout";
    return SpiralLayout;
}());
var SpreadLayout = (function () {
    function SpreadLayout() {
        this.classID = SpreadLayout.id;
        this.description = "Spread";
        this.space = 0.07;
    }
    SpreadLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tileable) { return (tileable.state = WindowState.Tiled); });
        var tiles = tileables;
        var numTiles = tiles.length;
        var spaceWidth = Math.floor(area.width * this.space);
        var cardWidth = area.width - spaceWidth * (numTiles - 1);
        var miniumCardWidth = area.width * 0.4;
        while (cardWidth < miniumCardWidth) {
            cardWidth += spaceWidth;
            numTiles -= 1;
        }
        for (var i = 0; i < tiles.length; i++)
            tiles[i].geometry = new Rect(area.x + (i < numTiles ? spaceWidth * (numTiles - i - 1) : 0), area.y, cardWidth, area.height);
    };
    SpreadLayout.prototype.clone = function () {
        var other = new SpreadLayout();
        other.space = this.space;
        return other;
    };
    SpreadLayout.prototype.handleShortcut = function (ctx, input) {
        switch (input) {
            case Shortcut.Decrease:
                this.space = Math.max(0.04, this.space - 0.01);
                break;
            case Shortcut.Increase:
                this.space = Math.min(0.1, this.space + 0.01);
                break;
            default:
                return false;
        }
        return true;
    };
    SpreadLayout.prototype.toString = function () {
        return "SpreadLayout(" + this.space + ")";
    };
    SpreadLayout.id = "SpreadLayout";
    return SpreadLayout;
}());
var StackedLayout = (function () {
    function StackedLayout() {
        this.classID = StackedLayout.id;
        this.parts = new RotateLayoutPart(new HalfSplitLayoutPart(new StackLayoutPart(), new StackLayoutPart()));
        var masterPart = this.parts.inner;
        masterPart.gap =
            masterPart.secondary.gap =
                CONFIG.tileLayoutGap;
    }
    Object.defineProperty(StackedLayout.prototype, "description", {
        get: function () {
            return "Stacked";
        },
        enumerable: false,
        configurable: true
    });
    StackedLayout.prototype.adjust = function (area, tiles, basis, delta) {
        this.parts.adjust(area, tiles, basis, delta);
    };
    StackedLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tileable) { return (tileable.state = WindowState.Tiled); });
        if (tileables.length > 1) {
            this.parts.inner.angle = 90;
        }
        this.parts.apply(area, tileables).forEach(function (geometry, i) {
            tileables[i].geometry = geometry;
        });
    };
    StackedLayout.prototype.clone = function () {
        var other = new StackedLayout();
        return other;
    };
    StackedLayout.prototype.handleShortcut = function (ctx, input) {
        switch (input) {
            case Shortcut.Rotate:
                this.parts.rotate(90);
                break;
            default:
                return false;
        }
        return true;
    };
    StackedLayout.prototype.toString = function () {
        return ("StackedLayout()");
    };
    StackedLayout.id = "StackedLayout";
    return StackedLayout;
}());
var StairLayout = (function () {
    function StairLayout() {
        this.classID = StairLayout.id;
        this.description = "Stair";
        this.space = 24;
    }
    StairLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tileable) { return (tileable.state = WindowState.Tiled); });
        var tiles = tileables;
        var len = tiles.length;
        var space = this.space;
        var alignRight = Number(!KWINCONFIG.stairReverse);
        for (var i = 0; i < len; i++) {
            var dx = space * (len - i - 1);
            var dy = space * i;
            tiles[i].geometry = new Rect(area.x + alignRight * dx, area.y + dy, area.width - dx, area.height - dy);
        }
    };
    StairLayout.prototype.clone = function () {
        var other = new StairLayout();
        other.space = this.space;
        return other;
    };
    StairLayout.prototype.handleShortcut = function (ctx, input) {
        switch (input) {
            case Shortcut.Decrease:
                this.space = Math.max(16, this.space - 8);
                break;
            case Shortcut.Increase:
                this.space = Math.min(160, this.space + 8);
                break;
            default:
                return false;
        }
        return true;
    };
    StairLayout.prototype.toString = function () {
        return "StairLayout(" + this.space + ")";
    };
    StairLayout.id = "StairLayout";
    return StairLayout;
}());
var ThreeColumnLayout = (function () {
    function ThreeColumnLayout() {
        this.classID = ThreeColumnLayout.id;
        this.masterRatio = 0.6;
        this.masterSize = 1;
    }
    Object.defineProperty(ThreeColumnLayout.prototype, "description", {
        get: function () {
            return "Three-Column [" + this.masterSize + "]";
        },
        enumerable: false,
        configurable: true
    });
    ThreeColumnLayout.prototype.adjust = function (area, tiles, basis, delta) {
        var basisIndex = tiles.indexOf(basis);
        if (basisIndex < 0)
            return;
        if (tiles.length === 0)
            return;
        else if (tiles.length <= this.masterSize) {
            LayoutUtils.adjustAreaWeights(area, tiles.map(function (tile) { return tile.weight; }), CONFIG.tileLayoutGap, tiles.indexOf(basis), delta).forEach(function (newWeight, i) { return (tiles[i].weight = newWeight * tiles.length); });
        }
        else if (tiles.length === this.masterSize + 1) {
            this.masterRatio = LayoutUtils.adjustAreaHalfWeights(area, this.masterRatio, CONFIG.tileLayoutGap, basisIndex < this.masterSize ? 0 : 1, delta, true);
            if (basisIndex < this.masterSize) {
                var masterTiles_1 = tiles.slice(0, -1);
                LayoutUtils.adjustAreaWeights(area, masterTiles_1.map(function (tile) { return tile.weight; }), CONFIG.tileLayoutGap, basisIndex, delta).forEach(function (newWeight, i) {
                    return (masterTiles_1[i].weight = newWeight * masterTiles_1.length);
                });
            }
        }
        else if (tiles.length > this.masterSize + 1) {
            var basisGroup = void 0;
            if (basisIndex < this.masterSize)
                basisGroup = 1;
            else if (basisIndex < Math.floor((this.masterSize + tiles.length) / 2))
                basisGroup = 2;
            else
                basisGroup = 0;
            var stackRatio = 1 - this.masterRatio;
            var newRatios = LayoutUtils.adjustAreaWeights(area, [stackRatio, this.masterRatio, stackRatio], CONFIG.tileLayoutGap, basisGroup, delta, true);
            var newMasterRatio = newRatios[1];
            var newStackRatio = basisGroup === 0 ? newRatios[0] : newRatios[2];
            this.masterRatio = newMasterRatio / (newMasterRatio + newStackRatio);
            var rstackNumTile = Math.floor((tiles.length - this.masterSize) / 2);
            var _a = partitionArrayBySizes(tiles, [
                this.masterSize,
                rstackNumTile,
            ]), masterTiles = _a[0], rstackTiles = _a[1], lstackTiles = _a[2];
            var groupTiles_1 = [lstackTiles, masterTiles, rstackTiles][basisGroup];
            LayoutUtils.adjustAreaWeights(area, groupTiles_1.map(function (tile) { return tile.weight; }), CONFIG.tileLayoutGap, groupTiles_1.indexOf(basis), delta).forEach(function (newWeight, i) { return (groupTiles_1[i].weight = newWeight * groupTiles_1.length); });
        }
    };
    ThreeColumnLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tileable) { return (tileable.state = WindowState.Tiled); });
        var tiles = tileables;
        if (tiles.length <= this.masterSize) {
            LayoutUtils.splitAreaWeighted(area, tiles.map(function (tile) { return tile.weight; }), CONFIG.tileLayoutGap).forEach(function (tileArea, i) { return (tiles[i].geometry = tileArea); });
        }
        else if (tiles.length === this.masterSize + 1) {
            var _a = LayoutUtils.splitAreaHalfWeighted(area, this.masterRatio, CONFIG.tileLayoutGap, true), masterArea = _a[0], stackArea = _a[1];
            var masterTiles_2 = tiles.slice(0, this.masterSize);
            LayoutUtils.splitAreaWeighted(masterArea, masterTiles_2.map(function (tile) { return tile.weight; }), CONFIG.tileLayoutGap).forEach(function (tileArea, i) { return (masterTiles_2[i].geometry = tileArea); });
            tiles[tiles.length - 1].geometry = stackArea;
        }
        else if (tiles.length > this.masterSize + 1) {
            var stackRatio = 1 - this.masterRatio;
            var groupAreas_1 = LayoutUtils.splitAreaWeighted(area, [stackRatio, this.masterRatio, stackRatio], CONFIG.tileLayoutGap, true);
            var rstackSize = Math.floor((tiles.length - this.masterSize) / 2);
            var _b = partitionArrayBySizes(tiles, [
                this.masterSize,
                rstackSize,
            ]), masterTiles = _b[0], rstackTiles = _b[1], lstackTiles = _b[2];
            [lstackTiles, masterTiles, rstackTiles].forEach(function (groupTiles, group) {
                LayoutUtils.splitAreaWeighted(groupAreas_1[group], groupTiles.map(function (tile) { return tile.weight; }), CONFIG.tileLayoutGap).forEach(function (tileArea, i) { return (groupTiles[i].geometry = tileArea); });
            });
        }
    };
    ThreeColumnLayout.prototype.clone = function () {
        var other = new ThreeColumnLayout();
        other.masterRatio = this.masterRatio;
        other.masterSize = this.masterSize;
        return other;
    };
    ThreeColumnLayout.prototype.handleShortcut = function (ctx, input, data) {
        switch (input) {
            case Shortcut.Increase:
                this.resizeMaster(ctx, +1);
                return true;
            case Shortcut.Decrease:
                this.resizeMaster(ctx, -1);
                return true;
            case Shortcut.DWMLeft:
                this.masterRatio = clip(slide(this.masterRatio, -0.05), ThreeColumnLayout.MIN_MASTER_RATIO, ThreeColumnLayout.MAX_MASTER_RATIO);
                return true;
            case Shortcut.DWMRight:
                this.masterRatio = clip(slide(this.masterRatio, +0.05), ThreeColumnLayout.MIN_MASTER_RATIO, ThreeColumnLayout.MAX_MASTER_RATIO);
                return true;
            default:
                return false;
        }
    };
    ThreeColumnLayout.prototype.toString = function () {
        return "ThreeColumnLayout(nmaster=" + this.masterSize + ")";
    };
    ThreeColumnLayout.prototype.resizeMaster = function (ctx, step) {
        this.masterSize = clip(this.masterSize + step, 1, 10);
        ctx.showNotification(this.description);
    };
    ThreeColumnLayout.MIN_MASTER_RATIO = 0.2;
    ThreeColumnLayout.MAX_MASTER_RATIO = 0.75;
    ThreeColumnLayout.id = "ThreeColumnLayout";
    return ThreeColumnLayout;
}());
var TileLayout = (function () {
    function TileLayout() {
        this.classID = TileLayout.id;
        this.parts = new RotateLayoutPart(new HalfSplitLayoutPart(new RotateLayoutPart(new StackLayoutPart()), new StackLayoutPart()));
        var masterPart = this.parts.inner;
        masterPart.gap =
            masterPart.primary.inner.gap =
                masterPart.secondary.gap =
                    CONFIG.tileLayoutGap;
    }
    Object.defineProperty(TileLayout.prototype, "description", {
        get: function () {
            return "Tile [" + this.numMaster + "]";
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(TileLayout.prototype, "numMaster", {
        get: function () {
            return this.parts.inner.primarySize;
        },
        set: function (value) {
            this.parts.inner.primarySize = value;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(TileLayout.prototype, "masterRatio", {
        get: function () {
            return this.parts.inner.ratio;
        },
        set: function (value) {
            this.parts.inner.ratio = value;
        },
        enumerable: false,
        configurable: true
    });
    TileLayout.prototype.adjust = function (area, tiles, basis, delta) {
        this.parts.adjust(area, tiles, basis, delta);
    };
    TileLayout.prototype.apply = function (ctx, tileables, area) {
        tileables.forEach(function (tileable) { return (tileable.state = WindowState.Tiled); });
        this.parts.apply(area, tileables).forEach(function (geometry, i) {
            tileables[i].geometry = geometry;
        });
    };
    TileLayout.prototype.clone = function () {
        var other = new TileLayout();
        other.masterRatio = this.masterRatio;
        other.numMaster = this.numMaster;
        return other;
    };
    TileLayout.prototype.handleShortcut = function (ctx, input) {
        switch (input) {
            case Shortcut.DWMLeft:
                this.masterRatio = clip(slide(this.masterRatio, -0.05), TileLayout.MIN_MASTER_RATIO, TileLayout.MAX_MASTER_RATIO);
                break;
            case Shortcut.DWMRight:
                this.masterRatio = clip(slide(this.masterRatio, +0.05), TileLayout.MIN_MASTER_RATIO, TileLayout.MAX_MASTER_RATIO);
                break;
            case Shortcut.Increase:
                if (this.numMaster < 10)
                    this.numMaster += 1;
                ctx.showNotification(this.description);
                break;
            case Shortcut.Decrease:
                if (this.numMaster > 0)
                    this.numMaster -= 1;
                ctx.showNotification(this.description);
                break;
            case Shortcut.Rotate:
                this.parts.rotate(90);
                break;
            case Shortcut.RotatePart:
                this.parts.inner.primary.rotate(90);
                break;
            default:
                return false;
        }
        return true;
    };
    TileLayout.prototype.toString = function () {
        return ("TileLayout(nmaster=" +
            this.numMaster +
            ", ratio=" +
            this.masterRatio +
            ")");
    };
    TileLayout.MIN_MASTER_RATIO = 0.2;
    TileLayout.MAX_MASTER_RATIO = 0.8;
    TileLayout.id = "TileLayout";
    return TileLayout;
}());
var DEBUG = {
    enabled: false,
    started: new Date().getTime(),
};
function debug(f) {
    if (DEBUG.enabled) {
        var timestamp = (new Date().getTime() - DEBUG.started) / 1000;
        console.log("[" + timestamp + "]", f());
    }
}
function debugObj(f) {
    if (DEBUG.enabled) {
        var timestamp = (new Date().getTime() - DEBUG.started) / 1000;
        var _a = f(), name = _a[0], obj = _a[1];
        var buf = [];
        for (var i in obj)
            buf.push(i + "=" + obj[i]);
        console.log("[" + timestamp + "]", name + ": " + buf.join(" "));
    }
}
function clip(value, min, max) {
    if (value < min)
        return min;
    if (value > max)
        return max;
    return value;
}
function slide(value, step) {
    if (step === 0)
        return value;
    return Math.floor(value / step + 1.000001) * step;
}
function matchWords(str, words) {
    for (var i = 0; i < words.length; i++) {
        if (str.indexOf(words[i]) >= 0)
            return i;
    }
    return -1;
}
function wrapIndex(index, length) {
    if (index < 0)
        return index + length;
    if (index >= length)
        return index - length;
    return index;
}
function partitionArray(array, predicate) {
    return array.reduce(function (parts, item, index) {
        parts[predicate(item, index) ? 0 : 1].push(item);
        return parts;
    }, [[], []]);
}
function partitionArrayBySizes(array, sizes) {
    var base = 0;
    var chunks = sizes.map(function (size) {
        var chunk = array.slice(base, base + size);
        base += size;
        return chunk;
    });
    chunks.push(array.slice(base));
    return chunks;
}
function overlap(min1, max1, min2, max2) {
    var min = Math.min;
    var max = Math.max;
    var dx = max(0, min(max1, max2) - max(min1, min2));
    return dx > 0;
}
function toQRect(rect) {
    return Qt.rect(rect.x, rect.y, rect.width, rect.height);
}
function toRect(qrect) {
    return new Rect(qrect.x, qrect.y, qrect.width, qrect.height);
}
var Rect = (function () {
    function Rect(x, y, width, height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    Object.defineProperty(Rect.prototype, "maxX", {
        get: function () {
            return this.x + this.width;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Rect.prototype, "maxY", {
        get: function () {
            return this.y + this.height;
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Rect.prototype, "center", {
        get: function () {
            return [
                this.x + Math.floor(this.width / 2),
                this.y + Math.floor(this.height / 2),
            ];
        },
        enumerable: false,
        configurable: true
    });
    Rect.prototype.clone = function () {
        return new Rect(this.x, this.y, this.width, this.height);
    };
    Rect.prototype.equals = function (other) {
        return (this.x === other.x &&
            this.y === other.y &&
            this.width === other.width &&
            this.height === other.height);
    };
    Rect.prototype.gap = function (left, right, top, bottom) {
        return new Rect(this.x + left, this.y + top, this.width - (left + right), this.height - (top + bottom));
    };
    Rect.prototype.gap_mut = function (left, right, top, bottom) {
        this.x += left;
        this.y += top;
        this.width -= left + right;
        this.height -= top + bottom;
        return this;
    };
    Rect.prototype.includes = function (other) {
        return (this.x <= other.x &&
            this.y <= other.y &&
            other.maxX < this.maxX &&
            other.maxY < this.maxY);
    };
    Rect.prototype.includesPoint = function (_a) {
        var x = _a[0], y = _a[1];
        return this.x <= x && x <= this.maxX && this.y <= y && y <= this.maxY;
    };
    Rect.prototype.subtract = function (other) {
        return new Rect(this.x - other.x, this.y - other.y, this.width - other.width, this.height - other.height);
    };
    Rect.prototype.toString = function () {
        return "Rect(" + [this.x, this.y, this.width, this.height].join(", ") + ")";
    };
    return Rect;
}());
var RectDelta = (function () {
    function RectDelta(east, west, south, north) {
        this.east = east;
        this.west = west;
        this.south = south;
        this.north = north;
    }
    RectDelta.fromRects = function (basis, target) {
        var diff = target.subtract(basis);
        return new RectDelta(diff.width + diff.x, -diff.x, diff.height + diff.y, -diff.y);
    };
    RectDelta.prototype.toString = function () {
        return ("WindowResizeDelta(" +
            [
                "east=" + this.east,
                "west=" + this.west,
                "north=" + this.north,
                "south=" + this.south,
            ].join(" ") +
            ")");
    };
    return RectDelta;
}());
var WrapperMap = (function () {
    function WrapperMap(hasher, wrapper) {
        this.hasher = hasher;
        this.wrapper = wrapper;
        this.items = {};
    }
    WrapperMap.prototype.add = function (item) {
        var key = this.hasher(item);
        if (this.items[key] !== undefined)
            throw "WrapperMap: the key [" + key + "] already exists!";
        var wrapped = this.wrapper(item);
        this.items[key] = wrapped;
        return wrapped;
    };
    WrapperMap.prototype.get = function (item) {
        var key = this.hasher(item);
        return this.items[key] || null;
    };
    WrapperMap.prototype.getByKey = function (key) {
        return this.items[key] || null;
    };
    WrapperMap.prototype.remove = function (item) {
        var key = this.hasher(item);
        return delete this.items[key];
    };
    WrapperMap.prototype.length = function () {
        return Object.keys(this.items).length;
    };
    return WrapperMap;
}());
