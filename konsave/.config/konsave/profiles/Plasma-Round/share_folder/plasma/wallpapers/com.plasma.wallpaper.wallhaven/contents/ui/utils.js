/**
 * @typedef {{
 *   fullUrl: string,
 *   thumbUrl: string,
 *   localPath: string,
 *   isDark: (boolean|null)
 * }} SavedWallpaperEntry
 */

/**
 * @typedef {{
 *   query: string,
 *   nextIndex: number,
 *   queryParam: string
 * }} QueryBuildResult
 */

/**
 * @param {string|{toString: function(): string}|null|undefined} path
 * @returns {string}
 */
function normalizePath(path) {
    if (!path)
        return "";

    const text = (typeof path === "string") ? path : path.toString();
    return text.startsWith("file://") ? text.slice("file://".length) : text;
}

/**
 * @param {string|{toString: function(): string}|null|undefined} url
 * @returns {boolean}
 */
function isHttpUrl(url) {
    if (!url)
        return false;

    return url.toString().startsWith("http");
}

/**
 * @param {string} url
 * @returns {string|null}
 */
function extractWallhavenId(url) {
    const match = url.match(/(?:wallhaven-)?([a-zA-Z0-9]{6})(?=\.[a-zA-Z0-9]+(?:$|[?#])|$)/);
    return match ? match[1] : null;
}

/**
 * @param {string} entry
 * @returns {SavedWallpaperEntry}
 */
function parseSavedEntry(entry) {
    const parts = entry.split("|||");
    const fullUrl = parts[0];
    const thumbUrl = parts.length > 1 ? parts[1] : fullUrl;
    const localPath = parts.length > 2 ? normalizePath(parts[2]) : "";
    const isDark = parts.length > 3 ? (parts[3] === "1" ? true : parts[3] === "0" ? false : null) : null;

    return {
        fullUrl: fullUrl,
        thumbUrl: thumbUrl,
        localPath: localPath,
        isDark: isDark
    };
}

/**
 * @param {Object.<string, any>} config
 * @param {string} paramName
 * @param {string[]} configKeys
 * @returns {string}
 */
function buildBinaryParameter(config, paramName, configKeys) {
    let result = "";
    for (let i = 0; i < configKeys.length; i++) {
        result += config[configKeys[i]] ? "1" : "0";
    }
    return `${paramName}=${result}`;
}

/**
 * @param {Object.<string, any>} config
 * @returns {string}
 */
function buildRatioParameter(config) {
    if (config.RatioAny)
        return "";

    var ratios = [];
    if (config.Ratio169)
        ratios.push("16x9");

    if (config.Ratio1610)
        ratios.push("16x10");

    if (config.RatioCustom)
        ratios.push(config.RatioCustomValue);

    return ratios.length > 0 ? `ratios=${ratios.join(',')}&` : "";
}

/**
 * @param {string} hex
 * @returns {boolean}
 */
function isColorDark(hex) {
    hex = hex.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);
    // Perceived brightness (ITU-R BT.601)
    const brightness = (r * 299 + g * 587 + b * 114) / 1000;
    return brightness < 128;
}

/**
 * @param {string[]|null|undefined} colors
 * @returns {boolean|null}
 */
function isColorsArrayDark(colors) {
    if (!colors || colors.length === 0)
        return null; // unknown
    const darkCount = colors.filter(c => isColorDark(c)).length;
    return darkCount > colors.length / 2;
}

/**
 * @param {Object.<string, any>} config
 * @param {boolean} systemDarkMode
 * @param {number} currentSearchTermIndex
 * @returns {QueryBuildResult}
 */
function buildQueryParameter(config, systemDarkMode, currentSearchTermIndex) {
    var userQuery = config.Query || "";
    let terms = userQuery.split(",");
    let termIndex = Math.floor(Math.random() * terms.length);
    if (termIndex === currentSearchTermIndex)
        termIndex = (termIndex + 1) % terms.length;

    let finalQuery = terms[termIndex].trim();
    // id: is an exact tag search and cannot be combined with other terms
    const isExactTagSearch = finalQuery.toLowerCase().startsWith("id:");
    if (config.FollowSystemTheme && systemDarkMode && !isExactTagSearch)
        finalQuery = (finalQuery ? finalQuery + " " : "") + "+dark";

    return {
        query: finalQuery,
        nextIndex: termIndex,
        queryParam: `q=${encodeURIComponent(finalQuery)}`
    };
}
