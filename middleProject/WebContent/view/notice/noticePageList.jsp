<%@page import="java.util.ArrayList"%>
<%@page import="kr.or.ddit.vo.NoticeVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
List<NoticeVO> noticeList = (List<NoticeVO>) request.getAttribute("noticeList");
//이전에 선택된 페이지 번호를 가져오기
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;

// 전체 공지사항 수
int totalNotices = (noticeList != null) ? noticeList.size() : 0;

// 한 페이지에 보여줄 공지사항 수
int noticesPerPage = 10;

// 전체 페이지 수
int totalPages = (int) Math.ceil((double) totalNotices / noticesPerPage);

// 현재 페이지에서 보여줄 공지사항의 시작 인덱스와 끝 인덱스 계산
int startIndex = (currentPage - 1) * noticesPerPage;
int endIndex = Math.min(startIndex + noticesPerPage - 1, totalNotices - 1);

// 현재 페이지에 해당하는 공지사항만 가져오기
List<NoticeVO> currentPageNotices = new ArrayList<>();
if (noticeList != null) {
    currentPageNotices = noticeList.subList(startIndex, endIndex + 1);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 목록</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
	crossorigin="anonymous"></script>
</head>

<body>
	<div class="card-body">
		<div class="table-responsive">
			<table class="table table-bordered" id="dataTable" width="100%"	cellspacing="0">

				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성날짜</th>
					<th>조회수</th>
					<th>첨부</th>
				</tr>
			<% 
				if (totalNotices == 0) {
			%>
			
				<tr>
					<td colspan="5">공지사항이 존재하지 않습니다.</td>
				</tr>
				
			<%
				} else {
				for (NoticeVO noticeVO : currentPageNotices) {
			%>
			
				<tr onclick="location.href='./detail.do?noticeNo=<%=noticeVO.getNoticeNo()%>'" style="cursor:pointer">
					<td><%=noticeVO.getNoticeNo()%></td>
					<td><%=noticeVO.getNoticeTitle()%></td>
					<td><%=noticeVO.getNoticeDate()%></td>
					<td><%=noticeVO.getNoticeHits()%></td>
					<td><%=noticeVO.getNoticeFile()%></td>
				</tr>

			<%
				}
			}
			%>

				<tr align="right">
					<td colspan="5"><a href="<%=request.getContextPath() %>/notice/insert.do">[게시글쓰기]</a></td>
				</tr>
			</table>

			<!-- 이전, 페이지 선택(5개), 다음 버튼 -->
        <div align="center">
            <ul class="pagination">
                <% if (currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="?page=<%=currentPage - 1%>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                <% } %>
                
                <%-- 페이지 선택(최대 5개까지) --%>
                <% int pageRange = Math.min(5, totalPages); %>
                <% int startPage = Math.max(1, currentPage - 2); %>
                <% int endPage = Math.min(startPage + pageRange - 1, totalPages); %>
                <% for (int i = startPage; i <= endPage; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="?page=<%=i%>"><%=i%></a>
                    </li>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="?page=<%=currentPage + 1%>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</body>
</html>