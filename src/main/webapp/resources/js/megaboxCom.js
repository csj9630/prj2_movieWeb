/**
* 용도  : 공통코드 조회 및 동적생성 함수
* 변수  : codeGrp -> 조회할 공통코드의 그룹 코드 ","로 구분하여 다중처리
*       obj     -> UI에 선언된 element ID ","로 구분하여 다중 처리
*       fstOpt  -> 첫번째 코드에 전체 및 선택 표시 여부 (A:전체, S:선택, N:null, radio는 무조건N)
* 비고   : radio의 경우 미리 생성한 radio버튼을 삭제하고 공통코드로 재생성, 미리 생성한 radio는 텍스트가 없어야한다.
*/
var gfn_getCodes = function (codeGrp, obj, fstOpt){

    var codeParam  = { grpCd:codeGrp,DATA_PREFIX:"CMMCD_" };
    var codeGrpArr = codeGrp.split(",");
    var objArr     = obj.split(",");
    var fstOptArr  = fstOpt.split(",");
    var retnInx    = 0;
    var uiObj      = "";

    $.ajax({
            type       : "POST",
             contentType: "application/json;charset=UTF-8",
             url        : "/co/coc/CommCdMapp/selectCommCdMappList.do",
             dataType   : "json",
             data       : JSON.stringify({dlParam:codeParam}),
             success: function(result){
                var keyArrs = Object.keys(result);

                  for( var i = 0 ; i < keyArrs.length ; i++){
                    if(keyArrs[i].indexOf("CMMCD_") > -1){
                        retnInx = codeGrpArr.indexOf(keyArrs[i].substr(6));
                        uiObj   = objArr[retnInx];

                        if($("#"+uiObj).is("select")){
                            //SELECT BOX 초기화
                            $("#"+uiObj).find("option").remove();
                            if(fstOptArr[retnInx] == "A"){
                                $("#"+uiObj).append("<option value=''>전체</option>");
                            }else if(fstOptArr[retnInx] == "S"){
                                $("#"+uiObj).append("<option value=''>선택</option>");
                            }

                            //배열 개수 만큼 option 추가
                               $.each(result[keyArrs[i]], function(i){
                                   $("#"+uiObj).append("<option value='"+this.cdId+"'>"+this.cdNm+"</option>");
                            });
                        }else if($("#"+uiObj).is(':radio')){

                            //배열 개수 만큼 radio 추가
                               $.each(result[keyArrs[i]], function(i){
                                   $("#"+uiObj).before("<input type='radio' name='"+uiObj+"' id='" + (uiObj+i) + "' value='"+this.cdId+"' />"+this.cdNm+"&nbsp; ");
                            });

                            //초기 radio 삭제
                               $("#"+uiObj).remove();
                        }
                      }
                  }
              },
               error: function (jqXHR, textStatus, errorThrown) {
                   gfn_alertMsgBox("공통 코드 조회 시 오류가 발생하였습니다.");
              }
    });
}




/**
* 용도  : 업무테이블 데이터 조회 및 콤보구성 함수
* 변수  : schPrarms -> action    : 조회 controller url
*                     paramData : 조회 조건
*                     uiComp    : UI 컴포넌트 ID
*                     cdId      : code column
*                     cdName    : value column
*                     etcId     : 기타 조회 정보 컬럼 ID
*                     etcAttr   : user attribute Name
*                     allText   : 전체 선택 시 출력할 문자열
*/
var gfn_getAppDataToCodes = function (schPrarms){

    var optValue   = "";
    var optTxt     = "";
    var optEtcValue= "";
    var optEtcAttr = "";

    for(var i = 0 ; i < schPrarms.length ; i++){

        $.ajax({
            type       : "POST",
             contentType: "application/json;charset=UTF-8",
             url        : schPrarms[i].action,
             dataType   : "json",
             //async      : false,
             data       : JSON.stringify(schPrarms[i].paramData),
             success: function(result){
                var options = result.dlResultList;

                $("#"+schPrarms[i].uiComp).append("<option value=''>"+schPrarms[i].allText+"</option>");

                for(var j = 0 ; j < options.length ; j++){

                    optValue    = options[j][schPrarms[i].cdId];
                    optTxt      = options[j][schPrarms[i].cdName];
                    optEtcValue = options[j][schPrarms[i].etcId];
                    optEtcAttr  = schPrarms[i].etcAttr;

                    $("#"+schPrarms[i].uiComp).append("<option value='"+optValue+"' "+optEtcAttr+"='"+optEtcValue+"'>"+optTxt+"</option>");
                }

              },
               error: function (jqXHR, textStatus, errorThrown) {
                   gfn_alertMsgBox("데이터 코드 조회 시 오류가 발생하였습니다.");
              }
        });
    }
};


