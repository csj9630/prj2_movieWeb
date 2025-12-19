<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
      /* 
         [Reset 및 공통 스타일 제외] 
      */

      /* 헤더 영역 보정 */
      #header {
        border-bottom: 1px solid #ddd;
        padding-bottom: 10px;
      }

      /* 브레드크럼 */
      .breadcrumb {
        background-color: #f8f8f8;
        padding: 10px 0;
        font-size: 12px;
        color: #888;
        border-bottom: 1px solid #eee;
      }

      .breadcrumb-list {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        list-style: none;
        gap: 8px;
        margin: 0;
        padding: 0;
      }

      .breadcrumb-list li {
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .breadcrumb-list a {
        color: #888;
        text-decoration: none;
        transition: color 0.2s;
      }

      .breadcrumb-list a:hover {
        color: #3e2675;
        text-decoration: underline;
      }

      .breadcrumb-list .current {
        color: #333;
        font-weight: 500;
      }

      .breadcrumb-separator {
        color: #ccc;
      }

      /* 페이지 레이아웃 */
      .page-wrap {
        display: flex;
        gap: 30px;
        margin-top: 30px;
        margin-bottom: 50px;
      }

      .main-content {
        flex: 1;
      }

      .page-title {
        font-size: 24px;
        font-weight: 700;
        color: #333;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #3e2675;
      }
      
      .btn-group {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 40px;
      }
      .btn-group button {
          width: 100px; height: 45px; cursor: pointer; border: 1px solid #ddd;
      }
      .btn-confirm { background-color: #3e2675; color: white; border: none; }
      .btn-cancel { background-color: white; color: #3e2675; border-color: #3e2675; }
      
      .withdraw-guide { font-size: 14px; line-height: 1.6; }
      .guide-section h4 { font-weight: 700; margin-bottom: 10px; }
      .guide-section ul { list-style: disc; padding-left: 20px; }
      
      .password-input-box {
          display: flex; align-items: center; background-color: #f8f8f8; padding: 20px; border: 1px solid #ddd;
      }
      .password-input-box input { flex:1; height: 40px; border: 1px solid #ddd; padding: 0 10px; }
      
      /* Auth box (Withdraw1) */
      .auth-box { border: 1px solid #a385e0; padding: 60px 40px; text-align: center; margin-top: 30px; }
      .auth-form { display: flex; justify-content: center; align-items: center; gap: 10px; margin-bottom: 40px; }
      .auth-input { width: 200px; height: 35px; border: 1px solid #ddd; padding: 0 10px; }
      
      /* Info (Withdraw2) */
      .form-table { width: 100%; border-top: 1px solid #333; border-bottom: 1px solid #ddd; border-collapse: collapse; margin-bottom: 40px; }
      .form-table th { background-color: #f8f8f8; text-align: left; padding: 15px; border-bottom: 1px solid #eee; }
      .form-table td { padding: 15px; border-bottom: 1px solid #eee; }
      .form-input { height: 35px; border: 1px solid #ddd; padding: 0 10px; width: 250px; }
      
      /* PW Change (Withdraw3) */
      .pw-change-box { max-width: 600px; margin: 50px auto; }
      .input-wrapper { position: relative; }
      .input-field { width: 100%; height: 45px; border: 1px solid #ddd; padding: 0 40px 0 15px; background-color: #f8f8f8; }

      /* Phone Group & Small Button */
      .phone-group { display: flex; align-items: center; gap: 5px; }
      .phone-input { width: 80px; height: 35px; border: 1px solid #ddd; padding: 0 10px; text-align: center; }
      .btn-small { height: 35px; padding: 0 15px; border: 1px solid #ccc; background-color: #ddd; color: #666; font-size: 13px; cursor: pointer; transition: background-color 0.2s; }
      .btn-small:hover { background-color: #ccc; }
      
      /* Withdraw Link Button */
      .btn-withdraw-link { height: 35px; padding: 0 15px; border: 1px solid #3e2675; background-color: #fff; color: #3e2675; font-size: 13px; cursor: pointer; margin-left: 10px; }
      .btn-withdraw-link:hover { background-color: #3e2675; color: #fff; }
    </style>
