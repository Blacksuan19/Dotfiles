#!/usr/bin/env python3
from __future__ import annotations

import argparse
import configparser
import pathlib
import re
import select
import struct
import subprocess
import sys
import zipfile
import zlib
from collections.abc import Mapping
from dataclasses import dataclass
from typing import TypeVar

RGB = tuple[int, int, int]
RGBA = tuple[int, int, int, int]
ResolvedTheme = dict[str, RGBA]
SurfaceMap = dict[str, RGB]
KeyMap = dict[str, str]
TemplatePaths = dict[str, pathlib.Path | None]
FileSignature = tuple[int, int]
GenerationSignature = tuple[object, ...]
T = TypeVar("T")

WHITE: RGB = (255, 255, 255)
BLACK: RGB = (0, 0, 0)
SCRIPT_DIR = pathlib.Path(__file__).resolve().parent
DEFAULT_TEMPLATE_DARK = SCRIPT_DIR / "material-template-dark.tdesktop-theme"
DEFAULT_TEMPLATE_LIGHT = SCRIPT_DIR / "material-template-light.tdesktop-theme"
DEFAULT_BACKGROUND_MEMBER_NAME = "background.png"

LINE_RE = re.compile(r"^(\s*)([A-Za-z0-9_]+)(\s*:\s*)([^;]+)(\s*;.*)?$")
HEX_RE = re.compile(r"#([0-9a-fA-F]{6})([0-9a-fA-F]{2})?")

SURFACE_SPECS: list[tuple[str, str, str, float, float]] = [
    ("base_bg", "view_bg", "sideBarBg", 0.06, 0.04),
    ("hover_bg", "base_bg", "windowBgOver", 0.14, 0.06),
    ("ripple_bg", "base_bg", "windowBgRipple", 0.18, 0.10),
    ("active_bg", "base_bg", "dialogsBgActive", 0.22, 0.18),
    ("active_ripple_bg", "base_bg", "dialogsRippleBgActive", 0.26, 0.22),
    ("search_bg", "base_bg", "filterInputInactiveBg", 0.10, 0.08),
    ("search_active_bg", "base_bg", "filterInputActiveBg", 0.14, 0.12),
    ("bubble_in_bg", "base_bg", "msgInBg", 0.12, 0.10),
    ("bubble_in_selected_bg", "base_bg", "msgInBgSelected", 0.18, 0.14),
    ("bubble_out_bg", "base_bg", "msgOutBg", 0.18, 0.14),
    ("bubble_out_selected_bg", "base_bg", "msgOutBgSelected", 0.24, 0.20),
]

GROUPED_REPLACEMENTS: dict[str, list[str]] = {
    "base_bg": """
        windowBg titleBg titleBgActive titleButtonBg titleButtonBgActive
        titleButtonCloseBg titleButtonCloseBgActive topBarBg dialogsBg
        historyComposeAreaBg historyPinnedBg historyReplyBg historyComposeButtonBg
        emojiPanBg emojiPanHeaderBg mainMenuBg mediaPlayerBg reportSpamBg
    """.split(),
    "window_fg": """
        windowFg windowFgOver windowBoldFg windowBoldFgOver windowFgActive
        titleFgActive dialogsUnreadBg dialogsUnreadBgOver dialogsUnreadBgActive
        historyTextInFg
    """.split(),
    "subtle_fg": """
        windowSubTextFg windowSubTextFgOver dialogsDateFg dialogsDateFgOver
        dialogsDateFgActive dialogsTextFg dialogsTextFgOver dialogsTextFgActive
        historyComposeAreaFgService
    """.split(),
    "accent": """
        windowBgActive windowActiveTextFg activeButtonBg lightButtonFg
        lightButtonFgOver dialogsVerifiedIconBg dialogsVerifiedIconBgOver
        dialogsVerifiedIconBgActive sideBarBadgeBg profileVerifiedCheckBg
        overviewCheckBgActive changePhoneSimcardTo historyPeerSavedMessagesBg
        historyPeerSavedMessagesBg2 historyPeerArchiveUserpicBg
    """.split(),
    "active_fg": """
        activeButtonFg activeButtonFgOver activeButtonSecondaryFg
        activeButtonSecondaryFgOver dialogsVerifiedIconFg
        dialogsVerifiedIconFgOver dialogsVerifiedIconFgActive
        profileVerifiedCheckFg overviewCheckFgActive
    """.split(),
    "hover_bg": "dialogsBgOver notificationBg historyComposeButtonBgOver".split(),
    "ripple_bg": "dialogsRippleBg historyComposeButtonBgRipple".split(),
    "active_list": "dialogsBgActive dialogsForwardBg sideBarBgActive".split(),
    "active_list_ripple": ["dialogsRippleBgActive"],
    "view_fg": """
        dialogsForwardFg dialogsNameFg dialogsNameFgOver dialogsNameFgActive
        dialogsChatIconFg dialogsChatIconFgOver dialogsChatIconFgActive
    """.split(),
    "muted_badge": """
        dialogsUnreadBgMuted dialogsUnreadBgMutedOver dialogsUnreadBgMutedActive
    """.split(),
    "unread_fg": "dialogsUnreadFg dialogsUnreadFgOver dialogsUnreadFgActive".split(),
    "search_bg": "sideBarBg searchedBarBg filterInputInactiveBg".split(),
    "search_active_bg": "sideBarBgRipple filterInputActiveBg".split(),
    "sidebar_text_fg": "sideBarTextFg sideBarIconFg".split(),
    "sidebar_active_fg": "sideBarTextFgActive sideBarIconFgActive".split(),
    "msg_in": ["msgInBg"],
    "msg_in_selected": ["msgInBgSelected"],
    "msg_out": ["msgOutBg"],
    "msg_out_selected": ["msgOutBgSelected"],
    "elevated_fg": """
        historyTextInFgSelected historyTextOutFg historyTextOutFgSelected
        historyFileNameInFgSelected historyFileNameOutFgSelected
    """.split(),
}

