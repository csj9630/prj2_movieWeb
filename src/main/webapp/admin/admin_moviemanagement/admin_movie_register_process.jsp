<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="movie.image_admin.AdminImageDAO"%>
<%@page import="movie.movie_admin.MovieDAO"%>
<%@page import="movie.movie_admin.MovieDTO"%>
<%@page import="movie.admin.AdminMovieService"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.File"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%!
    // 1. 유튜브 ID 추출 메소드
    public String getYouTubeId(String url) {
        if(url == null || url.trim().isEmpty()) return null;
        String pattern = "(?<=watch\\?v=|/videos/|embed\\/|youtu.be\\/|\\/v\\/|\\/e\\/|watch\\?v%3D|watch\\?feature=player_embedded&v=|%2Fvideos%2F|embed%\u200C\u200B2F|youtu.be%2F|%2Fv%2F)[^#\\&\\?\\n]*";
        Pattern compiledPattern = Pattern.compile(pattern);
        Matcher matcher = compiledPattern.matcher(url);
        if (matcher.find()) return matcher.group();
        return url;
    }

    // 2. 파일 복사 메소드 (이동 X, 복사 O)
    // 원본을 유지하면서 대상 경로에 복사합니다. (양쪽 저장을 위해 필수)
    public boolean copyFile(File srcFile, File destFile) {
        // 상위 폴더(mc011)가 없으면 생성
        if (!destFile.getParentFile().exists()) {
            destFile.getParentFile().mkdirs();
        }
        
        // 대상 파일이 이미 존재하면 삭제 (덮어쓰기)
        if (destFile.exists()) {
            destFile.delete();
        }

        try (FileInputStream fis = new FileInputStream(srcFile);
             FileOutputStream fos = new FileOutputStream(destFile)) {
            
            byte[] buffer = new byte[1024];
            int length;
            while ((length = fis.read(buffer)) > 0) {
                fos.write(buffer, 0, length);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. 서버 경로와 워크스페이스 경로 양쪽에 저장하는 메소드
    public void saveToBoth(String tempPath, String serverBase, String workspaceBase, String srcFileName, String destCode, String destFileName) {
        if(srcFileName == null) return;
        
        File tempFile = new File(tempPath, srcFileName);
        if(!tempFile.exists()) return;

        // 1) 서버 배포 경로(Real Path)에 저장 (웹에서 즉시 확인용)
        File serverFile = new File(serverBase + File.separator + destCode, destFileName);
        copyFile(tempFile, serverFile);
        
        // 2) 이클립스 워크스페이스 경로(Local Path)에 저장 (영구 보관용)
        if(workspaceBase != null && !workspaceBase.isEmpty()) {
            File localFile = new File(workspaceBase + File.separator + destCode, destFileName);
            copyFile(tempFile, localFile);
        }
    }
%>

<%
    request.setCharacterEncoding("UTF-8");
    
    // ==========================================
    // [설정 1] 경로 설정
    // ==========================================
    String root = application.getRealPath("/");
    // 1. 서버 실행 경로
    String serverUploadPath = root + "resources" + File.separator + "images" + File.separator + "movieImg";
    // 2. 임시 저장소
    String tempPath = serverUploadPath + File.separator + "temp";
    
    // 3. ★ 이클립스 워크스페이스 경로 (본인 컴퓨터 경로로 수정 필수) ★
    String workspacePath = "C:/Users/user/git/repository/sist_prj2_movieWeb/src/main/webapp/resources/images/movieImg"; 

    File tempDir = new File(tempPath);
    if(!tempDir.exists()) tempDir.mkdirs();
    
    int maxSize = 1024 * 1024 * 100; // 100MB
    String encoding = "UTF-8";
    
    // ==========================================
    // [설정 2] 파일 업로드 (Temp 저장)
    // ==========================================
    MultipartRequest mr = new MultipartRequest(request, tempPath, maxSize, encoding, new DefaultFileRenamePolicy());
    
    String mode = mr.getParameter("mode");
    String id = mr.getParameter("id"); 
    
    MovieDTO mDTO = new MovieDTO();
    mDTO.setMovieName(mr.getParameter("name"));
    mDTO.setMovieGenre(mr.getParameter("genre"));
    mDTO.setRunningTime(mr.getParameter("time"));
    mDTO.setMovieGrade(mr.getParameter("grade"));
    mDTO.setReleaseDate(mr.getParameter("release"));
    mDTO.setShowing(mr.getParameter("showing"));
    mDTO.setIntro(mr.getParameter("intro"));
    mDTO.setDirectorNames(mr.getParameter("director"));
    mDTO.setActorNames(mr.getParameter("actors"));

    String uploadMain = mr.getFilesystemName("mainImage");
    String uploadBg = mr.getFilesystemName("bgImage");
    String trailerJoined = mr.getParameter("trailerList");
    
    AdminMovieService as = AdminMovieService.getInstance();
    boolean result = false;
    String targetCode = id; 

    // ==========================================
    // [Step 1] DB Insert / Update
    // ==========================================
    if("insert".equals(mode)){
        // 등록 시엔 파일명 임시값
        mDTO.setMainImage("temp"); 
        mDTO.setBgImage("temp");
        
        result = as.registerMovie(mDTO);
        
        if(result) {
            targetCode = MovieDAO.getInstance().selectMaxMovieCode();
            mDTO.setMovieCode(targetCode); 
        }
    } else {
        mDTO.setMovieCode(id); 
        String prevMain = mr.getParameter("prevMainImage");
        String prevBg = mr.getParameter("prevBgImage");
        
        // 새 파일이 없으면 기존 것 유지, 있으면 아래 파일 처리 로직에서 덮어씌워짐
        mDTO.setMainImage((uploadMain == null) ? prevMain : targetCode + "_poster.jpg");
        mDTO.setBgImage((uploadBg == null) ? prevBg : targetCode + "_bg.jpg");
        
        result = as.modifyMovie(mDTO);
    }

    // ==========================================
    // [Step 2] 파일 복사 및 최종 처리
    // ==========================================
    if(result && targetCode != null) {
        
        // 1) 메인 포스터 처리
        if(uploadMain != null) {
            String newName = targetCode + "_poster.jpg";
            saveToBoth(tempPath, serverUploadPath, workspacePath, uploadMain, targetCode, newName);
            
            // DB 업데이트 (Insert일 때 필수, Update일 때도 확실히 하기 위해)
            mDTO.setMainImage(newName);
            as.modifyMovie(mDTO); 
        }
        
        // 2) 배경 이미지 처리
        if(uploadBg != null) {
            String newName = targetCode + "_bg.jpg";
            saveToBoth(tempPath, serverUploadPath, workspacePath, uploadBg, targetCode, newName);
            
            // DB 업데이트 (MOVIE 테이블만 업데이트하고 MOVIE_IMAGE엔 넣지 않음)
            mDTO.setBgImage(newName);
            as.modifyMovie(mDTO);
        }
        
        // 3) 스틸컷 6장 처리
        for(int i=1; i<=6; i++) {
            String uploadStill = mr.getFilesystemName("stillCut" + i);
            if(uploadStill != null) {
                String seqStr = String.format("%03d", i); 
                String newName = targetCode + "_still_" + seqStr + ".jpg";
                
                // 파일 저장
                saveToBoth(tempPath, serverUploadPath, workspacePath, uploadStill, targetCode, newName);
                
                // [핵심] DB 중복 방지: 해당 파일명을 가진 데이터가 있다면 먼저 삭제
                AdminImageDAO.getInstance().deleteImageByPath(newName);
                
                // 그 다음 새 데이터 Insert
                as.registerMovieImage(newName, targetCode);
            }
        }

        // 4) 트레일러 처리
        if(trailerJoined != null) { 
            String[] urls = trailerJoined.split(",");
            for(int i=0; i<urls.length; i++) urls[i] = getYouTubeId(urls[i]);
            as.registerMovieTrailer(urls, targetCode);
        }
    }
    
    JSONObject json = new JSONObject();
    json.put("result", result);
    out.print(json.toJSONString());
%>