/*$(document).ready(function() {
	// 리뷰 작성 폼 초기화
	initReviewForm();
});
*/
/**
 * 리뷰 작성 폼 이벤트 바인딩
 */
function initReviewForm() {
	$('#reviewForm').on('submit', function(e) {
		e.preventDefault(); // 기본 폼 제출 방지

		// 입력값 가져오기
		const movieCode = $('#movieCode').val();
		const score = $('#reviewScore').val();
		const content = $('#reviewContent').val().trim();

		// 유효성 검사
		if (!validateReview(score, content)) {
			return false;
		}

		// 리뷰 제출
		submitReview(movieCode, score, content);
	});
}

/**
 * 리뷰 유효성 검사
 */
function validateReview(score, content) {
	// 평점 선택 확인
	if (!score) {
		alert('평점을 선택해주세요.');
		$('#reviewScore').focus();
		return false;
	}

	// 최소 글자 수 확인
	if (content.length < 10) {
		alert('관람평은 최소 10자 이상 작성해주세요.');
		$('#reviewContent').focus();
		return false;
	}

	// 최대 글자 수 확인
	if (content.length > 500) {
		alert('관람평은 최대 500자까지 작성 가능합니다.');
		$('#reviewContent').focus();
		return false;
	}

	return true;
}

/**
 * 리뷰 제출 (AJAX)
 */
function submitReview(movieCode, score, content) {
	// 제출 버튼 비활성화
	const $submitBtn = $('#reviewForm button[type="submit"]');
	const originalText = $submitBtn.html();
	$submitBtn.prop('disabled', true).html('등록 중...');

	// AJAX 요청
	$.ajax({
		url: '/prj2_movieWeb/user/movie/detail_review_write.jsp',
		type: 'POST',
		data: {
			movieCode: movieCode,
			score: score,
			content: content
		},
		success: function(response) {
			const result = response.trim();
			//console.log(result);
			if (result == 'true') {
				alert('관람평이 등록되었습니다.');
				// 폼 초기화
				$('#reviewScore').val('');
				$('#reviewContent').val('');

				// 새 댓글을 목록에 추가 (새로고침 없이)
				addNewReviewToList(score, content);
				
				// 버튼 복구
				  $submitBtn.prop('disabled', false).html(originalText);
			} else if (result == "noBook") {
				alert('영화 시청하셔야 관람평을 작성하실 수 있습니다..');
				$submitBtn.prop('disabled', false).html(originalText);
			}


			else {
				alert('관람평 등록에 실패했습니다. 다시 시도해주세요.');
				// 버튼 복구
				$submitBtn.prop('disabled', false).html(originalText);
			}
		},
		error: function(xhr, status, error) {
			console.error('AJAX 오류:', error);
			         console.error('상태:', status);
			         console.error('응답:', xhr.responseText);
			alert('오류가 발생했습니다. 다시 시도해주세요.');
			// 버튼 복구
			$submitBtn.prop('disabled', false).html(originalText);
		}
	});
}

/**
 * 새로 작성한 댓글을 목록에 추가
 */
function addNewReviewToList(score, content) {
    // 현재 날짜 생성
    const today = new Date();
    const dateStr = formatDate(today);
    
    // 세션에서 사용자 ID 가져오기
    // JSP에서 window.currentUserId로 설정해야 함
    const userId = window.currentUserId || '나';
    
    // HTML 이스케이프 (XSS 방지)
    const safeContent = escapeHtml(content);
    
    // 새 댓글 HTML 생성
    const newReviewHtml = `
        <div class="comment-item new-review" style="display: none; animation: fadeIn 0.5s;">
            <div class="comment-header">
                <div class="comment-user">
                    <div class="user-avatar">👤</div>
                    <span class="username">${userId}</span>
                </div>
            </div>
            <div class="comment-body">
                <div class="comment-rating">
                    <span class="rating-label">관람평</span>
                    <span class="rating-stars">⭐ ${score}점</span>
                </div>
                <p class="comment-text">${safeContent}</p>
                <span class="comment-time">${dateStr} (방금 전)</span>
            </div>
        </div>
    `;
    
    // 빈 메시지가 있으면 제거
    $('#emptyMessage').remove();
    
    // 댓글 목록 맨 위에 추가
    $('#reviewListContainer').prepend(newReviewHtml);
    
    // 슬라이드 다운 애니메이션
    $('.new-review').slideDown(500, function() {
        $(this).removeClass('new-review');
        // 하이라이트 효과 추가
        $(this).css('background-color', '#fffacd');
        setTimeout(() => {
            $(this).animate({ backgroundColor: 'transparent' }, 1000);
        }, 500);
    });
    
    // 댓글 개수 업데이트
    updateReviewCount();
}

/**
 * 날짜 포맷팅 (YYYY-MM-DD)
 */
function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hour = String(date.getHours()).padStart(2, '0');
    const min = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day} ${hour}-${min}`;
}

/**
 * HTML 이스케이프 (XSS 방지)
 */
function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return String(text).replace(/[&<>"']/g, function(m) { 
        return map[m]; 
    });
}

/**
 * 댓글 개수 업데이트
 */
function updateReviewCount() {
    const $title = $('.comment-area .content-title');
    if ($title.length > 0) {
        const currentText = $title.text();
        const match = currentText.match(/(\d+)개의 이야기/);
        if (match) {
            const currentCount = parseInt(match[1]);
            const newCount = currentCount + 1;
            const newText = currentText.replace(/(\d+)개의 이야기/, newCount + '개의 이야기');
            $title.text(newText);
        }
    }
}