LITERAL_SURFACE_KEYS: tuple[tuple[str, str], ...] = (
    ("windowBg", "base_bg"),
    ("windowBgOver", "hover_bg"),
    ("windowBgRipple", "ripple_bg"),
    ("dialogsBgActive", "active_bg"),
    ("dialogsRippleBgActive", "active_ripple_bg"),
    ("msgInBg", "bubble_in_bg"),
    ("msgInBgSelected", "bubble_in_selected_bg"),
    ("msgOutBg", "bubble_out_bg"),
    ("msgOutBgSelected", "bubble_out_selected_bg"),
    ("filterInputInactiveBg", "search_bg"),
    ("filterInputActiveBg", "search_active_bg"),
)

LITERAL_TEXT_KEYS: tuple[str, ...] = (
    "windowSubTextFg",
    "menuIconFg",
    "menuFgDisabled",
    "titleFg",
    "scrollBarBg",
    "scrollBarBgOver",
    "dialogsUnreadBgMuted",
)

LITERAL_ACCENT_BLEND_KEYS: tuple[tuple[str, float, float], ...] = (
    ("menuSeparatorFg", 0.10, 0.08),
    ("inputBorderFg", 0.14, 0.10),
)


@dataclass(frozen=True)
class ThemeTemplate:
    kind: str
    colors_text: str
    zip_members: dict[str, bytes] | None = None
    colors_member_name: str | None = None
    background_member_name: str | None = None


@dataclass(frozen=True)
class PlasmaPalette:
    window_bg: RGB
    window_fg: RGB
    view_bg: RGB
    view_fg: RGB
    header_bg: RGB
    header_fg: RGB
    accent: RGB
    accent_fg: RGB
    tooltip_bg: RGB
    tooltip_fg: RGB

    def signature_values(self) -> tuple[RGB, ...]:
        return tuple(self.__dict__.values())


@dataclass(frozen=True)
class ThemeContext:
    theme_text: str
    resolved: ResolvedTheme
    surfaces: SurfaceMap


@dataclass(frozen=True)
class GenerationState:
    plasma: PlasmaPalette
    mode: str
    template_path: pathlib.Path

    def signature(self) -> GenerationSignature:
        return (self.mode, str(self.template_path)) + self.plasma.signature_values()


def clamp(value: float | int, lo: int = 0, hi: int = 255) -> int:
    return max(lo, min(hi, int(round(value))))


def require_value(mapping: Mapping[str, T], key: str, context: str) -> T:
    value = mapping.get(key)
    if value is None:
        raise RuntimeError(f"Missing {key!r} in {context}")
    return value


def parse_rgb_triplet(value: str) -> RGB:
    parts = [part.strip() for part in value.split(",")]
    if len(parts) < 3:
        raise ValueError(f"Bad RGB triplet: {value!r}")
    return tuple(clamp(int(parts[index])) for index in range(3))


def parse_hex_color(value: str) -> RGBA | None:
    match = HEX_RE.fullmatch(value.strip())
    if not match:
        return None
    rgb = match.group(1)
    alpha = match.group(2) or "ff"
    return (
        int(rgb[0:2], 16),
        int(rgb[2:4], 16),
        int(rgb[4:6], 16),
        int(alpha, 16),
    )


