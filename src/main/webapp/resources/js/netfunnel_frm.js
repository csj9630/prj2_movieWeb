var NetfunnelChk = NetfunnelChk || {};
NetfunnelChk = (function() {

	'use strict';


    return {
    	mobileTag : function(id, data) {
    		NetFunnel.TS_ACTION_ID = NetFunnel.TS_PRE_ACTION_ID + id;

        	NetFunnel_Action({action_id : NetFunnel.TS_ACTION_ID},{
    			success:function(ev, ret) {
    				AppHandler.Common.submit(NetfunnelChk.setFrmKey(null, null, ret.data.key), data);
    			},
    			bypass:function(ev, ret) {
    				AppHandler.Common.submit(NetfunnelChk.setFrmKey(null, null, ret.data.key), data);
    			},
                error:function(ev,ret){
                	AppHandler.Common.submit(NetfunnelChk.setFrmKey(null, null, NetFunnel.TS_BYPASS_KEY), data);
                }
    		});
        },
    	aTag : function(id, url) {
    		NetFunnel.TS_ACTION_ID = NetFunnel.TS_PRE_ACTION_ID + id;

        	NetFunnel_Action({action_id : NetFunnel.TS_ACTION_ID},{
    			success:function(ev, ret){
    				NetfunnelChk.setFrmKey(null, url, ret.data.key).submit();
    			},
                bypass:function(ev,ret){
                	NetfunnelChk.setFrmKey(null, url, ret.data.key).submit();
                },
                error:function(ev,ret){
                	NetfunnelChk.setFrmKey(null, url, NetFunnel.TS_BYPASS_KEY).submit();
                }
    		});
        },
        script : function(id, call) {

        	NetFunnel.TS_ACTION_ID = NetFunnel.TS_PRE_ACTION_ID + id;

        	NetFunnel_Action({action_id : NetFunnel.TS_ACTION_ID},{
				success:function(ev, ret){

					//넷퍼넬 초기화
					NetFunnel_Complete({});
					call(ret);

				},
				bypass:function(ev, ret){

					//넷퍼넬 초기화
					NetFunnel_Complete({});
					call(ret);
				},
                error:function(ev,ret){

                	//넷퍼넬 초기화
					NetFunnel_Complete({});

                	call(ret);
                }
			});
	    },
	    formSubmit : function(id, frm, call) {
	    	NetFunnel.TS_ACTION_ID = NetFunnel.TS_PRE_ACTION_ID + id;

	    	NetFunnel_Action({action_id : NetFunnel.TS_ACTION_ID},{
				success:function(ev, ret){
					NetfunnelChk.setFrmKey(frm, null, ret.data.key).submit();
				},
                bypass:function(ev,ret){
                	NetfunnelChk.setFrmKey(frm, null, NetFunnel.TS_BYPASS_KEY).submit();
                },
                error:function(ev,ret){
                	NetfunnelChk.setFrmKey(frm, null, NetFunnel.TS_BYPASS_KEY).submit();
                }
                /*continued:function(ev,ret){
                	console.log("continued");
                },
                stop:function(ev,ret){
                	console.log("stop");
                },
                block:function(ev,ret){
                	console.log("block");
                },
                ipblock:function(ev,ret){
                	console.log("ipblock");
                },
                expressnumber:function(ev,ret){
                	console.log("expressnumber");
                }*/
			});
	    },
	    setFrmKey : function(frm, url, key) {

	    	if( frm == null ){
	    		frm = MegaboxUtil.Form.createForm();
	    	}

	    	if( url != null ){
	    		frm.attr("action", url);
	    	}

	    	//넷퍼넬 바이패스 체크
			if( NetFunnel.TS_BYPASS ) key = NetFunnel.TS_BYPASS_KEY;

			frm.append("<input type='hidden' name='netfunnel_key' id='netfunnel_key' value='" + key + "' />");

			return frm;
	    },
	    setting : function( sysCd, isApp ){

	    	if( sysCd == 'MON' ){

	    		NetFunnel.TS_SKIN_ID		= 'megaboxMobile';
	    		NetFunnel.TS_SERVICE_ID		= 'service_2';
	    		NetFunnel.TS_PRE_ACTION_ID	= 'MBL_';

	    		if( isApp ){
	    			NetFunnel.TS_SERVICE_ID		= 'service_2';
	    			NetFunnel.TS_PRE_ACTION_ID	= 'MBL_';
	    		}

	    	}else{

	    		NetFunnel.TS_SKIN_ID		= 'megabox';
	    		NetFunnel.TS_SERVICE_ID		= 'service_1';
	    		NetFunnel.TS_PRE_ACTION_ID	= 'WEB_';

	    	}
	    },
	    reset : function() {
	    	NetFunnel.countdown_stop();
	    }
    };
}());