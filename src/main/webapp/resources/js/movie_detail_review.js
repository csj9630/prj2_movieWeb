$(document).ready(function() {
    
    // ============================================
    // 1. 메뉴 토글 기능
    // ============================================
    function toggleMenu(commentId) {
        var $menu = $('#menu-' + commentId);
        
        // 다른 메뉴 닫기
        $('.menu-dropdown').not($menu).hide();
        
        // 현재 메뉴 토글
        $menu.toggle();
    }
    
    // ============================================
    // 2. 댓글 수정 모드 전환
    // ============================================
    function editComment(commentId) {
        var $commentContent = $('#comment-' + commentId).find('.comment-content');
        var currentText = $commentContent.text().trim();
        
        // 기존 내용 데이터 속성으로 저장
        $commentContent.data('original-text', currentText);
        
        var editHtml = 
            '<div class="edit-area">' +
                '<textarea id="edit-textarea-' + commentId + '" class="edit-textarea">' + 
                currentText + '</textarea>' +
                '<div class="edit-buttons">' +
                    '<button class="btn-save" data-comment-id="' + commentId + '">저장</button>' +
                    '<button class="btn-cancel" data-comment-id="' + commentId + '">취소</button>' +
                '</div>' +
            '</div>';
        
        $commentContent.html(editHtml);
        
        // 자동 포커스 및 높이 조절
        var $textarea = $('#edit-textarea-' + commentId);
        $textarea.focus();
        autoResizeTextarea($textarea);
        
        toggleMenu(commentId);
    }
    
    // ============================================
    // 3. 댓글 수정 저장
    // ============================================
    function saveComment(commentId) {
        var newContent = $('#edit-textarea-' + commentId).val().trim();
        var $commentContent = $('#comment-' + commentId).find('.comment-content');
        var $saveBtn = $('.btn-save[data-comment-id="' + commentId + '"]');
        
        if (!newContent) {
            alert('내용을 입력해주세요.');
            return;
        }
        
        // 로딩 상태
        $saveBtn.prop('disabled', true).text('저장 중...');
        
        $.ajax({
            url: 'updateComment.jsp',
            type: 'POST',
            data: {
                commentId: commentId,
                content: newContent
            },
            dataType: 'json',
            success: function(data) {
                if (data.success) {
                    $commentContent.text(newContent);
                    showToast('수정되었습니다.');
                } else {
                    alert('수정 실패: ' + (data.message || ''));
                    cancelEdit(commentId);
                }
            },
            error: function(xhr, status, error) {
                alert('수정 중 오류가 발생했습니다.');
                console.error(error);
                cancelEdit(commentId);
            },
            complete: function() {
                $saveBtn.prop('disabled', false).text('저장');
            }
        });
    }
    
    // ============================================
    // 4. 댓글 수정 취소
    // ============================================
    function cancelEdit(commentId) {
        var $commentContent = $('#comment-' + commentId).find('.comment-content');
        var originalText = $commentContent.data('original-text');
        $commentContent.text(originalText);
    }
    
    // ============================================
    // 5. 댓글 삭제
    // ============================================
    function deleteComment(commentId) {
        if (!confirm('정말 삭제하시겠습니까?')) {
            return;
        }
        
        var $comment = $('#comment-' + commentId);
        
        $.ajax({
            url: 'deleteComment.jsp',
            type: 'POST',
            data: {
                commentId: commentId
            },
            dataType: 'json',
            beforeSend: function() {
                $comment.css('opacity', '0.5');
            },
            success: function(data) {
                if (data.success) {
                    $comment.slideUp(300, function() {
                        $(this).remove();
                        updateCommentCount();
                    });
                    showToast('삭제되었습니다.');
                } else {
                    alert('삭제 실패: ' + (data.message || ''));
                    $comment.css('opacity', '1');
                }
            },
            error: function(xhr, status, error) {
                alert('삭제 중 오류가 발생했습니다.');
                console.error(error);
                $comment.css('opacity', '1');
            }
        });
    }
    
    // ============================================
    // 6. 토스트 메시지 표시
    // ============================================
    function showToast(message) {
        var $toast = $('<div class="toast">' + message + '</div>');
        $('body').append($toast);
        
        setTimeout(function() {
            $toast.addClass('show');
        }, 100);
        
        setTimeout(function() {
            $toast.removeClass('show');
            setTimeout(function() {
                $toast.remove();
            }, 300);
        }, 2000);
    }
    
    // ============================================
    // 7. 댓글 개수 업데이트
    // ============================================
    function updateCommentCount() {
        var count = $('.comment-item').length;
        $('#comment-count').text(count);
    }
    
    // ============================================
    // 8. 텍스트 영역 자동 높이 조절
    // ============================================
    function autoResizeTextarea($textarea) {
        $textarea.css('height', 'auto');
        $textarea.css('height', $textarea[0].scrollHeight + 'px');
    }
    
    // ============================================
    // 이벤트 리스너 등록
    // ============================================
    
    // 메뉴 버튼 클릭
    $(document).on('click', '.menu-btn', function(e) {
        e.stopPropagation();
        var commentId = $(this).data('comment-id') || 
                       $(this).closest('.comment-menu').find('.menu-dropdown').attr('id').replace('menu-', '');
        toggleMenu(commentId);
    });
    
    // 수정 버튼 클릭
    $(document).on('click', '.menu-dropdown button:contains("수정")', function() {
        var commentId = $(this).closest('.menu-dropdown').attr('id').replace('menu-', '');
        editComment(commentId);
    });
    
    // 삭제 버튼 클릭
    $(document).on('click', '.menu-dropdown button:contains("삭제")', function() {
        var commentId = $(this).closest('.menu-dropdown').attr('id').replace('menu-', '');
        deleteComment(commentId);
    });
    
    // 저장 버튼 클릭
    $(document).on('click', '.btn-save', function() {
        var commentId = $(this).data('comment-id');
        saveComment(commentId);
    });
    
    // 취소 버튼 클릭
    $(document).on('click', '.btn-cancel', function() {
        var commentId = $(this).data('comment-id');
        cancelEdit(commentId);
    });
    
    // 외부 클릭 시 메뉴 닫기
    $(document).on('click', function(event) {
        if (!$(event.target).closest('.comment-menu').length) {
            $('.menu-dropdown').hide();
        }
    });
    
    // ESC 키로 수정 취소
    $(document).on('keydown', '.edit-textarea', function(e) {
        if (e.key === 'Escape') {
            var commentId = $(this).attr('id').replace('edit-textarea-', '');
            cancelEdit(commentId);
        }
    });
    
    // 텍스트 영역 입력 시 자동 높이 조절
    $(document).on('input', '.edit-textarea', function() {
        autoResizeTextarea($(this));
    });
    
    // ============================================
    // 전역 함수로 노출 (HTML onclick에서 사용 가능)
    // ============================================
    window.toggleMenu = toggleMenu;
    window.editComment = editComment;
    window.deleteComment = deleteComment;
    
});