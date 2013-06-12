var albumID
var archiveID

function isImgur(txt) {
    if (location.hostname == "imgur.com") {
        if (txt.indexOf("imgur.com") == -1) return "";
        if (txt.indexOf("i.imgur.com") != -1) return "";
        if (txt.indexOf("/a/") == -1 && txt.indexOf(".imgur.com") == -1) return "";
        if (txt.indexOf("#") >= 0) txt = txt.substr(0, txt.indexOf("#"));
        if (txt.indexOf("/") == -1) return "";
        if (txt.substr(txt.length - 1) == "/") txt = txt.substr(0, txt.length - 1);
        if (txt.indexOf("/") == -1) return "";
        albumID = txt.substr(txt.lastIndexOf("/") + 1);
        if (txt.indexOf("/a/") >= 0 && albumID.length != 5) return "";
        return true;
    } else {
        return false;
    }

}

function isGonewild(txt) {
    if (location.hostname == "getgonewild.com") {
        txt = txt.replace("http://", "");
        txt = txt.replace("www.", "");
        txt = txt.replace("getgonewild.com/profile/", "");
        txt = txt.replace("/", "");
        albumID = txt;
        return true;
    } else if (location.hostname == "www.reddit.com") {
        txt = txt.replace("http://", "");
        txt = txt.replace("www.reddit.com/user/", "");
        txt = txt.replace("submitted", "");
        txt = txt.replace("/", "");
        albumID = txt;
        return true;
    } else {
        return false;
    }
}

function isInstagram(txt) {
    if (location.hostname == "web.stagram.com") {
        txt = txt.replace("http://", "");
        txt = txt.replace("www.", "");
        txt = txt.replace("web.stagram.com/n/", "");
        txt = txt.replace("/", "");
        albumID = txt;
        return true;
    } else {
        return false;
    }
}

function isSupported(theUrl) {
    if (isImgur(theUrl) == true) {
        archiveID = "#imgur.com%2Fa%2F" + albumID;
        return true;
    } else if (isGonewild(theUrl) == true) {
        archiveID = "#getgonewild.com%2Fprofile%2F" + albumID;
        return true;
    } else if (isInstagram(theUrl) == true) {
        archiveID = "#web.stagram.com%2Fn%2F" + albumID + "%2F";
        return true;
    } else {
        return false;
    }
}

function ripAlbum(theUrl) {
    if (isSupported(theUrl) == true) {
        window.open("http://rip.rarchives.com/" + archiveID);
        return;
    } else {
        return "Website not supported.";
    }
}

ripAlbum(location.href);
