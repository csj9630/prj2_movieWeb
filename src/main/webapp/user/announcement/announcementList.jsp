<%@ page import="java.util.List" %>
<%@ page import="announcement.AnnouncementService" %>
<%@ page import="announcement.AnnouncementDTO" %>
<%@ page import="announcement.RangeDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../../fragments/siteProperty.jsp" %>

<%
    // ---------------------------------------------------------
    // 1. 파라미터 수신 및 초기화
    // ---------------------------------------------------------
    String currentPageStr = request.getParameter("currentPage");
    String searchTxt = request.getParameter("searchTxt"); // 검색어
    String field = request.getParameter("field");         // 검색 조건(1:제목, 2:내용)

    int currentPage = 1;
    if(currentPageStr != null && !currentPageStr.isEmpty()){
    	try {
			currentPage = Integer.parseInt(currentPageStr);
		} catch(NumberFormatException nfe) {
		} // end try ~ catch
    }
    
    // RangeDTO의 getFieldStr() 로직상 field가 null이면 안되므로 기본값 "1"(제목) 설정
    if(field == null || field.isEmpty()) {
        field = "1";
    }

    // ---------------------------------------------------------
    // 2. Service & DTO 세팅
    // ---------------------------------------------------------
    AnnouncementService as = AnnouncementService.getInstance();
    RangeDTO rDTO = new RangeDTO();
    
    rDTO.setCurrentPage(currentPage);
    rDTO.setKeyword(searchTxt);
    rDTO.setField(field); 
    rDTO.setUrl(request.getRequestURI()); // 현재 페이지 URL 자동 설정

    // ---------------------------------------------------------
    // 3. DB 조회 (페이지네이션 계산)
    // ---------------------------------------------------------
    // 전체 게시물 수
    int totalCnt = as.totalCnt(rDTO);
    
    // 페이지당 게시물 수 (10개)
    int pageScale = as.pageScale();
    
    // 총 페이지 수 설정
    int totalPage = as.totalPage(totalCnt, pageScale);
    rDTO.setTotalPage(totalPage);
    
    // 시작/끝 번호 계산 (ROWNUM)
    int startNum = as.startNum(currentPage, pageScale);
    int endNum = as.endNum(startNum, pageScale);
    rDTO.setStartNum(startNum);
    rDTO.setEndNum(endNum);
    
    // 리스트 가져오기
    List<AnnouncementDTO> list = as.searchBoardList(rDTO);
    
    // 제목 줄임 처리 (20자 이상 ...)
    as.titleSubStr(list);
    
    // 페이지네이션 HTML 생성 (새로 추가한 메서드 사용)
    String pagination = as.paginationMegaBoxStyle(rDTO);
    
	// 4. 시작 번호
	
    // ---------------------------------------------------------
    // 4. EL 사용을 위한 Attribute 저장
    // ---------------------------------------------------------
    pageContext.setAttribute("announceList", list);
    pageContext.setAttribute("pagination", pagination);
    pageContext.setAttribute("totalCnt", totalCnt);
    // 검색창 유지를 위해
    pageContext.setAttribute("searchTxt", searchTxt); 
    pageContext.setAttribute("currentPage", currentPage);
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
                        <a href="${commonURL}/user/announcement/announcementList.jsp?currentPage=1" title="공지사항 페이지로 이동">공지사항</a>
                    </div>
                </div>
            </div>
            
            <div class="inner-wrap">
                <div id="contents">
                    <h2 class="tit" style="padding: 0px;">공지사항</h2>
                    
                    <div class="board-list-util">
                        <p class="result-count">
                            <strong>전체 <em class="font-gblue"><fmt:formatNumber value="${totalCnt}" pattern="#,###"/></em>건</strong>
                        </p>
                        
                        <form action="" method="get" name="searchForm">
                            <div class="board-search">
                                <input type="hidden" name="field" value="1">
                                
                                <input type="text" name="searchTxt" id="searchTxt" title="검색어를 입력해 주세요."
                                    placeholder="검색어를 입력해 주세요." class="input-text" 
                                    value="${not empty searchTxt ? searchTxt : ''}" maxlength="15">
                                <button type="submit" id="searchBtn" class="btn-search-input">검색</button>
                            </div>
                        </form>
                    </div>
                    
                    <div class="table-wrap">
                        <table class="board-list">
                            <caption>번호, 구분, 제목, 등록일이 들어간 공지사항 전체 리스트</caption>
                            <colgroup>
                                <col style="width: 72px;">
                                <col style="width: 95px;">
                                <col style="width: 817px;">
                                <col style="width: 116px;">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">구분</th>
                                    <th scope="col">제목</th>
                                    <th scope="col">등록일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty announceList}">
                                        <tr>
                                            <td colspan="4" style="text-align:center; padding: 50px;">등록된 게시물이 없습니다.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="ann" items="${announceList}">
                                            <tr>
                                                <td>${ann.announce_num}</td>
                                                <td>공지</td>
                                                <th class="subject">
                                                    <a href="announcementDetail.jsp?num=${ann.announce_num}&currentPage=${currentPage}&field=${param.field}&searchTxt=${param.searchTxt}" class="moveBtn" title="공지사항 상세보기">
													    ${ann.announce_name}
													</a>
                                                </th>
                                                <td><fmt:formatDate value="${ann.announce_date}" pattern="yyyy.MM.dd"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    
                    ${pagination}
                    
                </div>
            </div>
        </div>
        
        <footer id="footer">
            <jsp:include page="../../fragments/footer.jsp"></jsp:include>
        </footer>
    </div>
</body>
</html>