/**
* 용도  : key down 시 엔터 여부 판단 후 이벤트 처리 함수
* 변수  : e   -> 이벤트 개체
*        fnc -> 호출할 함수
*        val -> UI object value
*/
var gfn_enterKeyByVal = function(e, fnc, val){

    var keycode = (e.keyCode ? e.keyCode : e.which);
    if(keycode == 13){
        fnc(val);
    }
}


/**
 * 스크립트용 replaceAlll
 */
function replaceAll(str, searchStr, replaceStr){
    return str.split(searchStr).join(replaceStr);
}

function base64url(source) {
      //Encode in classical base64
    encodedSource = CryptoJS.enc.Base64.stringify(source);

      //Remove padding equal characters
    encodedSource = encodedSource.replace(/=+$/, '');

    //Replace characters according to base64url specifications
    encodedSource = encodedSource.replace(/\+/g, '-');
    encodedSource = encodedSource.replace(/\//g, '_');

    return encodedSource;
}


var gfn_getIndex = function(_obj){
    return _obj.parent().children().index(_obj.get(0));

}
var gfn_dateChange = function(strDate,strTemp,strSin){
    if ( strDate == null || strTemp.length != 9 ) return;
    var strYY = strTemp.substring(0,3);
    var strMM = strTemp.substring(3,6);
    var strDD = strTemp.substring(6,9);
    var date1 = null;
    if ( typeof(strDate) == "string" ) {
        strDate   = strDate.removeAll(Constants.SEPARATOR_DATE);
        var date1 = new Date();
        date1.setFullYear(strDate.substring(0,4));
        date1.setMonth   (parseInt(strDate.substring(4,6)) - 1);
        date1.setDate    (strDate.substring(6,8));
    } else {
        date1 = new Date(strDate.getFullYear(),strDate.getMonth(), strDate.getDate());
    }
    var date2 = new Date(parseInt(strYY),parseInt(strMM),parseInt(strDD));
    var date3 = new Date(0,0,0);
    var date4 = new Date(date2 - date3);
    var date5 = date1 - date4;
    var date6 = new Date(date5);
    var year  = (date6.getFullYear()).toString();
    var month = (date6.getMonth() + 1).toString();
    var day   = (date6.getDate()).toString();
    if (month .length  < 2) month  = "0" + month ;
    if (day .length    < 2) day    = "0" + day ;
    return year + Constants.SEPARATOR_DATE + month + Constants.SEPARATOR_DATE + day ;
}

var gfn_dateComp = function (strDate1,strDate2,ymdType){
    if ( strDate1 == null || strDate2 == null ) return;
    var date1 = null;
    var date2 = null;
    if ( typeof(strDate1) == "string") {
        strDate1   = strDate1.removeAll(Constants.SEPARATOR_DATE);
        date1 = new Date();
        date1.setFullYear(strDate1.substring(0,4));
        date1.setMonth   (parseInt(strDate1.substring(4,6)) - 1);
        date1.setDate    (strDate1.substring(6,8));
    } else {
        date1 = new Date(strDate1);
    }

    if ( typeof(strDate2) == "string") {
        strDate2   = strDate2.removeAll(Constants.SEPARATOR_DATE);
        date2 = new Date();
        date2.setFullYear(strDate2.substring(0,4));
        date2.setMonth   (parseInt(strDate2.substring(4,6)) - 1);
        date2.setDate    (strDate2.substring(6,8));
    } else {
        date2 = new Date(strDate2);
    }
    var dateComp = date2 - date1;
    if ( ymdType == null) {
        ymdType = "D";
    }
    var rtnVal = 0;
    if ( ymdType == "D" ) {
        rtnVal = dateComp / (60000 * 60 * 24);
    } else if ( ymdType == "M"  ) {
        rtnVal = dateComp / (60000 * 60 * 24 * 30);
    } else if ( ymdType == "Y"  ) {
        rtnVal = dateComp / (60000 * 60 * 24 * 365);
    } else if ( ymdType == "HH" ) {
        rtnVal = dateComp / (60000 * 60);
    } else if ( ymdType == "MI" ) {
        rtnVal = dateComp / (60000);
    } else if ( ymdType == "SS" ) {
        rtnVal = dateComp / (1000);

    }

    return rtnVal;
}
var pageSet
var gfn_setPage = function(options){

	if ( typeof options == "string" ) {
        pageSet.currentPage += Number(options * 10);
        pageSet.currentPage = Math.max( pageSet.currentPage ,1 );
        pageSet.currentPage = Math.min( pageSet.currentPage ,pageSet.pageCount );
    } else if ( typeof options == "number" ) {
        pageSet.currentPage = options;
    } else {
        pageSet = $.extend({
            url                 : ""
           ,type                : "POST"
           ,contentType         : "application/json;charset=UTF-8"
           ,currentPage         : 1
           ,recordCountPerPage  : 10
           ,totCount            : 0
           ,pageCount           : 0
           ,successCallBack     : null
           ,errorCallBack       : null
           ,paramData           : {}
           ,navId               : "nav.pagination"
           ,sessionAt           : false
        },options);
    }
    if ( pageSet.url == "" ) {
        gfn_alertMsgBox("호출되는 URL정보가 없습니다.");
        return false;
    }
    //추가
    if(options.historyState != null){
		var  tState = options.historyState;
		tState.currPage = pageSet.currentPage;
		var pageUrl = '?';
		for(var key in tState){
			pageUrl = pageUrl + key+'='+tState[key]+"&";
		}
		window.history.pushState(tState, null, pageUrl);
		//window.history.replaceState(tState, null, pageUrl);

	}

    var paramData                = pageSet.paramData;
    paramData.currentPage        = "" + pageSet.currentPage;
    paramData.recordCountPerPage = "" + pageSet.recordCountPerPage;
    $.ajaxMegaBox({
        url           : pageSet.url,
        type          : pageSet.type,
        contentType   : pageSet.contentType,
        sessionAt     : pageSet.sessionAt,
        data          : JSON.stringify(paramData),
        success       : function (data, textStatus, jqXHR) {
            pageSet.totCount   = Number(data.totCount);
            pageSet.pageCount  = Math.ceil ( pageSet.totCount / pageSet.recordCountPerPage );
            data.pageCount     = pageSet.pageCount;
            var startPageCount = Math.floor( ( pageSet.currentPage - 1 )  / 10 ) * 10 +  1;
            var endPageCount   = Math.floor( ( pageSet.currentPage - 1 )  / 10 ) * 10 + 10;
            endPageCount       = Math.min  ( pageSet.pageCount , endPageCount );
            var _navObj        = $(pageSet.navId);
            if ( _navObj ) {
                _navObj.children().remove();
                if ( startPageCount != 1 ) {
                    _navObj.append('<a title="처음 페이지 보기"   href="javascript:void(0)" class="control first" pageNum=1>first</a> ');
                    _navObj.append('<a title="이전 10페이지 보기" href="javascript:void(0)" class="control prev"  pageNum=' + ( startPageCount - 10 ) +  '>prev</a> ');
                }
                for ( var i = startPageCount ; i <= endPageCount ; i ++ ) {
                    if ( i != pageSet.currentPage ) {
                        _navObj.append('<a title="' + i + '페이지보기" href="javascript:void(0)" pageNum=' + i + '>' + i + '</a> ');
                    } else {
                        _navObj.append('<strong class="active">' + i + '</strong> ');
                    }
                }
                if ( endPageCount != pageSet.pageCount ) {
                    _navObj.append('<a title="이후 10페이지 보기"  href="javascript:void(0)" class="control next" pageNum=' + ( endPageCount + 1 ) +  '>next</a> ');
                    _navObj.append('<a title="마지막 페이지 보기"  href="javascript:void(0)" class="control last" pageNum=' + pageSet.pageCount + '>last</a> ');
                }
                $( pageSet.navId + " > a").unbind("click").bind("click",function(){
                    _this = $(this);
                    options.currentPage = Number(_this.attr("pageNum"));
                    gfn_setPage(options);
                });
            }

            if ( pageSet.successCallBack ) {
                pageSet.successCallBack(data, textStatus, jqXHR);
            } else {
                gfn_alertMsgBox("성공하였습니다.");
            }
        },
        error         : function(xhr,status,error){
            if ( pageSet.errorCallBack ) {
                pageSet.errorCallBack(xhr,status,error);
            } else {
                   var err = JSON.parse(xhr.responseText);
                   gfn_alertMsgBox(xhr.status);
                   gfn_alertMsgBox(err.message);
            }
        }
    });
}

var gfn_imageUpload = function(options){
    var imageUploadSet = $.extend({
        url           : "/on/coc/FileUpload/insertFileUpload.do"
       ,type          : "POST"
       ,maxSize       : 15
       ,success       : null
       ,error         : null
       ,fileSizeError : null
       ,fileNo        : null
       ,fileExt		  : null
       ,baseType	  : null
       ,uploadType	  : null	//파일 업로드 용량 설정 용도
    },options);
    // form 생성
    $("form[name='fileUploadForm']").remove();
    var _form = $("<form name='fileUploadForm' method='POST' enctype='multipart/form-data'/>");
    //_form.append("<input name='file' type='file' multiple='multiple'/>"); //현재 멀티업로드를 사용하는 기능이 없음
    _form.append("<input name='file' type='file' accept='image/*'/>");
    _form.append("<input type='hidden' name='fileNo' value='" + imageUploadSet.fileNo + "' />");
    _form.append("<input type='hidden' name='baseType' value='" + imageUploadSet.baseType + "' />");
    _form.append("<input type='hidden' name='uploadType' value='" + imageUploadSet.uploadType + "' />");
    _form.append("<input type='hidden' name='resizeFileSize' value='" + imageUploadSet.resizeFileSize + "' />");
    _form.hide();
    $("body").append(_form);

    $("form[name='fileUploadForm'] > input[name='file']").unbind("change").bind("change",function(){
        var form = $("form[name='fileUploadForm']")[0];

        var fileSize = this.files[0].size;
        var maxSize  = Number(imageUploadSet.maxSize) * 1024 * 1024;

        if (  maxSize < fileSize ) {
            if ( imageUploadSet.fileSizeError ) {
                imageUploadSet.fileSizeError((fileSize / ( 1024 * 1024 ) ).toFixed(2) , Number(imageUploadSet.maxSize) );
            } else {
                gfn_alertMsgBox("현재 파일 크기 : " + (fileSize / ( 1024 * 1024 ) ).toFixed(2)  + " MB 입니다.\n\n" + "최대 파일 크기 : " + Number(imageUploadSet.maxSize) + " MB 입니다.");
            }
            $(form).remove();
            return false;
        }

        // 파일확장자 체크
        if (imageUploadSet.fileExt != null && imageUploadSet.fileExt != '') {
        	var arrFileExt = imageUploadSet.fileExt.split(",");

        	var fileNm = this.files[0].name;
        	var fExt = fileNm.slice(fileNm.lastIndexOf(".")+1).toLowerCase();
        	var bFileExtInclude = false;

        	if(arrFileExt.length > 0){
        		for(var i=0; i<arrFileExt.length; i++) {
        			if (fExt == arrFileExt[i].toLowerCase().trim()) {
        				bFileExtInclude = true;
        			}
        		}
        	}

        	if (bFileExtInclude == false) {
        		gfn_alertMsgBox("JPG, JPEG, PNG, GIF 파일만 등록 가능합니다.");
        		imageUploadSet.fileExtError();
        		$(form).remove();
                return false;
        	}
        }

        var formData = new FormData(form);
        $.ajaxMegaBox({
            url           : imageUploadSet.url
           ,data          : formData
           ,type          : imageUploadSet.type
           ,contentType   : false
           ,processData   : false
           ,success       : function (data, textStatus, jqXHR) {

        	    //에러일 경우
        	    if( data.statCd == -1 ){
        	    	gfn_alertMsgBox(data.msg);
        	    }else{
        	    	if ( imageUploadSet.success ) {
                        imageUploadSet.success(data, textStatus, jqXHR);
                    } else {
                        gfn_alertMsgBox("성공하였습니다.");
                    }
                    $(form).remove();
        	    }
            }
           ,error         : function(xhr,status,error){
                if ( imageUploadSet.error ) {
                    imageUploadSet.error(xhr,status,error);
                } else {
                       var err = JSON.parse(xhr.responseText);
                       gfn_alertMsgBox(xhr.status);
                       gfn_alertMsgBox(err.message);
                }
                $(form).remove();
            }
        });

    });
	$("form[name='fileUploadForm'] > input[name='file']").click();
}

var gfn_alertMsgBoxSize = function(msg,w,h,f){
    gfn_alertMsgBox({
         msg          : msg
        ,minHeight    : h
        ,minWidth     : w
        ,callback     : f
     })
}

var gfn_confirmMsgBoxSize = function(msg,w,h,co_f,ca_f){
    gfn_confirmMsgBox({
         msg          : msg
        ,minHeight    : h
        ,minWidth     : w
        ,confirmFn    : co_f
        ,cancelFn     : ca_f
     })
}

// 모바일용

var gfn_alertMsgBoxM = function(msg){
    alert(msg);
}

var gfn_alertMsgBox = function(){

    var options = {};

    if ( typeof arguments[0] == "string" ) {

        options.msg = arguments[0];
        if ( typeof arguments[1] == "number" ) {
            options.minHeight = arguments[1];
        } else if ( typeof arguments[1] == "function" ) {
            options.callback  = arguments[1];
        }
        if ( typeof arguments[2] == "number" ) {
            options.minHeight = arguments[2];
        } else if ( typeof arguments[2] == "function" ) {
            options.callback  = arguments[2];
        }
    } else if ( typeof arguments[0] == "object" ) {
        options = arguments[0];
    }

    try {
    	sysCd = sysCd;
    } catch(e) {
    	sysCd = "";
    }

    if( sysCd == "MON" ){
        var setting = {message : options.msg};
        if (nvl(options.callback) != '') {
            setting.okFunc = options.callback;
        }
        AppHandler.Common.alert(setting);
	}else{
	    var setting = $.extend({
	        id           : 'layerId_' + ( "" + Math.random() ).replace( /\D/g, "" )
	       ,msg          : ""
	       ,okBtnTxt     : "확인"
	       ,cancelBtnTxt : "취소"
	       ,minHeight    : 200
	       ,minWidth     : 300
	       ,callback     : undefined
	       ,param        : undefined
	       ,type         : "single"
	       ,mobileAt     : false

	    },options);
	    mbAlert.toggle({
	      id        : setting.id
	     ,msg       : nvl(setting.msg).replaceAll( /\n|\r\n/g, "<br>" )
	     ,confirm   : setting.okBtnTxt
	     ,callback  : {
	         confirm : setting.callback
	     }
	     ,param     : setting.param
	     ,minHeight : setting.minHeight
	     ,minWidth  : setting.minWidth
	     ,type      : setting.type
	     ,isImportant : setting.isImportant
	    });
	}
}


var gfn_confirmMsgBox = function(msg,confirmFn,cancelFn, height, width) {
    var options = {};
    if ( typeof msg == "string" ) {
        options.msg = msg;
        options.confirmFn = confirmFn;
        options.cancelFn  = cancelFn;
        if(height != "undefined" && height != ""){
            options.minHeight = height;
        }
        if(width != "undefined" && width != ""){
            options.minWidth = width;
        }
    } else {
        options = msg;
    }

    var setting = $.extend({
        id           : 'layerId_' + ( "" + Math.random() ).replace( /\D/g, "" )
       ,msg          : ""
       ,okBtnTxt     : "확인"
       ,cancelBtnTxt : "취소"
       ,minHeight    : 200
       ,minWidth     : 300
       ,confirmFn    : undefined
       ,cancelFn     : undefined
       ,param        : undefined
       ,type         : ""
       ,mobileAt     : false
       ,sessionAt    : false

    },options);

    var sessionMsg = sessionAllow( setting );

    if( !sessionAllow( setting ) ) return

    mbAlert.toggle({
          id       : setting.id
         ,msg      : nvl(setting.msg).replaceAll( /\n|\r\n/g, "<br>" )
         ,confirm  : setting.okBtnTxt
         ,cancel   : setting.cancelBtnTxt
         ,callback : {
             confirm : setting.confirmFn
            ,cancel  : setting.cancelFn
          }
        ,param     : setting.param
        ,minHeight : setting.minHeight
        ,minWidth  : setting.minWidth
        ,type      : setting.type
        });
}

var gfn_charToHtml = function (str) {
     var entityMap = {
       '&amp;'   : '&',
       '&lt;'    : '<',
       '&gt;'    : '>',
       '&quot;'  : '"',
       '&#39;'   : "'",
       '&#x2F;'  : '/',
       '&#x60;'  : '`',
       '&#x3D;'  : '=',
       '&#40;'   : '(',
       '&#41;'   : ')',
       '&#35;'   : '#'
     };
     var arrKey = Object.keys(entityMap);
     for ( var i=0 ; arrKey.length>i ; i++ ) {
      var key = arrKey[i];
      var val = entityMap[key];
      str = str.split(key).join(val);
     }
     var entityMap2 = {
        '&amp;'   : '&'
     };
     var arrKey = Object.keys(entityMap2);
     for ( var i=0 ; arrKey.length>i ; i++ ) {
         var key = arrKey[i];
      var val = entityMap[key];
      str = str.split(key).join(val);
     }
     return str;
};

var gfn_htmlToChar = function (str) {
    var entityMap = {
      '&;'   : '&amp',
      '#'    : '&#35;',
      '<'    : '&lt;',
      '>'    : '&gt;',
      '"'    : '&quot;',
      "'"    : '&#39;',
      '/'    : '&#x2F;',
      '`'    : '&#x60;',
      '='    : '&#x3D;',
      '('    : '&#40;',
      ')'    : '&#41;'
    };
    var arrKey = Object.keys(entityMap);
    for ( var i=0 ; arrKey.length>i ; i++ ) {
     var key = arrKey[i];
     var val = entityMap[key];
     str = str.split(key).join(val);
    }
    var entityMap2 = {
       '&amp;'   : '&'
    };
    var arrKey = Object.keys(entityMap2);
    for ( var i=0 ; arrKey.length>i ; i++ ) {
        var key = arrKey[i];
     var val = entityMap[key];
     str = str.split(key).join(val);
    }
    return str;
};

/**
 * 용         도 : 금칙어 Check
 * 변         수 : checkWord  -> 금칙어를 검색할 문장
 *                 onComplete -> 완료시 호출할 함수
 * 결과 파라메타 : 문장에 포함된 금칙어 리스트
 * 예         제 :
 *
  var fn_complete = function(list){
      if ( list.length > 0 ) {
          alert(list.join(","));
      }
  }
  var str = "나쁜사람 이런 똥개같아요. 그럼 9";
  gfn_chkPrhword(str,fn_complete);
 *
 */
var gfn_chkPrhword = function(checkWord,onComplete){
    $.ajaxMegaBox({
        url           : "/on/oc/ocz/commOn/selectPrhwordList.do"
       ,data          : JSON.stringify({ checkWord : checkWord.replaceAll("/\r\n/g","") })
       ,success       : function (data, textStatus, jqXHR) {
           onComplete(data.prhwordList.map(function(o,i){ return o.prhwordCn ;}));
        }
       ,error         : function(xhr,status,error){
           var err = JSON.parse(xhr.responseText);
           gfn_alertMsgBox(xhr.status);
           gfn_alertMsgBox(err.message);
        }
    });
}

/** 선호극장 **/
// param.saveYn : 회원가입시 사용하므로 세션여부 처리 할때 사용
var gfn_favorBrchReg = function(callbackFn, param){

    var initParam = {};

    if (param != undefined) {
        initParam = param;
    }

    if (callbackFn != undefined) {
        initParam.callbackFn = callbackFn;
    }

    var option = {
        url       : '/on/oc/ocz/commOn/favorBrchReg.do',
        height    : '360',
        width     : '500',
        initFn    : 'favorBrchRegInit',
        initParam : initParam,
        sessionAt : initParam.saveYn != 'N'
    };

    gfn_divLayPopUp(option);
};

/** 스토어극장리스트 **/
var gfn_storeBrchListPV = function(cmbndKindNo, cmbndNo, titNm) {

    var paramData = {cmbndKindNo : cmbndKindNo, cmbndNo : cmbndNo};

    if (!titNm) paramData.titNm = titNm;

    var option = {
        url       : '/on/oh/ohd/StoreDtl/selectStoreBrchList.do',
        height    : '530',
        width     : '600',
        target_id : 'layer_chk_theater',
        btn_id    : 'btn_chkTheater',
        params    : paramData
    };

    gfn_divLayPopUp(option);
};

/** 레이어 팝업 **/
var gfn_divLayPopUp = function(options){

	var setting = $.extend({
        btn_id       : "favorBrchReg"
       ,height       : 370
       ,width        : 500
       ,initFn       : function(){}
       ,initParam    : null
       ,callObj      : null
       ,url          : ""
       ,params       : {}
       ,target_id    : "favor_theater_setting"
       ,sessionAt    : false
    },options);


    if ( $("#" + setting.target_id).length > 0 ) {
         $("#" + setting.target_id).remove();
    }
    if ( $("a[href='#" + setting.target_id + "']#" + setting.btn_id ).length > 0 ) {
         $("a[href='#" + setting.target_id + "']#" + setting.btn_id ).remove();
    }
    var _section = $("<section/>").attr({id: setting.target_id,class : "modal-layer"});
    var _a       = $("<a/>").attr({"href":"#" + setting.target_id,"class" : "right btn-modal-open", id:setting.btn_id ,"w-data":setting.width,"h-data" : setting.height});

    $(document.body).append(_a).append(_section);

    var paramData                = setting.params;
    $.ajaxMegaBox({
    	 url            : setting.url
         ,data          : setting.params
         ,type          : "POST"
         ,contentType   : "application/x-www-form-urlencoded; charset=UTF-8"  // text/html
         ,dataType      : "html"  // text/html
         ,sessionAt     : setting.sessionAt
         ,success       : function (data, textStatus, jqXHR) {
             $("#" + setting.target_id).html(data);
             $("a[href='#" + setting.target_id + "']#" + setting.btn_id).click();

             if (setting.initFn != undefined) eval(setting.initFn)(setting.initParam);

             if (setting.callObj != null) {
                 $("#" + setting.target_id).find('.btn-modal-close, .close-layer').click(function(){
                     setting.callObj.focus();
                 });
             }
          }
         ,error         : function(xhr,status,error){
                 gfn_alertMsgBox(xhr.status);
          }
    });
};

/**
 * 지정한 날자 변경 메소드
 *  stanDate : 기준일
 *  diffSe : 날자 변경 타입
 *  diffVal : 변경값 (+) -> 기준일 이후, (-) -> 기준일 이전
 *  diffDate : 변경된 일자
 *
 * Function description...
 * @date 2019. 7. 4.
 * @param param
 * @param form			포맷형식 ex) yy.mm.dd
 * @returns returns		String 형
 * @author Metanet
 * @example
 * @since
 */
var dateFormat
var dateDiffFormat = function(param, format){

    dateFormat = $.extend({
        stanDate            : param.stanDate
       ,diffSe              : param.diffSe
       ,diffVal         	: Number(param.diffVal)
       ,diffDate         	: null
    });

    //yy.mm.dd 일경우 IE 에러
    param.stanDate = param.stanDate.replaceAll('.','-');

    dateFormat.diffDate = new Date(param.stanDate);

    //월변경
    if( param.diffSe == "D" ){
        dateFormat.diffDate.setDate( dateFormat.diffDate.getDate() + dateFormat.diffVal );
    }

      //월변경
    if( param.diffSe == "M" ){
        dateFormat.diffDate.setMonth( dateFormat.diffDate.getMonth() + dateFormat.diffVal );
    }

      //년도변경
    if( param.diffSe == "Y" ){
        dateFormat.diffDate.setYear( dateFormat.diffDate.setFullYear() + dateFormat.diffVal );
    }

    dateFormat.diffDate = $.datepicker.formatDate( format, dateFormat.diffDate );

    return dateFormat.diffDate;
}

var dateStrFormat = function(dateStr, format){

	if( dateStr == null ){
		return "&nbsp;";
	}

	var year 	= dateStr.substr(0,4);
	var month 	= dateStr.substr(4,2);
	var date 	= dateStr.substr(6,2);

	var date = new Date(year, month, date);

	return $.datepicker.formatDate( format, date );
}

var nvl = function(obj, format){

	if( obj == null ){
		if( format == null || format == undefined ){
			return "";
		}else{
			return format;
		}
	}

	return obj;
}

var metaFormat
/**
 * 스크립트 상 메타태그 셋팅
 */
var settingMeta = function(param){

	metaFormat = $.extend({
		scnTitle            : param.scnTitle			//HTML title 정보
       ,metaTagTitle        : param.metaTagTitle		//meta title 정보
       ,metaTagDtls         : param.metaTagDtls			//meta description 정보
       ,metaTagImg         	: param.metaTagImg			//meta image 정보
       ,metaTagKeyword      : param.metaTagKeyword		//meta keywords 정보
       ,metaTagUrl			: param.metaTagUrl			//meta url 정보
    });

	document.title = $.parseHTML(param.scnTitle)[0].textContent; // title 설정 시 HTML escape 처리
	if( param.metaTagTitle != null ) $("head #metaTagTitle").attr( "content", 		param.metaTagTitle );
	if( param.metaTagKeyword != null ) $("head #metaTagKeyword").attr( "content", 	param.metaTagKeyword );
	if( param.metaTagDtls != null ) $("head #metaTagDtls").attr( "content", 		gfn_htmlToChar(param.metaTagDtls) );

	if( param.metaTagTitle != null ) $("head #fbTitle").attr( "content",			param.metaTagTitle );
	if( param.metaTagDtls != null ) $("head #fbDtls").attr( "content", 				gfn_htmlToChar(param.metaTagDtls) );
	if( param.metaTagImg != null ) $("head #fbImg").attr( "content", 				param.metaTagImg );
	if( param.metaTagUrl != null ) $("head #fbUrl").attr( "content", 				param.metaTagUrl );
}

var preMetaFormat
/**
 * 현재 메타태그정보 저장
 * @returns
 */
function saveCurrentMeta(){
	preMetaFormat = {
				//'scnTitle'         : $("head #metaTagTitle").prop( "content" )
				'scnTitle'         : document.title
				, 'metaTagTitle'   : $("head #metaTagTitle").prop( "content" )
				, 'metaTagDtls'    : $("head #metaTagDtls").prop( "content" )
				, 'metaTagUrl'     : $("head #fbUrl").prop( "content" )
			};
	return preMetaFormat;
}

/**
 * 이미지 없을경우 대체 이미지로 교체
 * @param obj img태그 element
 * @param type main/other 분기처리
 * @returns
 */
function noImg(obj, type){

	if (type == "del") {
		$(obj).remove();

	} else {

		switch (type) {
		case "main" 	: obj.src="/static/pc/images/common/bg/bg-noimage-main.png"; break;
		case "human" 	: obj.src="/static/pc/images/mypage/bg-photo.png"; break;
		case "movie" 	: obj.src="/static/pc/images/reserve/bg-poster-view.png"; break;
		default 		: obj.src="/static/pc/images/common/bg/bg-noimage-notmain.png"; break;
		}
	}

}


/**
 * 박스오피스 이동
 * @returns
 */
function fn_searchHeaderBoxOffice() {
	$("#headerBoxoForm").attr("action", "/movie?searchText="+$("#headerMovieName").val());
	$("#headerBoxoForm").submit();
}

/**
 * 박스오피스 이동 체크
 * @returns
 */
function fn_chkHeaderBoxOffice() {
	if ($("#headerMovieName").val() == "") {
		gfn_alertMsgBox("영화명을 입력해 주세요");
		return false;
	}
}

/**
 * 무비리스트 페이지 이동
 * @returns
 */
function gfn_moveDetail(movieNo) {

	var frm = MegaboxUtil.Form.createForm();

	frm.attr("action","/movie-detail?rpstMovieNo="+movieNo);
	frm.submit();
}

/**
 * 로딩 모달창
 * 	- 파라미터 없이 호출시 로딩바 태그가 body 밑으로 그려짐
 *  - seletor 파라미터 전달시 해당 seletor 밑으로 그려짐 (보류중)
 * @param obj
 * @returns
 */
function gfn_logdingModal(seletor){

	var target = "body";

	if( seletor != undefined ){
		target = seletor;
	}

	switch ( $(target + " #bg-loading").length ) {
		case 0 	:
			var html =
				"<div id=\"bg-loading\" class=\"bg-loading\">" +
				"	<div class=\"spinner-border\" role=\"status\">" +
				"		<span class=\"sr-only\">Loading...</span>" +
				"	</div>" +
				"</div>";
			$(target).append(html);
			break;
		default	:
			$(target + " #bg-loading").remove();
			break;
	}
}


/**
 * space를 제외하고 남은 문자열 있는지 체크
 * @returns
 */
function gfn_isEmpty(str) {
	if (  str.trim() == "") {
		return true;
	} else {
		return false;
	}
}

/**
 *	넷퍼넬 사용 유무에따른 페이지 이동
 */
var gfn_moveEventDetail = function (obj){

	var form = MegaboxUtil.Form.createForm();
	form.append('<input type="hidden" name="eventNo" value="' + $(obj).data('no') + '">');
	form.attr('action', '/event/detail');
	form.attr('method', 'get');
	form.submit();
}

/**
 *	영화관 리스트 조회
 */
var gfn_selectBrchList = function(option) {

	option = $.extend({
		id        : '',
		obj       : '',
		areaCd    : '',
		brchNo    : '',
		callback  : '',
		desableAt : 'Y'
	}, option);

	if (option.id != '') {
		option.obj = $('#'+ option.id);
	}

	if (option.areaCd == '') {
		if (option.obj.find('option:first').val() == '') {
			option.obj.nextAll().remove();
		}
		return;
	}

	$.ajaxMegaBox({
		url    : "/on/oh/ohj/Company/theaterCdList.do",
		data   : JSON.stringify({areaCd: option.areaCd}),
		success: function(result){

			var arrObj = [];
			var $opt;

			$.each(result.theaterCdList, function(i, itme){
				arrObj.push($opt = $('<option>').val(itme.brchNo).html(itme.brchNm));
				if (option.brchNo == itme.brchNo) {
					$opt.attr('selected', 'selected');
				}
			});

			if (option.obj != '') {

				if (option.obj.find('option:first').val() == '') {
					option.obj.find('option:first').nextAll().remove();
				} else {
					option.obj.empty();
				}

				if (option.desableAt == 'Y') {
					option.obj.attr('disabled', arrObj.length==0);
				}

				option.obj.append(arrObj);

			} else if (option.callback != '') {
				try { eval(option.callback)() } catch(e) { console.log(e) };
			}
		}
	});
}

/**
 * 문자열 강조
 *
 */
var gfn_getTighlight = function(option, strVal) {

	var rtnTxt = '';

	option = $.extend({
		regTxt  : '',
		type    : {tag : '', css : ''}
	}, option);

	option.chgTxt = '<'+ option.type.tag + ' class="'+ option.type.css +'">'+ option.regTxt +'</'+ option.type.tag + '>';

	option.regTxt = option.regTxt.replace(/\./gi, '\\.');
	option.regTxt = option.regTxt.replace(/\*/gi, '\\*');
	option.regTxt = option.regTxt.replace(/\?/gi, '\\?');
	option.regTxt = option.regTxt.replace(/\^/gi, '\\^');
	option.regTxt = option.regTxt.replace(/\|/gi, '\\|');
	option.regTxt = option.regTxt.replace(/\(/gi, '\\(');
	option.regTxt = option.regTxt.replace(/\)/gi, '\\)');
	option.regTxt = option.regTxt.replace(/\[/gi, '\\[');
	option.regTxt = option.regTxt.replace(/\{/gi, '\\{');
	option.regTxt = option.regTxt.replace(/\}/gi, '\\}');

	$.each(strVal.split('&'), function (i, txt){
		var idx = txt.indexOf(';');
		if (idx == -1) {
			rtnTxt += txt.replace(new RegExp(option.regTxt, 'gi'), option.chgTxt);
		} else {
			rtnTxt += '&'+ txt.substring(0, idx+1);
			rtnTxt += txt.substring(idx+1).replace(new RegExp(option.regTxt, 'gi'), option.chgTxt);
		}
	});

	return rtnTxt;
}