def hex_rgb(color: RGB) -> str:
    return "#{:02x}{:02x}{:02x}".format(*color)


def hex_rgba(color: RGB, alpha: float | int) -> str:
    return "#{:02x}{:02x}{:02x}{:02x}".format(
        color[0], color[1], color[2], clamp(alpha)
    )


def mix(left: RGB, right: RGB, amount: float) -> RGB:
    return tuple(
        clamp(left[index] * (1.0 - amount) + right[index] * amount)
        for index in range(3)
    )


def luminance(color: RGB) -> float:
    def channel(value: int) -> float:
        value = value / 255.0
        return value / 12.92 if value <= 0.04045 else ((value + 0.055) / 1.055) ** 2.4

    red, green, blue = [channel(value) for value in color]
    return 0.2126 * red + 0.7152 * green + 0.0722 * blue


def contrast_on(background: RGB) -> RGB:
    return BLACK if luminance(background) > 0.45 else WHITE


def fmt_rgb(color: RGB) -> str:
    return f"{color[0]},{color[1]},{color[2]}"


def blend_factor(target: RGB, left: RGB, right: RGB) -> float:
    vector = [right[index] - left[index] for index in range(3)]
    denom = sum(component * component for component in vector)
    if denom == 0:
        return 0.0
    numer = sum((target[index] - left[index]) * vector[index] for index in range(3))
    return max(0.0, min(1.0, numer / denom))


def png_chunk(chunk_type: bytes, data: bytes) -> bytes:
    return (
        struct.pack(">I", len(data))
        + chunk_type
        + data
        + struct.pack(">I", zlib.crc32(chunk_type + data) & 0xFFFFFFFF)
    )


def make_solid_png(color: RGB, size: int = 128) -> bytes:
    row = b"\x00" + bytes(color) * size
    raw = row * size
    header = struct.pack(">IIBBBBB", size, size, 8, 2, 0, 0, 0)
    return b"".join(
        [
            b"\x89PNG\r\n\x1a\n",
            png_chunk(b"IHDR", header),
            png_chunk(b"IDAT", zlib.compress(raw, 9)),
            png_chunk(b"IEND", b""),
        ]
    )


def read_ini(path: pathlib.Path) -> configparser.ConfigParser:
    cfg = configparser.ConfigParser(interpolation=None)
    cfg.optionxform = str
    with path.open("r", encoding="utf-8") as handle:
        cfg.read_file(handle)
    return cfg


def get_color(
    cfg: configparser.ConfigParser, section: str, key: str, fallback: RGB
) -> RGB:
    try:
        return parse_rgb_triplet(cfg[section][key])
    except Exception:
        return fallback


def read_plasma_colors(cfg: configparser.ConfigParser) -> PlasmaPalette:
    window_bg = get_color(cfg, "Colors:Window", "BackgroundNormal", (27, 28, 23))
    window_fg = get_color(cfg, "Colors:Window", "ForegroundNormal", (227, 227, 217))
    view_bg = get_color(cfg, "Colors:View", "BackgroundNormal", window_bg)
    view_fg = get_color(cfg, "Colors:View", "ForegroundNormal", window_fg)
    header_bg = get_color(
        cfg, "Colors:Header", "BackgroundNormal", mix(window_bg, window_fg, 0.04)
    )
    header_fg = get_color(cfg, "Colors:Header", "ForegroundNormal", window_fg)
    accent = get_color(cfg, "Colors:Selection", "BackgroundNormal", (185, 207, 122))
    accent_fg = get_color(
        cfg, "Colors:Selection", "ForegroundNormal", contrast_on(accent)
    )
    tooltip_bg = get_color(
        cfg, "Colors:Tooltip", "BackgroundNormal", mix(window_bg, accent, 0.10)
    )
    tooltip_fg = get_color(
        cfg, "Colors:Tooltip", "ForegroundNormal", contrast_on(tooltip_bg)
    )
    return PlasmaPalette(
        window_bg=window_bg,
        window_fg=window_fg,
        view_bg=view_bg,
        view_fg=view_fg,
        header_bg=header_bg,
        header_fg=header_fg,
        accent=accent,
        accent_fg=accent_fg,
        tooltip_bg=tooltip_bg,
        tooltip_fg=tooltip_fg,
    )


def mode_from_value(value: str) -> str | None:
    lowered = value.strip().strip("'").strip('"').lower()
    if "dark" in lowered:
        return "dark"
    if "light" in lowered:
        return "light"
    return None


