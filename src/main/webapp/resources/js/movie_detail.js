//***** 탭 기능 함수
function changeTab(){
	const tabs = document.querySelectorAll(".tab");
	  const tabContents = document.querySelectorAll(".tab-content");

	  tabs.forEach((tab) => {
	    tab.addEventListener("click", function () {
	      const targetTab = this.getAttribute("data-tab");

	      // 모든 탭과 콘텐츠에서 active 클래스 제거
	      tabs.forEach((t) => t.classList.remove("active"));
	      tabContents.forEach((content) => content.classList.remove("active"));

	      // 클릭한 탭과 해당 콘텐츠에 active 클래스 추가
	      this.classList.add("active");
	      document.getElementById(targetTab).classList.add("active");
	    });
	  });
}//func

///*****  비디오 변경 함수
function changeVideo(videoUrl, element) {
  const mainVideo = document.getElementById("mainVideo");
  mainVideo.src = videoUrl + "?autoplay=1";

  // 모든 썸네일에서 active 클래스 제거
  document.querySelectorAll(".video-thumbnail").forEach((thumb) => {
    thumb.classList.remove("active");
  });

  // 클릭한 썸네일에 active 클래스 추가
  element.classList.add("active");
}

///***** 영화소개글(intro)에 자동 개행 및 태그 적용. 
function introDivider() {
	 let text = $("#movie_intro").html().trim();

	    // 1) HTML 태그 제거 (<br>, <p> 등)
	    text = text.replace(/<[^>]+>/g, " ");

	    // 2) 줄바꿈을 공백으로 통합
	    text = text.replace(/\s+/g, " ").trim();

	    // 3) 문장 단위 분리 (. ! ?)
	    let sentences = text.split(/(?<=[.!?])\s+/);

	    // 4) 공백 문장 제거
	    sentences = sentences.map(s => s.trim()).filter(s => s.length > 0);
	    
	    // 5) 출력 생성
	    let result = "";
	    if (sentences.length > 0) {
	        result += '<h2 class="content-title">'+sentences[0]+'</h2>';
	    }
	    for (let i = 1; i < sentences.length; i++) {
	        result += '<p class="content-text">'+sentences[i]+'</p>';
	    }

	    $("#movie_intro").html(result);
}//introDivider



//-------스틸컷 이미지 클릭 시 모달로 확대-------------
///***** 이미지 모달 초기화
function initImageModal() {
	// 모달 HTML 동적 추가
	if ($('#imageModal').length === 0) {
		$('body').append(`
			<div class="image-modal" id="imageModal">
				<button class="modal-close" id="closeModal">&times;</button>
				<div class="modal-content">
					<img id="modalImage" src="" alt="">
				</div>
			</div>
		`);
	}

	// 이미지 클릭 이벤트
	$('.image-grid .image-item img').click(function() {
		const imgSrc = $(this).attr('src');
		console.log(imgSrc);
		const imgAlt = $(this).attr('alt');
		
		$('#modalImage').attr('src', imgSrc).attr('alt', imgAlt);
		$('#imageModal').addClass('active');
		$('body').css('overflow', 'hidden');
	});

	// 모달 닫기
	$('#closeModal, #imageModal').click(function(e) {
		if (e.target === this) {
			closeImageModal();
		}
	});

	// ESC 키로 모달 닫기
	$(document).keydown(function(e) {
		if ($('#imageModal').hasClass('active') && e.key === 'Escape') {
			closeImageModal();
		}
	});

	// 모달 내부 클릭 시 전파 중지
	$('.modal-content').click(function(e) {
		e.stopPropagation();
	});
}

///***** 이미지 확대 닫기
function closeImageModal() {
	$('#imageModal').removeClass('active');
	$('body').css('overflow', 'auto');
}

//*********댓글 토글 메뉴 관련*********
// 메뉴 토글 (클릭 시 열기/닫기)
function toggleMenu(commentId) {
    const menu = document.getElementById('menu-' + commentId);
    const isVisible = menu.style.display === 'block';
    
    // 다른 열린 메뉴 모두 닫기
    document.querySelectorAll('.menu-dropdown').forEach(m => {
        m.style.display = 'none';
    });
    
    // 현재 메뉴 토글
    menu.style.display = isVisible ? 'none' : 'block';
}

// 댓글 수정
function editComment(commentId) {
    // 수정 모드로 전환
    const commentContent = document.querySelector(`#comment-${commentId} .comment-content`);
    const currentText = commentContent.textContent;
    
    commentContent.innerHTML = `
        <textarea id="edit-textarea-${commentId}" class="edit-textarea">${currentText}</textarea>
        <div class="edit-buttons">
            <button onclick="saveEdit(${commentId})">저장</button>
            <button onclick="cancelEdit(${commentId}, '${currentText}')">취소</button>
        </div>
    `;
    
    toggleMenu(commentId);
}
