<%@page import="announcement.AnnouncementDTO"%>
<%@page import="announcement.AnnouncementService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../fragments/siteProperty.jsp" %>

<%
    // 1. 파라미터 확인
    String numStr = request.getParameter("num");
    
    if(numStr == null || numStr.isEmpty()) {
        response.sendRedirect("announcementList.jsp?currentPage=" + numStr);
        return;
    }
    
    int num = Integer.parseInt(numStr);
    AnnouncementService as = AnnouncementService.getInstance();
    
    // 2. 조회수 증가
    as.modifyAnnounceViews(num);
    
    // 3. 상세 데이터 조회
    AnnouncementDTO ann = as.searchOneAnnouncement(num);
    
    if(ann == null) {
        out.println("<script>alert('삭제되었거나 존재하지 않는 게시물입니다.'); history.back();</script>");
        return;
    }
    
    pageContext.setAttribute("ann", ann);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">



<meta http-equiv="X-UA-Compatible" content="IE=edge">



<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">

<link rel="shortcut icon" href="${commonURL}/resources/images/favicon.ico"/>



<title>MEET PLAY SHARE, 투지브이</title>

<meta property="name" id="metaTagTitle" content="공지사항 &lt; 고객센터">

<meta property="description" id="metaTagDtls"

content="메가박스에서 전하는 다양한 소식을 안내해드립니다. ">

<meta property="keywords" id="metaTagKeyword"

content="메가박스,megabox,영화,영화관,극장,티켓,박스오피스,상영예정작,예매,오페라,싱어롱,큐레이션,필름소사이어티,클래식소사이어티,이벤트,Movie,theater,Cinema,film,Megabox">



<meta property="fb:app_id" id="fbAppId" content="546913502790694">



<meta property="og:site_name" id="fbSiteName" content="투지브이">

<meta property="og:type" id="fbType" content="movie">

<meta property="og:url" id="fbUrl"

content="https://www.megabox.co.kr/support/notice">

<meta property="og:title" id="fbTitle" content="공지사항 &lt; 고객센터">

<meta property="og:description" id="fbDtls"

content="메가박스에서 전하는 다양한 소식을 안내해드립니다. ">

<meta property="og:image" id="fbImg"

content="https://img.megabox.co.kr/SharedImg/metaTag/2020/02/04/gFfTzMwwiCxhBwcUV5TRGMFX9Cmoj64W.jpg">



<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css" media="all"/>

<!-- Global site tag (gtag.js) - Google Analytics -->

<script async="" src="${commonURL}/resources/js/gtm.js"></script>

<script async="" src="${commonURL}/resources/js/(1).js"></script>

<script>window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'G-5JL3VPLV2E');</script>

<script async="" src="${commonURL}/resources/js/(1).js"></script>

<script>window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'G-LKZN3J8B1J');</script>

<script src="${commonURL}/resources/js/megabox.api.min.js"></script>

<script src="${commonURL}/resources/js/lozad.min.js"></script>

<script src="${commonURL}/resources/js/megabox.common.min.js"></script>

<script

src="${commonURL}/resources/js/megabox.netfunnel.min.js"></script>

<script src="${commonURL}/resources/js/persona.js" async=""></script>



<script type="text/javascript">

</script>

<script src="${commonURL}/resources/js/ui.common.js"></script>

<script src="${commonURL}/resources/js/front.js"></script>

<script src="${commonURL}/resources/js/mY-0IB629DBzYOEEnKhjtbGN-ebqwB2nwwHbOkyvbheEAM4qWzAZAbZZRkVrbTdiQVR5YUdRaExKTVVQaWNRAstB2kb7ISRAEgPLQdpG-yEkQBI.js"></script>



<!-- Google Tag Manager -->

<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src= 'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f); })(window,document,'script','dataLayer','GTM-WG5DNB7D');</script>
</head>
<body>
    <div class="body-wrap">
        <header id="header">
            <jsp:include page="../../fragments/header.jsp"/>
        </header>
        
        <div id="container" class="container">
            <div class="page-util">
                <div class="inner-wrap">
                    <div class="location">
                        <span>Home</span>
                        <a href="announcementList.jsp" title="공지사항 페이지로 이동">공지사항</a>
                    </div>
                </div>
            </div>
            
            <div class="inner-wrap">
                <div id="contents">
                    <h2 class="tit">공지사항</h2>
                    <div class="table-wrap">
                        <div class="board-view">
                            <div class="tit-area">
                                <p class="tit">${ann.announce_name}</p>
                            </div>
                            <div class="info">
                                <p>
                                    <span class="tit">구분</span>
                                    <span class="txt">공지</span>
                                </p>
                                <p>
                                    <span class="tit">등록일</span>
                                    <span class="txt">
                                        <fmt:formatDate value="${ann.announce_date}" pattern="yyyy.MM.dd"/>
                                    </span>
                                </p>
                                <p>
                                    <span class="tit">조회수</span>
                                    <span class="txt">${ann.announce_views}</span>
                                </p>
                            </div>

                            <div class="cont">
                                ${ann.announce_content}
                            </div>
                        </div>
                    </div>

                    
                    <div class="btn-group pt40">
			    		<a href="announcementList.jsp?currentPage=${empty param.currentPage ? 1 : param.currentPage}&field=${param.field}&searchTxt=${param.searchTxt}" class="button large listBtn" title="목록">목록</a>
					</div>
                </div>
            </div>
        </div>
        
        <footer id="footer">
            <jsp:include page="../../fragments/footer.jsp"></jsp:include>
        </footer>
    </div>
</body>
</html>