def current_system_mode() -> str | None:
    try:
        result = subprocess.run(
            ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"],
            capture_output=True,
            text=True,
            check=False,
        )
        mode = mode_from_value(result.stdout)
        if mode:
            return mode
    except OSError:
        pass

    return None


def require_system_mode() -> str:
    mode = current_system_mode()
    if not mode:
        raise RuntimeError("Unable to determine system appearance mode from gsettings")
    return mode


def resolve_templates(args: argparse.Namespace) -> TemplatePaths:
    if args.template:
        return {"shared": args.template, "dark": args.template, "light": args.template}

    return {
        "shared": None,
        "dark": args.template_dark or DEFAULT_TEMPLATE_DARK,
        "light": args.template_light or DEFAULT_TEMPLATE_LIGHT,
    }


def choose_template(args: argparse.Namespace, mode: str) -> pathlib.Path:
    templates = resolve_templates(args)
    shared = templates.get("shared")
    if shared:
        return shared

    dark = templates.get("dark")
    light = templates.get("light")

    if mode == "dark":
        if dark is None:
            raise RuntimeError("Dark template path is missing")
        if not dark.exists():
            raise RuntimeError(f"Dark template not found: {dark}")
        return dark
    if light is None:
        raise RuntimeError("Light template path is missing")
    if not light.exists():
        raise RuntimeError(f"Light template not found: {light}")
    return light


def read_theme_template(path: pathlib.Path) -> ThemeTemplate:
    if zipfile.is_zipfile(path):
        with zipfile.ZipFile(path, "r") as archive:
            members = {name: archive.read(name) for name in archive.namelist()}
        colors_member_name = next(
            (
                name
                for name in members
                if name.lower().endswith("colors.tdesktop-theme")
            ),
            None,
        )
        if not colors_member_name:
            raise RuntimeError(
                f"{path} is a zip theme, but no colors.tdesktop-theme was found"
            )
        background_member_name = next(
            (
                name
                for name in members
                if pathlib.Path(name).name.lower()
                in {"background.png", "background.jpg"}
            ),
            None,
        )
        return ThemeTemplate(
            kind="zip",
            colors_text=members[colors_member_name].decode("utf-8"),
            zip_members=members,
            colors_member_name=colors_member_name,
            background_member_name=background_member_name,
        )

    return ThemeTemplate(
        kind="text",
        colors_text=path.read_text(encoding="utf-8"),
    )


def parse_theme_assignments(theme_text: str) -> dict[str, str]:
    assignments: dict[str, str] = {}
    for line in theme_text.splitlines():
        match = LINE_RE.match(line)
        if match:
            assignments[match.group(2)] = match.group(4).strip()
    return assignments


def resolve_theme_colors(assignments: dict[str, str]) -> ResolvedTheme:
    resolved: ResolvedTheme = {}
    resolving: set[str] = set()

    def resolve_value(name: str) -> RGBA:
        if name in resolved:
            return resolved[name]
        if name in resolving:
            raise RuntimeError(f"Circular theme reference detected at {name}")
        if name not in assignments:
            raise KeyError(name)

        resolving.add(name)
        raw = assignments[name]
        parsed = parse_hex_color(raw)
        if parsed is not None:
            resolved[name] = parsed
        elif raw in assignments:
            resolved[name] = resolve_value(raw)
        else:
            raise RuntimeError(f"Unsupported theme value for {name}: {raw}")
        resolving.remove(name)
        return resolved[name]

    for key in assignments:
        try:
            resolve_value(key)
        except RuntimeError:
            raise
        except Exception:
            continue

    return resolved


def color_rgb(resolved: ResolvedTheme, key: str) -> RGB:
    value = resolved.get(key)
    if value is None:
        raise RuntimeError(f"Theme key missing or not resolvable: {key}")
    return value[:3]


def color_alpha(resolved: ResolvedTheme, key: str, fallback: int = 255) -> int:
    value = resolved.get(key)
    if value is None:
        return fallback
    return value[3]


def template_text(
    resolved: ResolvedTheme, key: str, window_fg: RGB, window_bg: RGB
) -> RGB:
    return mix(
        window_fg,
        window_bg,
        blend_factor(
            color_rgb(resolved, key),
            color_rgb(resolved, "windowFg"),
            color_rgb(resolved, "windowBg"),
        ),
    )


def elevated_text(window_fg: RGB, is_dark: bool) -> RGB:
    endpoint = WHITE if is_dark else BLACK
    return mix(window_fg, endpoint, 0.10)


def lifted_foreground(color: RGB, is_dark: bool, amount: float | None = None) -> RGB:
    if amount is None:
        amount = 0.12 if is_dark else 0.03
    return mix(color, WHITE if is_dark else BLACK, amount)


