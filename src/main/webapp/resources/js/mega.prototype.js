var Constants               = {};
Constants.SEPARATOR_DATE    = ".";
Constants.SEPARATOR_TIME    = ":";
Constants.SEPARATOR_NUMBER  = ",";
Constants.SEPARATOR_DEFAULT = "-";
Constants.DATE_FORMAT       = "yyyy" + Constants.SEPARATOR_DATE + "mm" + Constants.SEPARATOR_DATE + "dd";
Constants.DATE_FORMAT_CAL   =   "yy" + Constants.SEPARATOR_DATE + "mm" + Constants.SEPARATOR_DATE + "dd";
Constants.TIME_FORMAT       =   "hh" + Constants.SEPARATOR_TIME + "mi" + Constants.SEPARATOR_TIME + "ss";


/**
 * String.nvl() method 구현
 */
String.prototype.nvl = function() {
    return ( this == null ) ? "" : this;
};

String.prototype.nvlNum = function(initVal) {
    return ( this == null ) ? initVal : (this == "" ) ? initVal : this;
};
/**
 * String.trim() method 구현
 */
String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/gi, "");
};

/**
 * String.ltrim() method 구현
 */
String.prototype.ltrim = function() {
    return this.replace(/(^\s*)/g, "");
};

/**
 * String.rtrim() method 구현
 */
String.prototype.rtrim = function() {
    return this.replace(/(\s*$)/g, "");
};

/**
 * String.lpad() method 구현
 */
String.prototype.lpad = function(padLength, padChar) {
    padChar = padChar == null ? " " : padChar;
    var result = "";
    for (var i = 0, n = padLength - this.byteLength(); i < n; i++) {
        result += padChar;
    }

    return result + this;
};


/**
 * String.rpad() method 구현
 */
String.prototype.rpad = function(padLength, padChar) {
    padChar = padChar == null ? " " : padChar;
    var result = this;
    for (var i = 0, n = padLength - this.byteLength(); i < n; i++) {
        result += padChar;
    }

    return result;
};


/**
 * String.replaceAll(from, to) method 구현

*/
String.prototype.replaceAll = function(from, to) {
//	return this.replace(new RegExp(from, "g"), to);
    return this.split(from).join(to);
};

/**
 * String.removeAll(ch) method 구현
 */
String.prototype.removeAll = function(ch) {
    return this.replaceAll(ch, "");
};


/**
 * String.reverse() method 구현
 */

String.prototype.reverse = function() {
    var result = "";
    var i = this.length;

    while (i > 0) {
        result += this.charAt(--i);
    }

    return result;
};

/**
 * String.byteLength() method 구현
 */
String.prototype.byteLength = function() {
    var result = 0;
    for (var i = 0; i < this.length; i++) {
        var chr = escape(this.charAt(i));
        if (chr.length == 1 ) {
            result++;
        } else if (chr.indexOf("%u") != -1) {
            result += 2;
        } else if (chr.indexOf("%") != -1) {
            result += chr.length / 3;
        }
    }
    return result;
};


/**
 * String.byteIndexOf() method 구현
 */
String.prototype.byteIndexOf = function(chr) {
    var idx = this.indexOf(chr);
    if (idx == -1) {
        return idx;
    } else {
        return this.substring(0, idx).byteLength();
    }
};


/**
 * String.substringByte() method 구현
 */
String.prototype.substringByte = function (start, end) {
    var result = "";

    var preByte = 0;
    var curByte = 0;

    for (var i = 0; i < this.length; i++) {
        var chr = this.charAt(i);

        preByte = curByte;
        curByte += chr.byteLength();

        if (preByte >= start && curByte <= end) {
            result += chr;
        } else if (curByte > end) {
            break;
        }
    }

    return result;
};


/**
 * String.substrByte() method 구현
 */
String.prototype.substrByte = function(start, length) {
    return this.substringByte(start, start + length);
};

/**
 * String.defaultString() method 구현
 * description : String 값이 "" 이면 def를 반환
 */
String.prototype.defaultString = function(def) {
    return this.trim() == "" ? def : this;
};


/**
 * String.toInt() method 구현
 */
String.prototype.toInt = function() {
    return this.trim() == "" ? 0 : parseInt(this.trim(), 10);
};


/**
 * String.toHex() method 구현 : 16진수 구하기
 */
String.prototype.toHex = function() {
    return this.toRadix(16);
};


/**
 * String.toRadix() method 구현 : radix 진수 구하기
 */
