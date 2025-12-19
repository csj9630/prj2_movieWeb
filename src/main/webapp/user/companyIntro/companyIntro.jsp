<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> <!-- page directive -->
<%@taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<!--[if lt IE 10]><html class="lt-ie9" lang="ko"><![endif]-->
<!--[if gt IE 9]><!--><html lang="ko"><!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />
	<title>
		회사 개요 &gt; 2GV 소개 | 회사소개
	</title>
	<link rel="shortcut icon" href="${commonURL}/resources/images/favicon.ico">
	<meta name="keyword" content="투지브이,2gv,영화,영화관,극장,티켓,박스오피스,상영예정작,예매,오페라,싱어롱,큐레이션,필름소사이어티,클래식소사이어티,이벤트,Movie,theater,Cinema,film,Megabox" />
	<meta name="description" content="삶의 의미와 즐거움을 소통하는 공간, 함께 더 행복한 가치있는 콘텐츠를 추구하는 만남고 소통의 즐거움이 가득한 공간 투지브이 입니다." />
	<meta property="og:site_name" content="투지브이" />
	<meta property="og:url" content="http://megabox.co.kr" />
	<meta property="og:image" content="http://image2.megabox.co.kr/mop/home/appbunpage/URLVIEW.jpg" />
	<meta property="og:type" content="movie"/>
	<meta property="og:site_name" content="투지브이 회사소개"/>
	<meta property="fb:app_id" content="356285641381572"/>
     	
			<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css" media="all" />
	
		<!-- Global site tag (gtag.js) - Google Analytics -->
		<script async src="https://www.googletagmanager.com/gtag/js?id=G-5JL3VPLV2E"></script>
		<script>window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'G-5JL3VPLV2E');</script>
		<script async src="https://www.googletagmanager.com/gtag/js?id=G-LKZN3J8B1J"></script>
		<script>window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'G-LKZN3J8B1J');</script>
	
	<script src="${commonURL}/resources/js/jquery-1.12.4.js"></script>
	<script src="${commonURL}/resources/js/jquery-ui.1.12.1.js"></script>
	<script src="${commonURL}/resources/js/gsaps.js"></script>
	<script src="${commonURL}/resources/js/bootstrap-custom.js"></script>
	<script src="${commonURL}/resources/js/bootstrap-select.js"></script>

	<script src="${commonURL}/resources/js/commons.js"></script>
	<script src="${commonURL}/resources/js/mega.prototype.js"></script>
	<script src="${commonURL}/resources/js/megaboxCom.js"></script>
	<script src="${commonURL}/resources/js/front.js"></script>
	
	<style type = "text/css">
	.layer-sitemap .wrap .list .tit-depth{display: grid;}
	</style>
	
	<script type="text/javascript">
		var _init = {
			cache	: Date.now(),
			path	: '/static/pc/js/'
		};
		document.write(
			'<script src="'+_init.path+'ui.common.js?v='+_init.cache+'"><\/script>'+
			'<script src="'+_init.path+'front.js?v='+_init.cache+'"><\/script>'
		);
	</script>
	
		<!-- Google Tag Manager -->
		<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src= 'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f); })(window,document,'script','dataLayer','GTM-WG5DNB7D');</script>
	
</head>

<body>
	
		<!-- End Google Tag Manager body 영역에 추가-->
		<!-- Google Tag Manager (noscript) -->
		<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WG5DNB7D" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript> <!-- End Google Tag Manager (noscript) -->
	
<!-- 웹접근성 영역 바로가기 -->
<div class="skip" title="스킵 네비게이션">
	<a href="#contents" title="본문 바로가기">본문 바로가기</a>
	<a href="#footer"	title="푸터 바로가기">푸터 바로가기</a>
</div>


		<!-- 2GV 소개 -->

<div class="body-wrap intro-body">
	<header id="header" class="com">
		<div class="bg-mask">
			<div style = "background-color: #FFFFFF; font-size: 15px;">
            <jsp:include page="../../fragments/header.jsp"/>
			</div>
			<div class="mid-tab">
				<div class="inner-wrap">
					<ul id="tabList">
						<li><a href="#" data-target="contentInfo" title="회사개요 페이지로 이동">회사개요</a></li>
						<li><a href="#" data-target="contentHis" title="연혁 페이지로 이동">연혁</a></li>
						<li><a href="#" data-target="contentMap" title="오시는길 페이지로 이동">오시는 길</a></li>
					</ul>
				</div>
			</div>
			<div class="main-text">
				<p>2GV 소개</p><br />
				<p>새로운 이야기를 만나고, 함께 어울려 놀고, 즐거운 경험을 공유하는 공간</p>
			</div>
		</div>
	</header>