def derive_surfaces(
    resolved: ResolvedTheme, plasma: PlasmaPalette, mode: str
) -> SurfaceMap:
    accent = plasma.accent
    is_dark = mode == "dark"

    def factor(key: str, dark_floor: float, light_floor: float) -> float:
        floor = dark_floor if is_dark else light_floor
        return max(
            floor,
            blend_factor(
                color_rgb(resolved, key),
                color_rgb(resolved, "windowBg"),
                color_rgb(resolved, "windowBgActive"),
            ),
        )

    surfaces: SurfaceMap = {}
    for name, left_name, key, dark_floor, light_floor in SURFACE_SPECS:
        left = (
            plasma.view_bg
            if left_name == "view_bg"
            else require_value(surfaces, left_name, "derived surfaces")
        )
        surfaces[name] = mix(left, accent, factor(key, dark_floor, light_floor))
    return surfaces


def build_theme_context(
    theme_text: str, plasma: PlasmaPalette, mode: str
) -> ThemeContext:
    assignments = parse_theme_assignments(theme_text)
    resolved = resolve_theme_colors(assignments)
    return ThemeContext(
        theme_text=theme_text,
        resolved=resolved,
        surfaces=derive_surfaces(resolved, plasma, mode),
    )


def remember_literal(
    mapped: KeyMap, resolved: ResolvedTheme, key: str, value: RGB
) -> None:
    mapped.setdefault(hex_rgb(color_rgb(resolved, key)), hex_rgb(value))


def build_literal_map(
    resolved: ResolvedTheme, plasma: PlasmaPalette, mode: str, surfaces: SurfaceMap
) -> KeyMap:
    window_bg = plasma.window_bg
    is_dark = mode == "dark"
    window_fg = lifted_foreground(plasma.window_fg, is_dark)
    accent = plasma.accent
    mapped: KeyMap = {}

    remember_literal(mapped, resolved, "windowFg", window_fg)
    remember_literal(mapped, resolved, "windowBgActive", accent)
    remember_literal(
        mapped, resolved, "historyTextOutFg", elevated_text(window_fg, is_dark)
    )

    for key, surface_name in LITERAL_SURFACE_KEYS:
        remember_literal(
            mapped,
            resolved,
            key,
            require_value(surfaces, surface_name, "derived surfaces"),
        )

    for key, dark_amount, light_amount in LITERAL_ACCENT_BLEND_KEYS:
        remember_literal(
            mapped,
            resolved,
            key,
            mix(
                require_value(surfaces, "base_bg", "derived surfaces"),
                accent,
                dark_amount if is_dark else light_amount,
            ),
        )

    for key in LITERAL_TEXT_KEYS:
        remember_literal(
            mapped, resolved, key, template_text(resolved, key, window_fg, window_bg)
        )

    return mapped


def rewrite_literal_colors(theme_text: str, literal_map: KeyMap) -> str:
    def replace_hex(match: re.Match[str]) -> str:
        source = f"#{match.group(1).lower()}"
        alpha = match.group(2) or ""
        target = literal_map.get(source)
        if not target:
            return match.group(0)
        return f"{target}{alpha.lower()}"

    return HEX_RE.sub(replace_hex, theme_text)


def apply_key_replacements(theme_text: str, replacements: KeyMap) -> str:
    output: list[str] = []
    for line in theme_text.splitlines():
        match = LINE_RE.match(line)
        if not match:
            output.append(line)
            continue

        indent, key, separator, _, comment = match.groups()
        if key in replacements:
            output.append(f"{indent}{key}{separator}{replacements[key]}{comment or ''}")
        else:
            output.append(line)
    return "\n".join(output) + "\n"


