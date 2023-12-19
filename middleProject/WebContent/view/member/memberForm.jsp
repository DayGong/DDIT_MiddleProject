<%@page import="kr.or.ddit.vo.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/memberForm.css">

<!-- 예쁜 Alert창 -->
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<%
   // 세션에 저장한 데이터 가져오기
   MemberVO memVo = (MemberVO)session.getAttribute("loginMember");
%>
<script>
document.addEventListener("DOMContentLoaded", function() {
<%
	if(memVo == null){
%>
		swal
		({
			title: "로그인이 필요합니다.", 
			text: "로그인 페이지로 이동합니다.", 
			icon: "info"
		}).then(function()
		{
			window.location.href = '<%=request.getContextPath()%>/view/login_out/loginMain.jsp';
		})
<%
	}
%>
});

</script>
</head>
<body>
<!-- 상단 메뉴바 -->
<jsp:include page="/view/main/top.jsp"/>
<div class="container">
    <h1>마이페이지</h1>
    <div class="user-info">
        <img src="<%=request.getContextPath()%>/images/login/꿈돌2.png" style="width:170px; height:170px;">
     <div class="user-details">
<p>* 이름 : <%=memVo.getMem_name()%></p>  
<p>* ID : <%=memVo.getMem_id()%></p>  
<p>* 주소 : <%=memVo.getMem_addr()%></p>  
      </div>
            <br>
<a href="<%=request.getContextPath()%>/member/updateMember.do">회원수정</a>
<a href="<%=request.getContextPath()%>/member/logoutMember.do">로그아웃</a> 
<a href="<%=request.getContextPath()%>/view/withdraw/memberWithdraw.jsp">탈퇴</a>
        
    </div>
</div>
<div class= "alltop" style="margin-top: 130px;">
	<div class="row">
	<div>
  		<h2>마이페이지</h2>
		<div class="category-container"> 
			<div class="category-item"><a href="#" onclick = "changeIframe('<%=request.getContextPath()%>/view/member/memberinfo.jsp','내정보')">내정보</a></div>
	      	<div class="category-item"><a href="#" onclick = "changeIframe('<%=request.getContextPath()%>/test.jsp','예약조회')">예약조회 </a></div>
	      	<div class="category-item"><a href="#" onclick = "changeIframe('<%=request.getContextPath()%>/view/member/viewHotelReserve.jsp','예약조회')">예약조회 </a></div>
	      	<div class="category-item"><a href="#" onclick = "changeIframe('<%=request.getContextPath()%>/test.jsp','내 캘린더')">내 캘린더</a></div>
    	</div>
   	</div>
  
  	<div class="maincolumn">
  		<h2 id ="categoryTitle"> 원하시는 항목을 선택하세요</h2>
    	<div class="card">
      	<iframe id ="myIframe" name ="itr"></iframe>
     	<p>열심히 해볼게요 화이팅!</p>
      	</div>
    </div>
   </div>
<!-- 하단 메뉴바 삽입 -->
<jsp:include page="/view/main/bottom.jsp"/>
</body>
</html>