<!-- 		<div id="bodyContent"> -->
		


<script type="text/javascript">
	var tabIdx = '' || 1;

	$(function() {
		// 상단탭 버튼
		$('#tabList a').on('click', function(e) {
			e.preventDefault();

			tabIdx = $(this).parent().index() + 1;

			fn_initTab(); // 탭버튼 초기화
		});

		// 지도 클릭
		$('#map').on('click', function(e) {
			e.preventDefault();

	        window.open('https://naver.me/IItKfhxh');
		});

		fn_initTab(); // 탭버튼 초기화
	});

	// 탭버튼 초기화
	function fn_initTab() {
		$('.contentCompany').hide(); // 모든 컨텐츠 숨기기
		$('#tabList li.on').removeClass('on');
		$('#tabList li').eq(tabIdx - 1).addClass('on'); // 상단 탭 활성화
		$('.' + $('#tabList li.on a').data('target')).show();
	};
</script>

<body>
	<!-- container -->
	<div class="container">
		<!-- visual text -->
		<!--// visual text -->
		<div id="contents">


			<!-- 회사개요 -->
			<!-- 미션 -->
			<div class="inner-wrap padding-type contentCompany contentInfo" id="company">
				<h2 class="tit">미션 (Mission)</h2>
				<p class="page-tit-txt font-purple">사람들과 공유할 수 있는, 공간경험을 만듭니다.</p>
				<p class="page-info-txt">우리는 사람들에게 ‘즐겁고 행복한 일상’을 전달하기 위해 존재합니다.<br />
				   가치있는 콘텐트 제공으로 일상에 영감을 주는 ‘인생극장’을 넘어 공간 사업의 다양화를 중심으로 ‘즐거운 인생경험’을 제공하는 공간을 만듭니다.<br /><br />
				   투지브이를 경험한 오늘을 행복한 마음으로 공유할 수 있도록<br />
				   MEET PLAY SHARE, 2GV</p>

				<div class="valuable">
					<div class="valuble-tit mb20">
						VALUABLE INFLUENCE<br />
						가치있는 영향력
					</div>
					<img src="${commonURL}/resources/images/img-valuable2.png" alt="MEANINGFUL CULTURAL EXPERIENCE, CREATE A PLATFORM (SPACE/TIME), INPIRATION FOR A HAPPY LIFE" />
				</div>
			</div>
			<!--// 미션 -->

			<!-- 핵심가치 -->
			<div class="bg-box bg-gray contentCompany contentInfo">
				<div class="inner-wrap padding-type">
					<h2 class="tit">핵심가치 (Core Value)</h2>
					<p class="page-tit-txt font-purple">2GV가 추구하는 핵심가치는 ‘공감 + 창조 + 재미’ 입니다.</p>

					<div class="point">
						<div class="point-box">
							<div class="point-txt">
								<p class="tit">공감</p><br />
								<p>
									사람에 대한<br />
									이해와 배려
								</p>
							</div>
						</div>

						<div class="point-box">
							<div class="point-txt">
								<p class="tit">창조</p>
								<p>
									일상을 새롭게 하는<br />
									도전과 열정
								</p>
							</div>
						</div>

						<div class="point-box">
							<div class="point-txt">
								<p class="tit">재미</p><br />
								<p>
									스스로<br />
									즐거워하기
								</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--// 핵심가치 -->

			<div class="inner-wrap padding-type pb0 contentCompany contentInfo">
				<!-- 슬로건 -->
				<h2 class="tit mb10">브랜드 슬로건 (Brand Slogan)</h2>

				<div class="slogan mb80">
					<img src="${commonURL}/resources/images/img-lifetheater-tm2.png" alt="LIFE THEATER TM" />
					<P class="font-green">MEET PLAY SHARE, 2GV</P>
					<P class="mt30">새로운 이야기를 만나고, 함께 어울려 놀고, 즐거운 경험을 공유하는 공간</P>
				</div>
				<!--// 슬로건 -->

				<!-- Brand Name -->
				<h2 class="tit mb10">Brand Name</h2>
				<p class="mb80 p-txt">
					‘2GV(투지브이)’는 ‘쌍용교육센터 2강의실 2조(two)’와 ‘~을 향해(to)’라는 뜻을 모두 담은 2와 ‘가장 큰 가치’를 뜻하는<br/>
					Greatest Value의 약자인 GV의 결합으로, 큰 사각형 형태의 스크린을 영상화함과 동시에 고객들에게 있어 가장 중요한 가치인<br/>
					크고 다양한 즐거움과 만족을 추구하고자 하는 의미가 담겨 있습니다.
				</p>
				<!--// Brand Name -->

				<!-- BI -->
				<h2 class="tit mb10">BI (Brand Identity)</h2>
				<p class="p-txt mb30">
					2025년 새롭게 선보인 투지브이의 브랜드아이덴티티는 2개의 황금비율의 박스가 결합된 3개의 박스와 영문 2GV라이프체로<br />
					조합되어 기존 2GV의 아이덴티티의 핵심 정신을 계승함과 동시에 사용상의 효율성과 확장성을 확보했습니다.<br />
					시각적 안정감을 주는 5:8 황금비율의 박스들의 결합은 2GV가 함께하는 편안한 공간임을 상징하며, 보라 계열의 인디고 컬러는<br />
					다양하고 독창적인 구성 요소로 공간을 채워가겠다는 의미입니다.<br />
					나아가 극장업의 본질에 충실하되 공간을 중심으로 다양한 고객 경험을 위해 창의적 시도를 멈추지 않겠다는 철학을 담았습니다.
				</p>
				<p class="s-tit font-green">기본형</p>
				<div class="mb30">
					<img src="${commonURL}/resources/images/bi-normal.png" alt="2GV" />
				</div>

				<p class="s-tit font-green">슬로건 조합형</p>
				<div>
					<img src="${commonURL}/resources/images/bi-slogan2.png" alt="2GV LIFE THEATER" />
				</div>
				<!--// BI -->
				<!-- 회사개요 -->
			</div>

			<div class="inner-wrap padding-type pb0 contentCompany contentHis" style="display: none;">
				<!-- 연혁 -->
				<h2 class="tit">투지브이가 ‘더 좋은 영화관’을 만들어갑니다!</h2>

				<p class="p-txt mb60">
					2000년, 동양 최대 규모의 코엑스점을 시작으로 한국 멀티플렉스의 서비스 표준을 제시한 투지브이와 2004년부터 실력과 개성을 갖춘 영화관들이 연합하여<br />
					차별화된 문화를 만들어온 씨너스는 2011년 5월, 합병을 통해 지난 10년간의 경험을 디딤돌 삼고, 앞으로의 10년을 위한 새로운 도약의 계기를 만들었습니다.<br />
					새로운 투지브이는 씨너스가 추구해온 ‘새로움과 다양성의 가치’를 즐거움이 가득한 공간 투지브이에 담아, 모두에게 ‘더 좋은 영화관’이 되기 위한 노력을<br />
					멈추지 않을 것입니다.
				</p>
				
				<div class="history-list-wrap">
					<!-- 2020 - 2016 -->
					<div class="history-list" id="year_2020">
						<ul>
							<li>
								<p class="year"><span>2020</span></p>

								<div class="year-info">
									<p>㈜투지브이쌍용</p>
									<ul class="dot-list">
										<li>투지브이 20주년</li>
										<li>국내 최초 DOLBY CINEMA 오픈 (COEX, 안성스타필드, 남양주스페이스원)</li>
										<li>&lt;지푸라기라도 잡고 싶은 짐승들&gt; 로테르담영화제 심사위원장상 수상</li>
										<li>&lt;도시괴담&gt; 넷플릭스 아시아 주간 Top3콘텐츠 등극</li>
										<li>모바일오더 서비스 오픈</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2019</span></p>

								<div class="year-info">
									<p>㈜투지브이쌍용</p>
									<ul class="dot-list">
										<li>성수동 사옥 건설 및 성수지점 오픈</li>
										<li>ORIGINAL TICKET 런칭</li>
										<li>투지브이 &lt;신촌 괴담의 진실&gt; 프로모션</li>
										<li>코엑스 미디어타워, 시그니처 오픈</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2018</span></p>

								<div class="year-info">
									<p>㈜투지브이쌍용</p>
									<ul class="dot-list">
										<li>100호점 오픈 (상암월드켭경기장 지점)</li>
										<li>투지브이쌍용㈜으로 법인명 변경</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2017</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list">
										<li>브이스타 페스티벌 진행</li>
										<li>2017 &amp; Award 디지털 광고 부문 ‘WINNER’ 수상 (순간극장)</li>
										<li>브랜드 캠페인 ‘순간극장’ 진행</li>
										<li>신규 BI 및 ‘Life Theater’ 슬로건, 브랜드 리더필름 공개</li>
										<li>비전선포식 진행</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2016</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list">
										<li>2016 대한민국 신뢰받는 혁신대상 '공감하는 영화관' 부분 대상 수상</li>
										<li>'가장 높은 곳에 설치된 야외 영화관(해발 1,050m)' 부분 한국 기네스 등재</li>
										<li>하남스타필드점 VX, 더 부티크, 투지브이키즈, 발코니V 오픈</li>
										<li>큐레이션 브랜드 '필름/클래식 소사이어티' 오픈</li>
										<li>대학생 홍보단 영상 크리에이터 '브이트레일러 1기' 발족</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2015</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list">
										<li>쌍용교육센터(SIST)로 편입</li>
										<li>국내 최초 베를린 필하모닉 발트뷔네 콘서트 중계</li>
										<li>대한민국 CSR 필름 페스티벌 개발협력부분 수상 (시네마 천국)</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2014</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list">
										<li>국내 최초 베를린 필하모닉 유로파 콘서트 중계</li>
										<li>국내 최초 프라하 봄 페스티벌 오프닝 콘서트 중계</li>
										<li>국내 영화관 최초 영국 국립극장 NT Live ‘워 호스’ 개봉</li>
										<li>2014 브라질월드컵 중계</li>
										<li>투지브이㈜플러스지 설립</li>
										<li>신개념 자동차극장 드라이브V 오픈(용인)</li>
										<li>코엑스점 리뉴얼 오픈</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2013</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list">
										<li>빈 필하모닉 신년음악회 세계 최초 극장 생중계</li>
										<li>브레겐츠 페스티벌 국내 최초 극장 생중계</li>
										<li>백석점·원마운트점 야외 상영관 오픈V 오픈</li>
										<li>WBC 단독 생중계</li>
										<li>코엑스점 프리미엄관 오픈</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2012</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list">
										<li>투지브이(주)로 법인명 변경</li>
										<li>제1회 투지브이 시네마 리플레이 개최</li>
										<li>잘츠부르크 페스티벌 아시아 최초 중계</li>
										<li>제1회 투지브이 무비 아카데미 개최</li>
										<li>코엑스점·목동점·영통점 V2관 오픈</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2011</span></p>

								<div class="year-info">
									<p>㈜투지브이씨너스</p>
									<ul class="dot-list">
										<li>(주)투지브이, (주)씨너스 합병법인 투지브이씨너스(주) 설립, 전국 52개 지점 확보</li>
										<li>한국소비자원 조사 복합 상영관 관람시설 및 서비스 만족도 1위</li>
										<li>통신 3사 할인 제휴 체결</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2010</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list mb30">
										<li>2010남아공 월드컵 중계</li>
									</ul>
									<p>㈜씨너스</p>
									<ul class="dot-list">
										<li>2010남아공 월드컵 중계</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2009</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list mb30">
										<li>국내 영화관 최초 오페라 상영</li>
										<li>목동점 ZAM관 오픈</li>
									</ul>
									<p>㈜씨너스</p>
									<ul class="dot-list">
										<li>프로야구 포스트 시즌 독점 중계</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2008</span></p>

								<div class="year-info">
									<p>㈜씨너스</p>
									<ul class="dot-list">
										<li>IPTV 영화 배급</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2007</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list mb30">
										<li>영화 배급사업 진출</li>
										<li>국내 최초, 디지털 영화 배급 시스템 구축 </li>
									</ul>
									<p>㈜씨너스</p>
									<ul class="dot-list">
										<li>전관 디지털 시스템 도입</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2006</span></p>

								<div class="year-info">
									<p>㈜투지브이</p>
									<ul class="dot-list mb30">
										<li>㈜ 투지브이로 사명 변경</li>
										<li>국가고객만족도(NCSI) 1위</li>
										<li>코엑스점 1일 최고관객 세계 신기록 수립(33,235명)</li>
										<li>2006 독일 월드컵 중계</li>
									</ul>
									<p>㈜씨너스</p>
									<ul class="dot-list">
										<li>Digital 시스템 도입</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2005</span></p>

								<div class="year-info">
									<p>투지브이 씨네플렉스(주)</p>
									<ul class="dot-list mb30">
										<li>Cine Asia 선정 ‘아시아 최고의 영화관’ 상 수상</li>
										<li>한국산업의 고객만족도 (KCSI) 1위</li>
										<li>세계 최초, 전관 Digital 시스템 도입</li>
										<li>코엑스점 연간 관객 세계 신기록 수립(620만명)</li>
										<li>투지브이 M관 첫 오픈</li>
									</ul>
									<p>(주)씨너스</p>
									<ul class="dot-list">
										<li>국내 최초, 영화관 내 공연 시도</li>
										<li>국내 최초, 단편영화 동시 개봉</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2004</span></p>

								<div class="year-info">
									<p>투지브이 씨네플렉스(주)</p>
									<ul class="dot-list mb30">
										<li>국가고객만족도 (NCSI) 1위</li>
										<li>한국산업의 고객만족도 (KCSI) 1위</li>
										<li>국내 최초, DIGITAL 시스템 도입</li>
										<li>코엑스점 1일 최다 관객 신기록 수립 (6월 28일, 31,372명)</li>
										<li>제1회 일본 영화제 개최</li>
									</ul>
									<p>㈜씨너스</p>
									<ul class="dot-list">
										<li>(주)씨너스 설립</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2003</span></p>

								<div class="year-info">
									<p>투지브이 씨네플렉스(주)</p>
									<ul class="dot-list">
										<li>고객만족 경영대상(CSMA) 최우수상 수상</li>
										<li>제1회 서울 유럽영화제 개최</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2002</span></p>

								<div class="year-info">
									<p>투지브이 씨네플렉스(주)</p>
									<ul class="dot-list">
										<li>한국산업의 고객만족도 (KCSI) 1위</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2001</span></p>

								<div class="year-info">
									<p>투지브이 씨네플렉스(주)</p>
									<ul class="dot-list">
										<li>업계 최초 전략적 마케팅 기법 도입(가격차별화, 멤버십 시스템, 하루 빠른 개봉)</li>
										<li>국가고객만족도 (NCSI) 1위</li>
										<li>한국산업의 고객만족도 (KCSI) 1위</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>2000</span></p>

								<div class="year-info">
									<p>투지브이 씨네플렉스(주)</p>
									<ul class="dot-list">
										<li>코엑스점 (17개관) 오픈</li>
										<li>세계 최단기간, 100만 관객 돌파(85일)</li>
									</ul>
								</div>
							</li>
							<li>
								<p class="year"><span>1999</span></p>

								<div class="year-info">
									<p>투지브이 씨네플렉스(주)</p>
									<ul class="dot-list">
										<li>투지브이 씨네플렉스(주) 설립</li>
									</ul>
								</div>
							</li>
						</ul>
					</div>
					<!--// 2018 - 2010 -->
				</div>
			</div>

			<div class="inner-wrap padding-type pb0 contentCompany contentMap" style="display: none;">
				<div class="location-map mb80">
					<h2 class="tit">오시는 길</h2>
					<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3165.134121204804!2d127.05059697635335!3d37.504754727667475!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x357ca1c32408f9b7%3A0x4e3761a4f356d1eb!2z7IyN7Jqp6rWQ7Jyh7IS87YSw!5e0!3m2!1sko!2skr!4v1764231739876!5m2!1sko!2skr" width="1100" height="450" style="border:2px solid #C0C0C0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
					<div id="map2"></div>
				</div>
				<div class="location-add">
					<h2 class="tit">2GV쌍용(주)</h2>
					<ul class="dot-list mb80">
						<li><span>주 소</span> : 서울특별시 강남구 테헤란로70길 12 H타워 9층</li>
						<li><span>대표전화</span> : 1544-0070</li>
					</ul>
					<h2 class="tit">교통안내</h2>
					<ul class="dot-list">
						<li>버스
							<ul class="dash-list">
								<li>서울특별시 간선버스 360번</li>
							</ul>
						</li>
						<li>지하철
							<ul class="dash-list">
								<li>2호선 선릉역 1번출구 도보 8분</li>
							</ul>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!--// container -->
<!-- 		</div> -->
		

	<!-- footer -->
	<footer id="footer">
	<jsp:include page="../../fragments/footer.jsp"/>
	</footer>
	<!--// footer -->
</div>
	<!--// body-wrap -->
</body>
</html>