def build_key_replacements(
    resolved: ResolvedTheme, plasma: PlasmaPalette, mode: str, surfaces: SurfaceMap
) -> KeyMap:
    def surface(name: str) -> RGB:
        return require_value(surfaces, name, "derived surfaces")

    def overlay_alpha(key: str, fallback: int, light_floor: int, dark_floor: int) -> int:
        alpha = color_alpha(resolved, key, fallback)
        floor = dark_floor if is_dark else light_floor
        return max(alpha, floor)

    window_bg = plasma.window_bg
    is_dark = mode == "dark"
    window_fg = lifted_foreground(plasma.window_fg, is_dark)
    view_fg = lifted_foreground(
        plasma.view_fg,
        is_dark,
        0.06 if is_dark else 0.02,
    )
    accent = plasma.accent
    tooltip_bg = plasma.tooltip_bg
    tooltip_fg = lifted_foreground(
        plasma.tooltip_fg,
        is_dark,
        0.04 if is_dark else 0.01,
    )

    active_fg = contrast_on(accent)
    base_bg = surface("base_bg")
    surface_over = surface("hover_bg")
    surface_ripple = surface("ripple_bg")
    subtle_fg = template_text(resolved, "windowSubTextFg", window_fg, window_bg)
    subtle_fg = lifted_foreground(subtle_fg, is_dark, 0.10 if is_dark else 0.03)
    msg_in = surface("bubble_in_bg")
    msg_in_selected = surface("bubble_in_selected_bg")
    msg_out = surface("bubble_out_bg")
    msg_out_selected = surface("bubble_out_selected_bg")
    muted_badge = template_text(resolved, "dialogsUnreadBgMuted", window_fg, window_bg)
    active_list = surface("active_bg")
    active_list_ripple = surface("active_ripple_bg")
    search_bg = surface("search_bg")
    search_active_bg = surface("search_active_bg")
    sidebar_text_fg = mix(window_fg, search_bg, 0.30 if is_dark else 0.22)
    sidebar_active_fg = mix(accent, active_list, 0.18 if is_dark else 0.12)
    dialogs_service_fg = mix(accent, window_fg, 0.14 if is_dark else 0.30)
    link_fg = mix(accent, window_fg, 0.52 if is_dark else 0.22)
    elevated_fg = elevated_text(window_fg, is_dark)
    image_overlay_fg = window_fg
    action_icon_fg = mix(accent, window_fg, 0.10 if is_dark else 0.42)

    replacements: KeyMap = {
        "windowShadowFgFallback": hex_rgb(window_bg),
        "activeButtonBgOver": hex_rgb(mix(accent, active_fg, 0.08)),
        "activeButtonBgRipple": hex_rgb(
            mix(
                accent,
                window_bg,
                blend_factor(
                    color_rgb(resolved, "activeButtonBgRipple"),
                    color_rgb(resolved, "windowBgActive"),
                    color_rgb(resolved, "windowBg"),
                ),
            )
        ),
        "lightButtonBgRipple": hex_rgba(
            accent, color_alpha(resolved, "lightButtonBgRipple", 0x18)
        ),
        "tooltipBg": hex_rgba(tooltip_bg, color_alpha(resolved, "tooltipBg", 0xE6)),
        "tooltipFg": hex_rgb(tooltip_fg),
        "tooltipBorderFg": hex_rgba(
            tooltip_bg, color_alpha(resolved, "tooltipBorderFg", 0xE6)
        ),
        "dialogsTextFgService": hex_rgb(dialogs_service_fg),
        "dialogsTextFgServiceOver": hex_rgb(dialogs_service_fg),
        "dialogsTextFgServiceActive": hex_rgb(dialogs_service_fg),
        "msgServiceFg": hex_rgb(window_fg),
        "msgInServiceFg": hex_rgb(window_fg),
        "msgInServiceFgSelected": hex_rgb(window_fg),
        "msgOutServiceFg": hex_rgb(window_fg),
        "msgOutServiceFgSelected": hex_rgb(window_fg),
        "historyComposeAreaFgService": hex_rgb(window_fg),
        "historyLinkInFg": hex_rgb(link_fg),
        "historyLinkInFgSelected": hex_rgb(link_fg),
        "historyLinkOutFg": hex_rgb(link_fg),
        "historyLinkOutFgSelected": hex_rgb(link_fg),
        "sideBarBadgeFg": hex_rgb(active_fg),
        "sideBarBadgeBgMuted": hex_rgb(muted_badge),
        "mainMenuCloudBg": hex_rgba(
            accent, color_alpha(resolved, "mainMenuCloudBg", 0x3D)
        ),
        "historyToDownBg": hex_rgb(search_bg),
        "historyToDownBgOver": hex_rgb(search_active_bg),
        "historyToDownBgRipple": hex_rgb(surface_ripple),
        "historyToDownFg": hex_rgb(sidebar_text_fg),
        "historyToDownFgOver": hex_rgb(window_fg),
        "historySendIconFg": hex_rgb(action_icon_fg),
        "historySendIconFgOver": hex_rgb(action_icon_fg),
        "historyReplyIconFg": hex_rgb(action_icon_fg),
        "msgDateImgFg": hex_rgb(image_overlay_fg),
        "msgDateImgBg": hex_rgba(
            base_bg, overlay_alpha("msgDateImgBg", 0x99, 0xE8, 0x99)
        ),
        "msgDateImgBgOver": hex_rgba(
            surface_over, overlay_alpha("msgDateImgBgOver", 0xAA, 0xF0, 0xAA)
        ),
        "msgDateImgBgSelected": hex_rgba(
            surface_over,
            overlay_alpha("msgDateImgBgSelected", 0xBB, 0xF4, 0xBB),
        ),
        "historyFileInIconFg": hex_rgb(image_overlay_fg),
        "historyFileOutIconFg": hex_rgb(image_overlay_fg),
        "historyFileInIconFgSelected": hex_rgb(image_overlay_fg),
        "historyFileOutIconFgSelected": hex_rgb(image_overlay_fg),
        "historyFileThumbIconFg": hex_rgb(image_overlay_fg),
        "historyFileThumbIconFgSelected": hex_rgb(image_overlay_fg),
        "historyOutIconFg": hex_rgb(image_overlay_fg),
        "historyOutIconFgSelected": hex_rgb(image_overlay_fg),
        "historySendingOutIconFg": hex_rgb(image_overlay_fg),
        "historySendingInIconFg": hex_rgb(image_overlay_fg),
        "historyIconFgInverted": hex_rgb(image_overlay_fg),
        "historySendingInvertedIconFg": hex_rgb(image_overlay_fg),
        "toastBg": hex_rgba(surface_over, color_alpha(resolved, "toastBg", 0xE6)),
        "importantTooltipBg": hex_rgba(
            surface_over, color_alpha(resolved, "importantTooltipBg", 0xE6)
        ),
    }

    palette: KeyMap = {
        "base_bg": hex_rgb(base_bg),
        "window_fg": hex_rgb(window_fg),
        "subtle_fg": hex_rgb(subtle_fg),
        "accent": hex_rgb(accent),
        "active_fg": hex_rgb(active_fg),
        "hover_bg": hex_rgb(surface_over),
        "ripple_bg": hex_rgb(surface_ripple),
        "active_list": hex_rgb(active_list),
        "active_list_ripple": hex_rgb(active_list_ripple),
        "view_fg": hex_rgb(view_fg),
        "muted_badge": hex_rgb(muted_badge),
        "unread_fg": hex_rgb(contrast_on(window_fg)),
        "search_bg": hex_rgb(search_bg),
        "search_active_bg": hex_rgb(search_active_bg),
        "sidebar_text_fg": hex_rgb(sidebar_text_fg),
        "sidebar_active_fg": hex_rgb(sidebar_active_fg),
        "msg_in": hex_rgb(msg_in),
        "msg_in_selected": hex_rgb(msg_in_selected),
        "msg_out": hex_rgb(msg_out),
        "msg_out_selected": hex_rgb(msg_out_selected),
        "elevated_fg": hex_rgb(elevated_fg),
    }

    for source, keys in GROUPED_REPLACEMENTS.items():
        value = require_value(palette, source, "replacement palette")
        for key in keys:
            replacements[key] = value

    return replacements