String.prototype.toRadix = function(radix) {
    return Number(this).toString(radix).toUpperCase();
};


/**
 * String.isEmpty() method 구현
 */
String.prototype.isEmpty = function() {
    return this.trim().length == 0;
};


/**
 * String값을 Number type으로 반환
 */
String.prototype.toNumber = function() {
    return (!this.isNumber()) ? 0 : Number(this.unmask("real")) ;
};


/**
 * String값을 Date 객체로 반환
 */
String.prototype.toDate = function() {
    var sDate  = this.unmask("dateymd");
    var iYear  = sDate.substr(0, 4).toNumber();
    var iMonth = sDate.substr(4, 2).defaultString("0").toNumber() - 1;
    var iDate  = sDate.substr(6, 2).defaultString("1").toNumber();
    return new Date(iYear, iMonth, iDate);
};
String.prototype.toDateTime = function(time){
    var pDate = "";
    var pTime = "";
    if ( time ) {
        pDate = this;
        pTime = time;
    } else {
        pDate = this.split(" ")[0].unmask("dateymd");
        pTime = this.split(" ")[1].unmask("timehms");
    }
    var iYear  = pDate.substr(0, 4).toNumber();
    var iMonth = pDate.substr(4, 2).toNumber() - 1;
    var iDate  = pDate.substr(6, 2).toNumber();
    var dDate = new Date(iYear, iMonth, iDate);
    if ( pTime ) {
        var iH = pTime.substr(0, 2).toNumber();
        var iM = pTime.substr(2, 2).toNumber();
        var iS = pTime.substr(4, 2).toNumber();
        dDate.setHours(iH,iM,iS);
    }
    return dDate;
}
/**
 * String.isDigit() method 구현
 */
String.prototype.isDigit = function() {
    if (this.isEmpty()) {
        return true;
    }

    return this.search(/^\d+$/) != -1;
};

/**
 * String.isInt() method 구현
 */
String.prototype.isInt = function() {
    if (this.isEmpty()) {
        return true;
    }

    return this.search(/^(?:\-?|\+?)\d+$/) != -1;
};

/**
 * String.isDouble() method 구현
 */
String.prototype.isDouble = function(dec,frac) {
    if (this.isEmpty()) {
        return true;
    }
    oriStr  = this.removeAll(",");
    if (oriStr.indexOf(".") >= 0) {
        decStr  = oriStr.substring(0,oriStr.indexOf("."));
        fracStr = oriStr.substring(oriStr.indexOf(".")+1);
    } else {
        decStr  = oriStr;
        fracStr = "";
    }
    if (dec < decStr.length || frac < fracStr.length) return false;

    return !isNaN(oriStr);
};

/**
 * String.isNumber() method 구현
 */
String.prototype.isNumber = function() {
    if (this.isEmpty()) {
        return true;
    }
    return !isNaN(this);
};


/**
 * String.isCardNo() method 구현 - 카드번호
 */
String.prototype.isCardNo = function() {
    if (this.isEmpty()) {
        return true;
    }

    return this.search(/^\d{4}\-?\d{4}\-?\d{4}\-?\d{4}$/) != -1;
};



/**
 * String.isIdNo() method 구현 - 주민등록번호
 */
String.prototype.isIdNo = function() {
    if (this.isEmpty()) {
        return true;
    }

    if (this.search(/^\d{6}\-?\d{7}$/) == -1) {
        return false;
    }

    var sRegNo = this.removeAll("-");
    var iSum   = 0;
    for (var i = 0; i < sRegNo.length - 1; i++) {
        iSum += (sRegNo.charAt(i) * (i % 8 + 2));
    }

    return sRegNo.charAt(12) == (11 - iSum % 11) % 10;
};



/**
 * String.isBizNo() method 구현 - 사업자등록번호
 */
String.prototype.isBizNo = function() {
    if (this.isEmpty()) {
        return true;
    }

    if (this.search(/^\d{3}\-?\d{2}\-?\d{5}$/) == -1) {
        return false;
    }

    var sBizNo = this.removeAll("-");
    var aCheckNo = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1);
    var iSum = 0;

    for (var i = 0; i < sBizNo.length; i++) {
        iSum += sBizNo.charAt(i) * aCheckNo[i] % 10;

        if (i == 8) {
            iSum += Math.floor(sBizNo.charAt(i) * aCheckNo[i] / 10);
        }
    }

    return iSum % 10 == 0;
};


/**
 * String.isCorpNo() method 구현 - 법인등록번호
 */
