if(typeof NetFunnel == "object"){
	NetFunnel.SkinUtil.add('megabox',{
		prepareCallback:function(){
			//var progress_print = document.getElementById("Progress_Print");
			//progress_print.innerHTML="0 % (0/0) - 0 sec";
			//넷퍼넬 페이지별 적용시 닫기 버튼 제거
			if( NetFunnel.TS_TARGET == "page" ){
				$("#NetFunnel_Skin_Top .layer-header span").css("display","none");
			}
		},
		updateCallback:function(percent,nwait,totwait,timeleft){
			//var progress_print = document.getElementById("Progress_Print");
			//var prog=totwait - nwait;
			//progress_print.innerHTML=percent+" % ("+prog+"/"+totwait+") - "+timeleft+" sec";
			var tempWidth = document.getElementById("NetFunnel_Loading_Popup_Progressbar_CUSTOM").style.width.replace("px","");
			var tempTarget = document.getElementById("NetFunnelCustomProgressbar");
            var i = tempWidth - Math.round((NetFunnel.gLastData.nwait / NetFunnel.gTotWait) * tempWidth);

            //tempTarget.style.width = i + "px";
            tempTarget.style.width = percent + "%";

            //console.log(NetFunnel.gLastData.nwait +"/"+ NetFunnel.gTotWait + " : "+percent);

		},

		htmlStr:'<div id="NetFunnel_Skin_Top" style="width: 560px; background-color: #fff; padding: 29px 0px; border:1px solid #eee; box-sizing:border-box;"> \
						<div class="wrap" style="width:100%;">\
						<header class="layer-header" style=-"margin-bottom:20px;">\
							<h3 class="tit">[PC]접속대기안내</h3>\
							<span onclick="fn_pcClose();" style="position: absolute; right:10px; top:15px; width:18px; height:18px;background:url(/static/pc/images/common/btn/btn-layer-close.png) no-repeat 0 0"></span>\
						</header>\
						<div class="layer-con" style="margin:20px 0 0 -1px;">\
							<div class="connect-waiting">\
								 \
								<div class="counting">\
									<i class="iconset ico-connect-waiting"></i>\
									<div class="count">\
										<p class="tit">대기인원</p>\
										<p class="txt">\
											<em id="NetFunnel_Loading_Popup_Count">230</em>\
											<span>명</span>\
										</p>\
									</div>\
								</div>\
								<div class="box-gray">\
									<p class="txt">\
										페이지 사용량이 많아 접속 지연되고 있습니다.<br />\
										잠시만 기다려 주세요.\
									</p>\
									<div id="NetFunnel_Loading_Popup_Progressbar_CUSTOM" class="graph-bar">\
										<!-- 접근성 : em 안의 숫자도 실시간으로 바꿔줘야 합니다. -->\
										<div id="NetFunnelCustomProgressbar" class="bar" style="width:100%">\
											<span><em>33.333</em> &#37;</span>\
										</div>\
									</div>\
								</div>\
								<p class="info">\
									※ 새로고침 또는 뒤로가기를 하시면 대기 시간이 다시 부여됩니다.\
								</p>\
							</div>\
						</div>\
					</div>\
				</div>'

	},'normal');

	NetFunnel.SkinUtil.add('megaboxMobile',{
		prepareCallback:function(){
			//var progress_print = document.getElementById("Progress_Print");
			//progress_print.innerHTML="0 % (0/0) - 0 sec";
			//넷퍼넬 페이지별 적용시 닫기 버튼 제거
			if( NetFunnel.TS_TARGET == "page" ){
				$("#NetFunnel_Skin_Top .iconset.ico-p-close").css("display", "none");
			}

			//앱 로딩바 제거
			if((typeof AppHandler) == undefined){
				AppHandler.Common.stopLoadingBar();
			}

			// 변경된 CSS SET
	        $("#NetFunnel_Loading_Popup").css(
				{
					"display":"block",
					"top":"0",
					"left":"0",
					"position":"absolute",
					"visibility":"visible",
					"z-index":"32002",
					"height":"100vh",
					"width":"100vw",
					"background-color":"white"
				}
			);

			// 앱인경우 해더 set
	        if(isApp()){
				$('#NetFunnel_Skin_Top').attr('style','padding-top:0px;');
	        }else{
	        	$('#NetFunnel_Skin_Top').attr('style','padding-top:56px;');
	        	var webHeader = new StringBuffer();
	        	webHeader.append('<header id="headerSub" class="r24_header">');
        		webHeader.append('		<div class="headCont">');
        		webHeader.append('		<h2 class="headTite">접속 대기 안내</h2>');
        		webHeader.append('		<div class="rtArea">');
        		webHeader.append('			<a href="javascript:fn_netfunnelClose();"><i class="icon2 btn_close_bl30">닫기</i></a>');
        		webHeader.append('		</div>');
        		webHeader.append('	</div>');
        		webHeader.append('</header>');
	        	$('#NetFunnel_Skin_Top').prepend(webHeader.toString());
	        }

	        // 빵티로인한 예매인지 일반 예매 인지 확인필요.
	        if(NetFunnel.gControl.mConfig.action_id == "MBL_EVENT_BOOKING"){
	        	$("#NetFunnel_Skin_Top .titleGroup .subTitle").html($('#newEvMovieNm').val());
	        }else if(NetFunnel.gControl.mConfig.action_id == "WEB_STORE_DTL"){
	        	$("#NetFunnel_Skin_Top .titleGroup .title").html("동시 접속자가 많아<br>잠시 <span style='color:#660ed8;'>대기 중</span> 입니다.");
	        	$("#NetFunnel_Skin_Top .titleGroup .subTitle").html("조금만 기다려주세요.");
	        }else if(NetFunnel.gControl.mConfig.action_id == "WEB_STORE_PAY"){
	        	$("#NetFunnel_Skin_Top .titleGroup .title").html("동시 접속자가 많아<br>잠시 <span style='color:#660ed8;'>대기 중</span> 입니다.");
	        	$("#NetFunnel_Skin_Top .titleGroup .subTitle").html("조금만 기다려주세요.");
	        	var txtUi = new StringBuffer();
	        	txtUi.append('<li>결제 완료 기준으로 구매가 확정되며, 결제 중 다른 고객이 먼저 결제할 경우 구매가 제한될 수 있습니다.</li>');
	        	$('#NetFunnel_Skin_Top > div > div.dotList01.bot > ul').append(txtUi.toString());
	        }else{
	        	$("#NetFunnel_Skin_Top .titleGroup .subTitle").html($('#prevMovieNm').text());
	        }
		},
		updateCallback:function(percent,nwait,totwait,timeleft){

		},
		htmlStr:'<div id="NetFunnel_Skin_Top">\
					<div class="netfunnel">\
						<div class="titleGroup">\
				            <div class="title">조금만 기다려주세요</div>\
				            <div class="subTitle"></div>\
				        </div>\
				        <div class="numberBox">\
				            <span class="text">지금 나의 대기번호</span>\
				            <span class="count" id="NetFunnel_Loading_Popup_Count" >1</span>\
				        </div>\
				        <div class="aniBox type01"><div class="netAni"></div></div>\
				        <div class="dotList01 bot">\
				            <ul>\
				                <li>페이지 사용량이 많아 접속이 지연되고 있습니다.</li>\
				                <li>새로고침 또는 뒤로가기를 하시면 대기 시간이 다시 부여됩니다.</li>\
								<li>네트워크 연결이 끊기면 다음 페이지로 이동이 불가할 수 있습니다.</li>\
				            </ul>\
				        </div>\
			    	</div>\
				</div>'
	},'normal');

	NetFunnel.SkinUtil.add('megaboxMobileEventDetail',{
		prepareCallback:function(){
			//넷퍼넬 페이지별 적용시 닫기 버튼 제거
			if( NetFunnel.TS_TARGET == "page" ){
				$("#NetFunnel_Skin_Top .iconset.ico-p-close").css("display", "none");
			}

			//앱 로딩바 제거
			if((typeof AppHandler) == undefined){
				AppHandler.Common.stopLoadingBar();
			}

			// 변경된 CSS SET
			$("#NetFunnel_Loading_Popup").css(
				{
					"display":"block",
					"top":"0",
					"left":"0",
					"position":"absolute",
					"visibility":"visible",
					"z-index":"32002",
					"height":"100vh",
					"width":"100vw",
					"background-color":"white"
				}
			);

			if(isApp()){
				$('#netWebhd').remove();
				$('.netfunnel2').css('padding','0');
				var param = {
						header: {
							type: 'default',
							bgColor: 'ffffff',
							txtColor: '000000',
							closeAction: 'fn_netfunnelClose'
						},
						title: {
							type: 'text',
							text: '접속 대기 안내'
						},
						btnRight: {
							type: 'close',
							txtColor: '000000'
						}
				};
				AppHandler.Common.setHeader(param);
			}

			// 빵티로인한 예매인지 일반 예매 인지 확인필요.
			if(NetFunnel.gControl.mConfig.action_id == "MBL_EVENT_BOOKING"){
				$("#NetFunnel_Skin_Top .titleGroup .subTitle").html($('.topBox .n1').text());
			}else if(NetFunnel.gControl.mConfig.action_id == "MBL_BOOKING_ALWAYS"){

			}else if(NetFunnel.gControl.mConfig.action_id == "MBL_EVENT_PAGE"){
				$("#NetFunnel_Skin_Top .titleGroup").css("padding-top", "30px");
				$("#NetFunnel_Skin_Top .titleGroup .subTitle").html("이벤트 참여 대기");
			}else{
				$("#NetFunnel_Skin_Top .titleGroup .subTitle").html($('#prevMovieNm').val());
			}
		},
		updateCallback:function(percent,nwait,totwait,timeleft){

		},
		htmlStr:'<div id="NetFunnel_Skin_Top">\
					<div class="netfunnel2">\
            			<div class="head" id="netWebhd">\
				            <h2>접속 대기 안내</h2>\
							<a href="javascript:fn_netfunnelClose();"><i class="icon2 btn_close_bl30">닫기</i></a>\
				        </div>\
						<div class="titleGroup">\
				            <div class="title">조금만 기다려주세요</div>\
				            <div class="subTitle"></div>\
				        </div>\
				        <div class="numberBox">\
				            <span class="text">지금 나의 대기번호</span>\
				            <span class="count" id="NetFunnel_Loading_Popup_Count" >1</span>\
				        </div>\
				        <div class="aniBox type01"><div class="netAni"></div></div>\
				        <div class="dotList01 bot">\
				            <ul>\
				                <li>페이지 사용량이 많아 접속이 지연되고 있습니다.</li>\
				                <li>새로고침 또는 뒤로가기를 하시면 대기 시간이 다시 부여됩니다.</li>\
				            </ul>\
				        </div>\
			    	</div>\
				</div>'
		},'normal');
}
function fn_pcClose(){
	NetFunnel.countdown_stop();

    if(NetFunnel.gControl.mConfig.action_id == "WEB_BOOKING_ALWAYS"){
    	location.href = "/";
    }
	if(NetFunnel.gControl.mConfig.action_id == "WEB_EVENT_PAGE"){
		location.href = "/event";
	}
}
function fn_netfunnelClose(){
	NetFunnel.countdown_stop();
	controlAction.off();

	var actionId = NetFunnel.gControl.mConfig.action_id;

	if(actionId == "MBL_BOOKING_ALWAYS"){
		AppHandler.Common.newGoMain();
	}

	if(actionId == "MBL_EVENT_PAGE"){
		AppHandler.Common.newGoEvent();
	}

	if(actionId == "WEB_STORE_DTL" || actionId == "WEB_STORE_PAY"){
		AppHandler.Common.newGoStore();
	}

	$('#NetFunnel_Loading_Popup').remove();
	if(isApp()){
		if(NetFunnel.gControl.mConfig.skin_id == "megaboxMobileEventDetail"){
			//해더 이벤트상세 원복
        	var param = {
                    header: {
                        type: 'default'
                    },
                    title: {
                        type: 'text',
                        text: '이벤트 상세'
                    },
                    btnLeft: {
                        type: 'back'
                    },
                    btnRight: {
                        type: 'sub',
                        image: 'ico-share',
                        callback: 'fn_snsShare'
                    },
                    refresh: true
        	};
        	AppHandler.Common.setHeader(param);
		}
	}
}