def render_theme(context: ThemeContext, plasma: PlasmaPalette, mode: str) -> str:
    recolored = rewrite_literal_colors(
        context.theme_text,
        build_literal_map(context.resolved, plasma, mode, context.surfaces),
    )
    replacements = build_key_replacements(
        context.resolved, plasma, mode, context.surfaces
    )
    return apply_key_replacements(recolored, replacements)


def write_theme_output(
    output_path: pathlib.Path,
    template_info: ThemeTemplate,
    colors_text: str,
    background_bytes: bytes,
) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    if template_info.kind == "text":
        output_path.write_text(colors_text, encoding="utf-8")
        return

    members = dict(template_info.zip_members or {})
    members[template_info.colors_member_name] = colors_text.encode("utf-8")
    background_member_name = (
        template_info.background_member_name or DEFAULT_BACKGROUND_MEMBER_NAME
    )
    members[background_member_name] = background_bytes

    with zipfile.ZipFile(output_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        for name, data in members.items():
            archive.writestr(name, data)


def read_generation_state(args: argparse.Namespace) -> GenerationState:
    cfg = read_ini(args.kdeglobals)
    mode = require_system_mode()
    return GenerationState(
        plasma=read_plasma_colors(cfg),
        mode=mode,
        template_path=choose_template(args, mode),
    )


def file_signature(path: pathlib.Path) -> FileSignature | None:
    try:
        stat = path.stat()
    except FileNotFoundError:
        return None
    return (stat.st_mtime_ns, stat.st_size)


def generate(args: argparse.Namespace, state: GenerationState | None = None) -> None:
    state = state or read_generation_state(args)
    plasma = state.plasma
    mode = state.mode
    template_path = state.template_path
    template_info = read_theme_template(template_path)
    context = build_theme_context(template_info.colors_text, plasma, mode)
    theme_text = render_theme(context, plasma, mode)
    background = make_solid_png(
        require_value(context.surfaces, "base_bg", "derived surfaces")
    )
    write_theme_output(args.output, template_info, theme_text, background)

    if args.debug:
        print_generation_debug(mode, template_path, plasma, context.surfaces)
    print(f"Wrote {args.output} using {template_path.name} [{mode}]", flush=True)


def print_generation_debug(
    mode: str,
    template_path: pathlib.Path,
    plasma: PlasmaPalette,
    surfaces: SurfaceMap,
) -> None:
    print(f"mode={mode}")
    print(f"template={template_path}")
    debug_colors: dict[str, RGB] = {
        "window_bg": plasma.window_bg,
        "window_fg": lifted_foreground(plasma.window_fg, mode == "dark"),
        "view_bg": plasma.view_bg,
        "view_fg": plasma.view_fg,
        "header_bg": plasma.header_bg,
        "header_fg": plasma.header_fg,
        "accent": plasma.accent,
        "background": require_value(surfaces, "base_bg", "derived surfaces"),
    }
    for name, color in debug_colors.items():
        print(f"{name}={fmt_rgb(color)} ({hex_rgb(color)})")


def start_watch_process(command: list[str]) -> subprocess.Popen[str] | None:
    try:
        return subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            bufsize=1,
        )
    except OSError:
        return None