String.prototype.isCorpNo = function() {
    if (this.isEmpty()) {
        return true;
    }

    if (this.search(/^\d{6}\-?\d{7}$/) == -1) {
        return false;
    }

    var sCorpNo = this.removeAll("-");
    var iSum = 0;

    for (var i = 0; i < sCorpNo.length - 1; i++) {
        iSum += (sCorpNo.charAt(i) * (i % 2 + 1));
    }

    return sCorpNo.charAt(12) == (10 - iSum % 10);
};


String.prototype.escape = function(string) {
    return string.replace(/('|\\)/g, "\\$1");
};

/**
 * String.isZipNo() method 구현 - 우편번호
 */
String.prototype.isZipNo = function() {
    if (this.isEmpty()) {
        return true;
    }

    return this.search(/^\d{3}\-?\d{3}$/) != -1;
};


/**
 * String.isPhoneNo() method 구현 - 전화번호
 */
String.prototype.isPhoneNo = function() {
    if (this.isEmpty()) {
        return true;
    }

    return this.search(/^(?:0\d{1,2}\-?\d{2,4}|\d{2,4})\-?\d{4}$/) != -1;
};

/**
 * String.isHpPhoneCode() method 구현 - 휴대전화번호 국번
 */
String.prototype.isHpPhoneCode = function() {
    if (this.isEmpty()) {
        return true;
    }
    console.log(this);

    return this.search(/^01(?:0|1|[6-9])/) != -1;
};

/**
 * String.isHpPhoneNo() method 구현 - 휴대전화번호
 */
String.prototype.isHpPhoneNo = function() {
    if (this.isEmpty()) {
        return true;
    }

    return this.search(/^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/) != -1;
};

/**
 * String.isYMD() method 구현 - 날짜
 * 구분자 => / or - or .
 */
String.prototype.isYMD = function() {
    if (this.isEmpty()) {
        return true;
    }

    if (this.search(/^(\d{4})[\/|\-|.]?(\d{2})[\/|\-|.]?(\d{2})$/) == -1) {
        return false;
    }

    var lastDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (RegExp.$2 > 12 || RegExp.$2 < '01') {
        return false;
    }

    if (RegExp.$3 > lastDays[RegExp.$2 - 1] || RegExp.$3 < '01') {
        return false;
    }

    if (RegExp.$2 == 2
            && RegExp.$3 > 28
            && (RegExp.$1 % 4 != 0 || (RegExp.$1 % 100 == 0 && RegExp.$1 % 400 != 0))) {
        return false;
    }

    return true;
};



/**
 * String.isYM() method 구현 - 날짜
 * 구분자 => / or - or .
 */
String.prototype.isYM = function() {
    if (this.isEmpty()) {
        return true;
    }

    if (this.search(/^(\d{4})[\/|\-|.]?(\d{2})$/) == -1) {
        return false;
    }

    if (RegExp.$2 > 12 || RegExp.$2 < '01') {
        return false;
    }

    return true;
};


/**
 * String.isMD() method 구현 - 날짜
 * 구분자 => / or - or .
 */
String.prototype.isMD = function() {
    if (this.isEmpty()) {
        return true;
    }
    if (this.search(/^(\d{2})[\/|\-|.]?(\d{2})$/) == -1) {
        return false;
    }

    var lastDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (RegExp.$1 > 12 || RegExp.$1 < '01') {
        return false;
    }

    if (RegExp.$2 > lastDays[RegExp.$1 - 1] || RegExp.$2 < '01') {
        return false;
    }
    return true;
};



/**
 * String.isHMS() method 구현 - 시간
 */
String.prototype.isHMS = function() {
    if (this.isEmpty()) {
        return true;
    }

    if (this.search(/^([0|1|2]\d):?(\d{2})?:?(\d{2})?$/) == -1) {
        return false;
    }

    if (RegExp.$1 > 23 || RegExp.$2 > 59 || RegExp.$3 > 59) {
        return false;
    }

    return true;
};



/**
 * String.isMS() method 구현 - 시간
 */
String.prototype.isMS = function() {
    if (this.isEmpty()) {
        return true;
    }

    if (this.search(/^(\d{2}):?(\d{2})$/) == -1) {
        return false;
    }

    if (RegExp.$1 > 59 || RegExp.$2 > 59) {
        return false;
    }

    return true;
};


/**
 * String.isEmail() method 구현 - email
 */
String.prototype.isEmail = function() {
    if (this.isEmpty()) {
        return true;
    }

    var checkTLD = 1;
    var knownDomsPat = /^(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum|dev)$/;
    var emailPat = /^(.+)@(.+)$/;
    var specialChars = "\\(\\)><@,;:\\\\\\\"\\.\\[\\]";
    var validChars = "\[^\\s" + specialChars + "\]";
    var quotedUser = "(\"[^\"]*\")";
    var ipDomainPat = /^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/;
    var atom = validChars + '+';
    var word = "(" + atom + "|" + quotedUser + ")";
    var userPat = new RegExp("^" + word + "(\\." + word + ")*$");
    var domainPat = new RegExp("^" + atom + "(\\." + atom +")*$");
    var matchArray = this.match(emailPat);

    if (matchArray == null) {
        return false;
    }

    var user = matchArray[1];
    var domain = matchArray[2];

    for (var i = 0; i < user.length; i++) {
        if (user.charCodeAt(i) > 127) {
            return false;
       }
    }

    for (var i = 0; i < domain.length; i++) {
        if (domain.charCodeAt(i) > 127) {
            return false;
        }
    }

    if (user.match(userPat) == null) {
        return false;
    }

    var ipArray = domain.match(ipDomainPat);

    if (ipArray != null) {
        for (var i = 1;i <= 4; i++) {
            if (ipArray[i] > 255) {
                return false;
             }
        }
        return true;
    }

    var atomPat = new RegExp("^" + atom + "$");
    var domArr = domain.split(".");
    var len = domArr.length;

    for (i = 0; i < len; i++) {
        if (domArr[i].search(atomPat) == -1) {
            return false;
       }
    }

    if (checkTLD && domArr[domArr.length - 1].length != 2
        && domArr[domArr.length - 1].search(knownDomsPat) == -1) {
        return false;
    }

    return len >= 2;
};
/**
 * String.isFormat() method 구현 - 특정 포맷에 맞는 형식인가
 */
String.prototype.isFormat = function() {

    if (this.isEmpty()) {
        return true;
    }

    var formatStr = arguments[0].split("-");
    var searchStr = "this.search(/^";
    for (var _i=0; _i < formatStr.length; _i++) {
        if (_i==0) {
            searchStr += "\\d{"+formatStr[_i]+"}";
        } else {
            searchStr += "\\-?\\d{"+formatStr[_i]+"}";
        }
    }
    searchStr += "$/) != -1;";

    return eval(searchStr);
};


/**
 * String의 각 표현형식별 mask 처리하여 반환
 */
String.prototype.mask = function(preset) {
    var result = null;

    // preset에 () 형식이 포함될 경우 - 특정 format 처리
    if (preset.indexOf("(") >= 0 && preset.indexOf(")") >=0 ) {
        var formatStr = preset.substring(preset.indexOf("(")+1,preset.indexOf(")"));
        preset = preset.substring(0,preset.indexOf("("));
        result = this.maskFormat(formatStr);

    // 일반적인 경우
    } else {
        switch (preset.toLowerCase()) {
            case "number":
                break;
            case "numberdot":
                break;
            case "numberplus":
                break;
            case "amtplus":
            case "amt":
            case "amtdot":
                result = this.maskNumber();
                break;

            case "ymdhms":
            case "ymdhm":
                result = this.maskDateTime();
                break;

            case "dateymd":
            case "dateym":
                result = this.maskDate();
                break;

            case "datemd":
                result = this.maskDateMD();
                break;

            case "timehms":
            case "timehm":
            case "timems":
                result = this.maskTime();
                break;

            case "telno":
            case "hpno":
                result = this.maskPhoneNo();
                break;

            case "cardno":
                result = this.maskCardNo();
                break;

            case "idno":
            case "corpno":
                result = this.maskIdNo();
                break;

            case "bizno":
                result = this.maskBizNo();
                break;

            case "corp":
                result = this.maskIdNo();
                break;

            case "zipno":
                result = this.maskZipNo();
                break;

            default:
                result = this;
                break;
        }
    }
    if (result == null || result == "undefined") result = this;
    return result;
};


/**
 * String의 각 표현형식별 mask 처리 삭제하여 반환
 */
String.prototype.unmask = function(preset) {
    var result = null;

    // preset에 () 형식이 포함될 경우
    if (preset.indexOf("(") >= 0 && preset.indexOf(")") >=0 ) {
        result = this.removeAll(Constants.SEPARATOR_DEFAULT);

    // 일반적인 경우
    } else {

        switch (preset.toLowerCase()) {
            case "number":
            case "numberdot":
            case "numberplus":
            case "amt":
                result = this.removeAll(Constants.SEPARATOR_NUMBER);
                break;

            case "dateymd":
            case "dateym":
            case "datemd":
                result = this.removeAll(Constants.SEPARATOR_DATE);
                break;

            case "timehms":
            case "timehm":
            case "timems":
                result = this.removeAll(Constants.SEPARATOR_TIME);
                break;

            case "telno":
            case "hpno":
            case "cardno":
            case "idno":
            case "bizno":
            case "corpno":
            case "zipno":
                result = this.removeAll(Constants.SEPARATOR_DEFAULT);
                break;

            default:
                result = this.trim();
                break;
        }
    }
    if (result == null || result == "undefined") result = this;

    return result;
};


/**
 * String을 comma가 추가된 number type으로 반환
 */
String.prototype.maskNumber = function() {
    var sInt = this.removeAll(Constants.SEPARATOR_NUMBER);

    var sSign = sInt.charAt(0);
    if (sSign == "-" || sSign == "+") {
        sInt = sInt.substr(1);
        sSign = sSign == "+" ? "" : "-";
    } else {
        sSign = "";
    }

    var iPointIdx = sInt.indexOf(".");
    var sDecimal = "";
    if (iPointIdx > -1) {
        sDecimal = sInt.substr(iPointIdx);
        sInt = sInt.substr(0, iPointIdx);
    }

    if (sInt.length <= 3) {
        return sSign + sInt + sDecimal;
    }

    var sReverseInt = sInt.reverse();
    var sReverseResult = "";

    for(var i = 0, n = sReverseInt.length; i < n; i += 3) {
        sReverseResult += sReverseInt.substr(i, 3);
        if (i + 3 < n) {
            sReverseResult += Constants.SEPARATOR_NUMBER;
        }
    }

    return sSign + sReverseResult.reverse() + sDecimal;
};


/**
 * String을 날짜구분자가 추가된 형식으로 반환
 */
String.prototype.maskDateTime = function() {
    var sDateTime = this.removeAll(Constants.SEPARATOR_DATE)
                        .removeAll(Constants.SEPARATOR_TIME)
                        .removeAll(" ");
    var sDate = sDateTime.substring(0, 8);
    var sTime = sDateTime.substring(8);

    return sDate.maskDate() + " " + sTime.maskTime();
};


/**
 * String을 날짜구분자가 추가된 형식으로 반환
 */
String.prototype.maskDate = function() {
    var sDate = this.removeAll(Constants.SEPARATOR_DATE);
    var len = sDate.length;

    if (len <= 4) {
        return sDate;
    } else if (len <= 6) {
        return sDate.substr(0, 4)
             + Constants.SEPARATOR_DATE
             + sDate.substr(4);
    } else if (len <= 8) {
        return sDate.substr(0, 4)
             + Constants.SEPARATOR_DATE
             + sDate.substr(4, 2)
             + Constants.SEPARATOR_DATE
             + sDate.substr(6);
    }
};

/**
 * String을 날짜구분자가 추가된 형식으로 반환
 */
String.prototype.maskDateMD = function() {
    var sDate = this.removeAll(Constants.SEPARATOR_DATE);
    var len = sDate.length;

    if (len <= 2) {
        return sDate;
    } else if (len <= 4) {
        return sDate.substr(0, 2)
             + Constants.SEPARATOR_DATE
             + sDate.substr(2);
    }
};

/**
 * String을 시간구분자가 추가된 형식으로 반환
 */
String.prototype.maskTime = function() {
    var sTime = this.removeAll(Constants.SEPARATOR_TIME);
    var len = sTime.length;

    if (len <= 2) {
        return sTime;
    } else if (len <= 4) {
        return sTime.substr(0, 2)
             + Constants.SEPARATOR_TIME
             + sTime.substr(2);
    } else {
        return sTime.substr(0, 2)
             + Constants.SEPARATOR_TIME
             + sTime.substr(2, 2)
             + Constants.SEPARATOR_TIME
             + sTime.substr(4, 2);
    }
};


/**
 * String을 전화번호 구분자가 추가된 형식으로 반환
 */
String.prototype.maskPhoneNo = function() {
    var phoneNo = this.removeAll(Constants.SEPARATOR_DEFAULT);

    var idx = 0;
    var result = "";

    if (phoneNo.substr(0, 2) == "02") {
        result += (phoneNo.substr(0, 2) + Constants.SEPARATOR_DEFAULT);
        idx = 2;
    } else if (phoneNo.charAt(0) == "0") {
        result += (phoneNo.substr(0, 3) + Constants.SEPARATOR_DEFAULT);
        idx = 3;
    }

    if (phoneNo.substr(idx).length < 4) {
        result += phoneNo.substr(idx);
    } else if (phoneNo.substr(idx).length < 8) {
        result += (phoneNo.substr(idx, 3)
                   + Constants.SEPARATOR_DEFAULT
                   + phoneNo.substr(idx + 3));
    } else {
        result += (phoneNo.substr(idx, 4)
                   + Constants.SEPARATOR_DEFAULT
                   + phoneNo.substr(idx + 4));
    }

    return result;
};


/**
 * String을 카드번호 구분자가 추가된 형식으로 반환
 */
String.prototype.maskCardNo = function() {
    var cardNo = this.removeAll(Constants.SEPARATOR_DEFAULT);

    if (cardNo.length <= 4) {
        return cardNo;
    } else if (cardNo.length <= 8) {
        return cardNo.substr(0, 4)
             + Constants.SEPARATOR_DEFAULT
             + cardNo.substr(4)
    } else if (cardNo.length <= 12) {
        return cardNo.substr(0, 4)
             + Constants.SEPARATOR_DEFAULT
             + cardNo.substr(4, 4)
             + Constants.SEPARATOR_DEFAULT
             + cardNo.substr(8)
    } else {
        return cardNo.substr(0, 4)
             + Constants.SEPARATOR_DEFAULT
             + cardNo.substr(4, 4)
             + Constants.SEPARATOR_DEFAULT
             + cardNo.substr(8, 4)
             + Constants.SEPARATOR_DEFAULT
             + cardNo.substr(12);
    }
};


/**
 * String을 주민등록번호 구분자가 추가된 형식으로 반환
 */
String.prototype.maskIdNo = function() {
    var idNo = this.removeAll(Constants.SEPARATOR_DEFAULT);

    if (idNo.length <= 6) {
        return idNo;
    } else {
        return idNo.substr(0, 6)
             + Constants.SEPARATOR_DEFAULT
             + idNo.substr(6);
    }
};


/**
 * String을 사업자등록번호 구분자가 추가된 형식으로 반환
 */
String.prototype.maskBizNo = function() {
    var bizNo = this.removeAll(Constants.SEPARATOR_DEFAULT);

    if (bizNo.length <= 3) {
        return bizNo;
    } else if (bizNo.length <= 5) {
        return bizNo.substr(0, 3)
             + Constants.SEPARATOR_DEFAULT
             + bizNo.substr(3)
    } else {
        return bizNo.substr(0, 3)
             + Constants.SEPARATOR_DEFAULT
             + bizNo.substr(3, 2)
             + Constants.SEPARATOR_DEFAULT
             + bizNo.substr(5);
    }
};


/**
 * String을 우편번호 구분자가 추가된 형식으로 반환
 */
String.prototype.maskZipNo = function() {
    var zipNo = this.removeAll(Constants.SEPARATOR_DEFAULT);

    if (zipNo.length <= 3) {
        return zipNo;
    } else {
        return zipNo.substr(0, 3)
             + Constants.SEPARATOR_DEFAULT
             + zipNo.substr(3);
    }
};

/**
 * String을 "-" 구분자가 추가된 특정 형식으로 반환
 */
String.prototype.maskFormat = function() {
    var formatValue = this.removeAll(Constants.SEPARATOR_DEFAULT);
    var formatStr = arguments[0].split("-");

    var resultStr = "";
    var resultIdx = 0;
    for (var _i=0; _i<formatStr.length; _i++) {
        if ((resultIdx+parseInt(formatStr[_i])) >= formatValue.length) {
            if (_i==0) {
                resultStr += formatValue.substring(resultIdx, resultIdx+parseInt(formatStr[_i]));
            } else {
                resultStr += "-" + formatValue.substring(resultIdx, resultIdx+parseInt(formatStr[_i]));
            }
            return resultStr;
        } else {
            if (_i==0) {
                resultStr += formatValue.substring(resultIdx, resultIdx+parseInt(formatStr[_i]));
            } else {
                resultStr += "-" + formatValue.substring(resultIdx, resultIdx+parseInt(formatStr[_i]));
            }
            resultIdx += parseInt(formatStr[_i]);
        }
    }
    return resultStr;
};
/*
 * "20190101".format("XXXX.XX.XX")            => "2019.01.01"
 * "1234".format("XX:XX")                     => "12:34"
 * "X123456789".format("Z:ZZZ-ZZZ-ZZZ","Z")   => "X:123-456-789"
 *
 * */
String.prototype.format = function(fmt ,fmtVal){
    fmtVal = fmtVal || "X";
    var _this = this;

    if ( _this.length == fmt.length - fmt.removeAll(fmtVal).length ) {
        var k = 0;
        return fmt.split("").map(function(o,i) { return ( o == fmtVal ? _this.charAt(k++) : o ) ;}).join("");
    } else {
        return _this;
    }
}
/*
 * "img.jpg".posterFormat('_316')         => "img_316.jpg"
 *
 * */
String.prototype.posterFormat = function(fmt){
	if( this != null && this != 'null' && this.length > 0 && this.lastIndexOf('.') > 0 ){

		if( this.indexOf("/SharedImg/asis/") > -1 ) {

			var chStr = "";

			if( fmt == "_230" || fmt == "_150" ) {
				chStr = ".medium";
			}else if( fmt == "_150" ) {
				chStr = ".small";
			}

			//스토어
			if( this.indexOf("/store") > -1 ) {
				if( fmt == "_280" ) {
					chStr = ".medium";
				}else if( fmt == "_196" ) {
					chStr = ".small";
				}
			}

			if( chStr.length > 0 ) {
				return this.replaceAll(".large", chStr);
			}else{
				return this.replaceAll(fmt, ".large");
			}

		}else{
			if( this.lastIndexOf('_') > 0 ) {
				return this.slice(0, this.lastIndexOf('_')) + fmt + this.slice(this.lastIndexOf('.'));
			}else{
				return this.slice(0, this.lastIndexOf('.')) + fmt + this.slice(this.lastIndexOf('.'));
			}
		}
	}

	return this;
}

/*
 * "139472711112".megaFormat() => 1394-727-11112
 * */
String.prototype.bokdFormat = function() {
	var _this = this.toString();

	if ( _this.length != 12) return _this;

	return _this.format("XXXX-XXX-XXXXX");
}

/*
 * "139472711112".megaFormat() => 1394-7271-1112
 * */
String.prototype.cponFormat = function() {
	var _this   = this.toString();
	var format = "XXXX";
	var loopCnt = (_this.length/4)-1;

	while(loopCnt--) {
		if (loopCnt < 0) break;
		format += "-XXXX";
	}

	return _this.format(format);
}

/*
 * "139472711112".cponFormat() => 1394 7271 1112
 * */
String.prototype.cardFormat = function() {
	var _this   = this.toString();
	var format = "XXXX";
	var loopCnt = (_this.length/4)-1;

	while(loopCnt--) {
		if (loopCnt < 0) break;
		format += " XXXX";
	}

	return _this.format(format);
}

/*
 * "20191104101010".payDtFormat() => 2019.11.04 (10:10)
 * */
String.prototype.payDtFormat = function() {
	var _this = this.toString();

	if ( _this.length > 12) _this = _this.substring(0, 12);

	return _this.format("XXXX.XX.XX (XX:XX)");
}
String.prototype.payDtFormat2 = function() {
	var _this = this.toString();

	if ( _this.length > 12) _this = _this.substring(0, 12);

	return _this.format("XXXX.XX.XX XX:XX");
}
/*
 * "20190621"      .megaFormat()          => "2019.06.21 (금)"
 * "201906212530"  .megaFormat()          => "2019.06.21 (금) 25:30"
 * "20190621233025".megaFormat()          => "2019.06.21 (금) 23:30:25"
 *
 * */
String.prototype.megaFormat = function(localeCode, type){
    var _this = this.toString();
    var _this_length = _this.length;
    if ( _this_length != 8 && _this_length != 12 && _this_length != 14) {
        return _this;
    }
    var _dt = _this.substring(0,8);
    if(typeof localeCode !== "undefined" && localeCode == "en") {
    	_dt += ['Sun', 'Mon','Tue','Wed','Thu','Fri','Sat'][new Date(_dt.format("XXXX-XX-XX")).getDay()];
    }else{
    	_dt += ['일','월','화','수','목','금','토'][new Date(_dt.format("XXXX-XX-XX")).getDay()];
    }

    var _tm = "";
    if ( _this_length > 8 ) {
        _tm = _this.substring(8);
        if ( _this_length == 12 ) {
            _tm = _tm.format(" XX:XX");
        } else {
            _tm = _tm.format(" XX:XX:XX");
        }
    }

    if (type == 'M') {
        _dt = _dt.substring(4);
        if(typeof localeCode !== "undefined" && localeCode == "en") {
            _this = _dt.format("XX.XX (XXX)") + _tm;
        }else{
            _this = _dt.format("XX.XX (X)") + _tm;
        }
    } else {
        if(typeof localeCode !== "undefined" && localeCode == "en") {
            _this = _dt.format("XXXX.XX.XX (XXX)") + _tm;
        }else{
            _this = _dt.format("XXXX.XX.XX (X)") + _tm;
        }
    }

    return _this;
}

String.prototype.escapeHtml = function(){
	return this.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/\"/g, "&quot;");
}

String.prototype.escapeBlackList = function() {
    return this.toLowerCase().replace(/javascript|script|iframe|document|vbscript|applet|embed|object|frame|grameset|layer|details|img|svg|bgsound|data:image\/svg\+xml|alert|onblur|onchange|onclick|ondblclick|enerror|onfocus|onload|onmouse|onmouseover|onmouseload|onscroll|onsubmit|ontoggle|onunload/g, (match) => `x-${match}`);
};

String.prototype.unescapeHtml = function(){
    if(jQuery) {
        return $("<div />").html(this).text();
    } else {
        return this.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g, "\"")
            .replace(/&#40;/g, "(").replace(/&#41;/g, ")").replace(/&#35;/g, "#").replace(/&#39;/g, "'");
    }
}

Date.day;
Date.prototype.getSystemDate = function(){
    //var day = new Date($.ajaxMegaBox({ url : "/getSystemDate",async : false }).responseJSON.sysDate.toDay);
	var day = new Date($.ajaxMegaBox({ url : "/getSystemDate",async : true }).responseJSON.sysDate.toDay);
    return ( !Date.day || day.formatDate() !== Date.day.formatDate() ) ? Date.day = day : Date.day;
}

Date.prototype.formatDate = function(format) {
    var date = this;
    if (!format) {
        format = Constants.DATE_FORMAT;
    }

    var month = date.getMonth() + 1;
    var year = date.getFullYear();


    format = format.replaceAll("mm",month.toString().lpad(2,"0"));

    if (format.indexOf("yyyy") > -1) {
        format = format.replace("yyyy",year.toString());
    } else if (format.indexOf("yy") > -1) {
        format = format.replace("yy",year.toString().substr(2,2));
    }

    format = format.replace("dd",date.getDate().toString().lpad(2,"0"));

    var hours = date.getHours();
    if (format.indexOf("t") > -1) {
       if (hours > 11) {
           format = format.replace("t","pm");
       } else {
           format = format.replace("t","am");
       }
    }
    if (format.indexOf("hh") > -1)
        format = format.replace("hh",hours.toString().lpad(2,"0"));
    if (format.indexOf("hh") > -1) {
        if (hours > 12) hours - 12;
        if (hours == 0) hours = 12;
        format = format.replace("hh",hours.toString().lpad(2,"0"));
    }
    if (format.indexOf("mi") > -1)
       format = format.replace("mi",date.getMinutes().toString().lpad(2,"0"));
    if (format.indexOf("ss") > -1)
       format = format.replace("ss",date.getSeconds().toString().lpad(2,"0"));
    return format;
};
Number.prototype.format = function(){
    if(this==0) return 0;
    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (this + '');
    while (reg.test(n)) n = n.replace(reg, '$1' + Constants.SEPARATOR_NUMBER + '$2');
    return n;
};
Number.prototype.round = function(decimals) {
    if (decimals > 0) {
        var m = this.toFixed(decimals + 1).match(
            new RegExp("(-?\\d*)\.(\\d{" + decimals + "})(\\d)\\d*$"));
        if (m && m.length) {
            return new Number(m[1] + "." + String(Math.round(m[2] + "." + m[3])).lpad(decimals, "0"));
        }
    }
    return this;
};
if (!Object.entries) {
    Object.entries = function( obj ){
      var ownProps = Object.keys( obj ),
          i = ownProps.length,
          resArray = new Array(i); // preallocate the Array
      while (i--)
        resArray[i] = [ownProps[i], obj[ownProps[i]]];

      return resArray;
    };
}
if (!Object.fromEntries) {
  Object.fromEntries = function( obj ){
    var i = obj.length,
        resArray = {}; // preallocate the Array
    while (i--)
      resArray[obj[i][0]] = obj[i][1];
    return resArray;
  };
}


Math.sign = function(v){
    return v > 0 ? 1 : v == 0 ? 0 : -1;
}