def watch(args: argparse.Namespace) -> None:
    watcher = start_watch_process(
        ["gsettings", "monitor", "org.gnome.desktop.interface"]
    )
    if not watcher or not watcher.stdout:
        raise RuntimeError("Unable to start gsettings appearance watcher")

    kdeglobals_signature = file_signature(args.kdeglobals)
    state = read_generation_state(args)
    signature = state.signature()
    generate(args, state)
    print(f"Watching for appearance changes and {args.kdeglobals}...", flush=True)

    try:
        while True:
            triggers: list[str] = []

            ready, _, _ = select.select([watcher.stdout], [], [], 0.5)
            if ready:
                line = watcher.stdout.readline()
                if not line:
                    raise RuntimeError(
                        "gsettings appearance watcher stopped unexpectedly"
                    )
                if "color-scheme" in line or "gtk-theme" in line:
                    triggers.append(f"gsettings: {line.strip()}")

            current_kdeglobals_signature = file_signature(args.kdeglobals)
            if current_kdeglobals_signature != kdeglobals_signature:
                kdeglobals_signature = current_kdeglobals_signature
                triggers.append(f"kdeglobals: {args.kdeglobals}")

            if not triggers:
                continue

            current_state = read_generation_state(args)
            current_signature = current_state.signature()
            if current_signature == signature:
                print(
                    f"Skipped refresh ({', '.join(triggers)}) because the theme inputs did not change.",
                    flush=True,
                )
                continue
            signature = current_signature
            generate(args, current_state)
    except KeyboardInterrupt:
        print("\nStopped.", flush=True)
    finally:
        watcher.kill()
        watcher.wait(timeout=1)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate a Telegram theme from the current KDE Plasma palette."
    )
    parser.add_argument(
        "--template", type=pathlib.Path, help="Single template for both modes"
    )
    parser.add_argument(
        "--template-dark", type=pathlib.Path, help="Template to use in dark mode"
    )
    parser.add_argument(
        "--template-light", type=pathlib.Path, help="Template to use in light mode"
    )
    parser.add_argument(
        "-o",
        "--output",
        type=pathlib.Path,
        required=True,
        help="Output .tdesktop-theme path",
    )
    parser.add_argument(
        "-k",
        "--kdeglobals",
        type=pathlib.Path,
        default=pathlib.Path.home() / ".config" / "kdeglobals",
        help="Path to kdeglobals",
    )
    parser.add_argument(
        "--watch", action="store_true", help="Regenerate on desktop appearance changes"
    )
    parser.add_argument(
        "--debug", action="store_true", help="Print detected palette values"
    )

    return parser.parse_args()


def main() -> None:
    args = parse_args()

    if not args.kdeglobals.exists():
        print(f"kdeglobals not found: {args.kdeglobals}", file=sys.stderr)
        sys.exit(1)

    templates = resolve_templates(args)
    for path in {
        templates.get("dark"),
        templates.get("light"),
        templates.get("shared"),
    }:
        if path and not path.exists():
            print(f"Template not found: {path}", file=sys.stderr)
            sys.exit(1)

    try:
        if args.watch:
            watch(args)
        else:
            generate(args)
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
